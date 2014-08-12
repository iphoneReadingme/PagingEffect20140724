/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: PageSplitRender.mm
 *
 * Description	: 章节分页并渲染
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/


#import <CoreText/CoreText.h>
#import "PageSplitRender.h"
#import "NovelBoxMacroDefine.h"
#import "NovelBoxConfig.h"
#import "iUCCommon.h"
#import "DDLog.h"

#define USE_HTIME_DUMP
#import "HTime.h"

#ifdef NDEBUG
static const int ddLogLevel = LOG_LEVEL_OFF;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#if ! __has_feature(objc_arc)
//[super dealloc];
#define DTCFAttributedStringRef        CFAttributedStringRef
#define DTCFStringRef                  CFStringRef
#define DTid                           id
#else
#define DTCFAttributedStringRef        __bridge CFAttributedStringRef
#define DTCFStringRef                  __bridge CFStringRef
#define DTid                           __bridge id
#endif // #if ! __has_feature(objc_arc)

#define FONTNAME                        @"STHeitiSC-Light"
#define FONTNAMEMedium                  @"STHeitiSC-Medium"

#define SPLIT_ERROR_SUBTITUTE           @"　　本章内容为空。"
#define SPLIT_ERROR_SUBTITUTE_ONLINE    @"　　本章URL为空。"


@interface NBFTCoreTextStyle : NSObject
@property (nonatomic, assign)CTTextAlignment textAlignment;
@property (nonatomic, assign)CGFloat fristlineindent;
@property (nonatomic, assign)CGFloat lineSpace;
@property (nonatomic, assign)CGFloat paragraphSpace;
@property (nonatomic, assign)CGFloat paragraphSpaceBefore;
@end

@implementation NBFTCoreTextStyle
@end


@interface PageSplitRender ()
{
    CTFramesetterRef  m_frameSetter;
}
@property (nonatomic, retain) BookLayoutConfig * layoutConfig;
@property (nonatomic, retain) NBChapterItem * chapterItem;
@property (nonatomic, retain) NBChapterPagesInfo * pagesInfo;
@property (nonatomic, retain) NSString * chapterTextContent;

@end

@implementation PageSplitRender

// 如果全是不可见字符, 则返回false. 如:空格" ", 或者是ASCII控制字符(包括换行回车, 及127 DEL), 对于没有UNICODE中没有编码的暂时不考虑
+ (bool)isVisibleString:(NSString*)checkText
{
	bool bRet = false;
	int i = 0;
	for (; i < [checkText length]; i++)
	{
		unichar ch = [checkText characterAtIndex:i];
		if (' ' < ch && ch != 127)
		{
			bRet = true;
			break;
		}
	}
	
	return bRet;
}

+ (NSString*)getChapterContentStr:(NSString*)content withChapterItem:(NBChapterItem*)chapterItem
{
	NSString *contentStr = content;
    
    if ((nil == contentStr) || (0 == [contentStr length]))
    {
        if (iUCCommon::is4inchDisplay())
        {
            contentStr = [NSString stringWithFormat:@"　　\n\n\n\n\n\n\n\n                     本章内容为空"];
        }
        else
        {
            contentStr = [NSString stringWithFormat:@"　　\n\n\n\n\n\n\n               本章内容为空"];
        }
    }
	
	return contentStr;
}

+ (NBChapterPagesInfo*)splittingPagesForString:(NSString*)content withChapterItem:(NBChapterItem*)chapterItem andLayoutConfig:(BookLayoutConfig*)config
{
    NBChapterPagesInfo * pagesInfo = [[[NBChapterPagesInfo alloc] init] autorelease];
    pagesInfo.chapterIndex = chapterItem.chapterIndex;
    if (content && ([content length] > 0))
    {
        NSString *contentStr = [PageSplitRender getChapterContentStr:content withChapterItem:chapterItem];
        pagesInfo.pageItems = [self _splittingPagesForString:contentStr withChapterItem:chapterItem andLayoutConfig:config];
    }
    
    if ((nil == pagesInfo.pageItems) || (0 == [pagesInfo.pageItems count]))
    {
        pagesInfo.isSplitError = YES;
        pagesInfo.errorSubstitute = SPLIT_ERROR_SUBTITUTE; // [chapterItem isOnlineChapter] ? SPLIT_ERROR_SUBTITUTE_ONLINE : SPLIT_ERROR_SUBTITUTE;
        pagesInfo.pageItems = [self _splittingPagesForString:pagesInfo.errorSubstitute withChapterItem:chapterItem andLayoutConfig:config];
        assert([pagesInfo.pageItems count]);
    }
    
    return pagesInfo;
}

// 返回 NBPageItem array
+ (NSMutableArray*)_splittingPagesForString:(NSString*)content withChapterItem:(NBChapterItem*)chapterItem andLayoutConfig:(BookLayoutConfig*)config
{
    HTIME_DUMP_IF("splittingPagesForString", 50);
    NSMutableArray *pageArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *contentStr = content;
    CTFramesetterRef framesetter = [PageSplitRender formatString:contentStr withChapterItem:chapterItem andLayoutConfig:config];
	CFIndex textRangeStart = 0;
    for(size_t i = 0; i < INT16_MAX; i++) {
        CGRect columnFrame = CGRectMake(i*config.pageWidth, 0, config.pageWidth, config.pageHeight);
        columnFrame = UIEdgeInsetsInsetRect(columnFrame, config.contentInset);
        CGMutablePathRef framePath = CGPathCreateMutable();
        CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
        CFRange textRange = CFRangeMake(textRangeStart, 0);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, framePath, NULL);
        CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
        NBPageItem *item = [[[NBPageItem alloc] init] autorelease];
        item.chapterIndex = chapterItem.chapterIndex;
        item.startInChapter = textRangeStart;
        item.length = visibleRange.length;
		item.pageIndex = i;
        
#ifdef ENABLE_Check_Page_Param
		NSRange rang = {item.startInChapter,item.length};
		NSString* chapterText = contentStr;
		chapterText = [NSString stringWithFormat:@"%@\n%@", chapterItem.chapterName, contentStr];
		NSString* pageTextContent = [chapterText substringWithRange:rang];
		NBMD_LOG_NSLOG(@"第[%4d]页, rang=(s=%d,e=%d), %d", (int)i, rang.location, rang.length, (rang.location+rang.length));
		NBMD_LOG_NSLOG(@"==[item.pageTextContent] = \n%@", pageTextContent);
		
		item.pageTextContent = pageTextContent;
#endif
		
        [pageArray addObject:item];
        textRangeStart += visibleRange.length;
        CFRelease(frame);
        CFRelease(framePath);
        if(textRangeStart >= [contentStr length]) ///< 删除最后一个全空页
        {
			NSString* strEnd = [contentStr substringFromIndex:visibleRange.location];
            strEnd = [strEnd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NBMD_LOG_NSLOG(@"最后一页面[%d]", (int)i);
			//NBMD_LOG_NSLOG(@"strEnd=%@", strEnd);
			if ((0 == [strEnd length]) || ![PageSplitRender isVisibleString:strEnd])
			{
				// 显示空白,则删除
				[pageArray removeObject:item];
			}
			break;
        }
    }
    
	CFRelease(framesetter);
    
    return pageArray;
}

/*格式化绘画样式*/
+ (CTFramesetterRef)formatString:(NSString *)contentStr withChapterItem:(NBChapterItem*)chapterItem andLayoutConfig:(BookLayoutConfig*)config
{
	BOOL bShowTitle = config.showBigTitle;   ///< 文字排版时是否显示标题
	int nStart = 0;
	int nTextLength = [contentStr length];  ///< 章节内容文字长度（不含标题文字）
	
	NSString* chapterText = contentStr;
	if (bShowTitle)
	{
		nStart = [chapterItem.chapterName length] + 2; ///< 补充2个换行符:　1.'\n',章节标题与章节内容之间换行; 2. '\n',标题与章节内容之间的间距（以一个空行来实现）
		chapterText = [NSString stringWithFormat:@"%@\n\n%@", chapterItem.chapterName, contentStr];
	}
	
    NSMutableAttributedString *attributedString = [[[NSMutableAttributedString alloc] initWithString:chapterText] autorelease];
    
	if (bShowTitle)
	{
		///< 格式化标题
		[PageSplitRender formatChapterTitle:attributedString withChapterItem:chapterItem andLayoutConfig:config];
	}
	
	// ucnovel离线小说首行没缩进，需要特殊处理
	CGFloat fontSize = config.fontSize;
    if (chapterItem.state == NBChapterStateOffline && chapterItem.shouldIndent)
    {
        for (NSInteger i = 0; i < kCountFontSizeOption; i++)
        {
            if (g_fontAndRowSpace[i].fontSize == fontSize)
            {
                config.firstLineHeadIndent = g_fontAndRowSpace[i].headIndent;
                break;
            }
        }
    }
	
	///< 格式化章节内容
	NSRange range = NSMakeRange(nStart, nTextLength);
	[PageSplitRender formatChapterContent:attributedString with:range andLayoutConfig:config];
    
	///< 创建framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((DTCFAttributedStringRef)attributedString);
    return framesetter;
}

+ (void)formatChapterTitle:(NSMutableAttributedString*)attributedString withChapterItem:(NBChapterItem*)chapterItem andLayoutConfig:(BookLayoutConfig*)config
{
	int nTitleLength = [chapterItem.chapterName length];
	NSRange range = NSMakeRange(0, nTitleLength);
	
	///< 1. 标题颜色
	UIColor* colorText = [UIColor blueColor];
	if (config != nil && config.pageTextColor != nil)
	{
		colorText = config.pageTextColor;
	}
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)colorText.CGColor range:range];
	
    ///< 2. 设置标题字体
	CGFloat fontSize = config.titleFontSize;
	NSString* fontName = FONTNAMEMedium;  ///< 标题加粗
	UIFont* fontObj = [PageSplitRender loadCustomBoldFont:fontName with:fontSize];
	
    CTFontRef font = CTFontCreateWithName((DTCFStringRef)fontObj.fontName, fontSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(DTid)font range:range];
    CFRelease(font);
    
	
	NBFTCoreTextStyle *stype = [[[NBFTCoreTextStyle alloc] init] autorelease];
	stype.textAlignment = kCTLeftTextAlignment;
	stype.fristlineindent = 0.0f;
	stype.lineSpace = config.lineSpace;
	stype.paragraphSpace = config.paragraphSpacing;
	stype.paragraphSpaceBefore = config.paragraphSpacing;
	
    //设置对齐方式、行间距、首行缩进
	[PageSplitRender formatTextAttributes:attributedString with:range withStyle:stype];
}

+ (void)formatChapterContent:(NSMutableAttributedString*)attributedString with:(NSRange &)range andLayoutConfig:(BookLayoutConfig*)config
{
	///< 1. 标题颜色
	UIColor* colorText = [UIColor blueColor];
	if (config != nil && config.pageTextColor != nil)
	{
		colorText = config.pageTextColor;
	}
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)colorText.CGColor range:range];
	
    ///< 2. 设置标题字体
	CGFloat fontSize = config.fontSize;
	UIFont* fontObj = [PageSplitRender loadCustomFont:[config fontName] with:fontSize];
	
    CTFontRef font = CTFontCreateWithName((DTCFStringRef)fontObj.fontName, fontSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(DTid)font range:range];
    CFRelease(font);
    
	NBFTCoreTextStyle *stype = [[[NBFTCoreTextStyle alloc] init] autorelease];
	stype.textAlignment = kCTLeftTextAlignment;
	stype.fristlineindent = config.firstLineHeadIndent;
	stype.lineSpace = config.lineSpace;
	stype.paragraphSpace = config.paragraphSpacing;
	stype.paragraphSpaceBefore = config.paragraphSpacing;
	
    //设置对齐方式、行间距、首行缩进
	[PageSplitRender formatTextAttributes:attributedString with:range withStyle:stype];
}

//#define Enable_Custom_font

+ (UIFont*)loadCustomBoldFont:(NSString*)fontName with:(int)fontSize
{
	UIFont* fontObj = nil;
	
	if (fontObj == nil)
	{
#ifdef Enable_Custom_font
		fontObj = [PageSplitRender loadCustomFont:fontSize];
#else
		fontObj = [UIFont fontWithName:fontName size:fontSize];
#endif
		if (fontObj == nil)
		{
			fontName = FONTNAMEMedium;
			[UIFont fontWithName:fontName size:fontSize];
		}
		if (fontObj == nil)
		{
			[UIFont boldSystemFontOfSize:fontSize];  ///< 系统字体;
		}
	}
	
	return fontObj;
}

+ (UIFont*)loadCustomFont:(NSString*)fontName with:(int)fontSize
{
	UIFont* fontObj = nil;
	
	if (fontObj == nil)
	{
#ifdef Enable_Custom_font
		fontObj = [PageSplitRender loadCustomFont:fontSize];
#else
		fontObj = [UIFont fontWithName:fontName size:fontSize];
#endif
		if (fontObj == nil)
		{
			fontName = FONTNAME;
			[UIFont fontWithName:fontName size:fontSize];
		}
		if (fontObj == nil)
		{
			[UIFont systemFontOfSize:fontSize];  ///< 系统字体;
		}
	}
	
	return fontObj;
}

#ifdef Enable_Custom_font
+ (UIFont*)loadCustomFont:(int)fontSize
{
	static UIFont* fontObj = nil;
	if (fontObj == nil)
	{
		fontObj = [PageSplitRender dynamicLoadFont2:fontSize];
		if (fontObj == nil)
		{
			fontObj = [UIFont systemFontOfSize:fontSize];  ///< 系统字体;
		}
	}
	
	return fontObj;
}

+ (NSString*)getFontFilePath2
{
	NSString* filePath = [NSString stringWithFormat:@"%@/Documents/huawenxingkai.ttf", NSHomeDirectory()];
	//filePath = [NSString stringWithFormat:@"%@/Documents/STxingkai_Normal.ttf", NSHomeDirectory()];
	
	BOOL bExist = NO;
	bExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	if (bExist != YES)
	{
		filePath = [NSString stringWithFormat:@"%@/Library/Application Support/others/huawenxingkai.ttf", NSHomeDirectory()];
		bExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	}
	
	if (bExist != YES)
	{
		filePath = nil;
	}
	
	return filePath;
}

+ (UIFont*)dynamicLoadFont2:(int)fontSize
{
	UIFont* fontObj = nil;
	
	//加载字体
	CFErrorRef error;
	NSString *fontPath = [PageSplitRender getFontFilePath2]; // a TTF file in iPhone Documents folder //字体文件所在路径
	if ([fontPath length] < 1)
	{
		return fontObj;
	}
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
	CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
	
	bool bRegister = CTFontManagerRegisterGraphicsFont(customFont, &error);
	// result = CTFontManagerUnregisterGraphicsFont((CGFontRef)embeddedFont.cgFont, NULL);
	///＜ 使用完之后，还要卸载
	
	if (!bRegister)
	{
		//如果注册失败，则不使用
		CFStringRef errorDescription = CFErrorCopyDescription(error);
		NSLog(@"Failed to load font: %@", errorDescription);
		CFRelease(errorDescription);
	}
	else
	{
		//字体名
		NSString *fontName = (__bridge NSString *)CGFontCopyFullName(customFont);
		NSLog(@"fontName=%@", fontName);
		fontObj = [UIFont fontWithName:fontName size:fontSize];
	}
	
	CFRelease(customFont);
	CGDataProviderRelease(fontDataProvider);
	
	return fontObj;
}
#endif // #ifdef Enable_Custom_font

+ (void)formatTextAttributes:(NSMutableAttributedString*)attributedString with:(NSRange &)range withStyle:(NBFTCoreTextStyle*)textStyle
{
    ///< 3. 创建文本对齐方式
    CTTextAlignment textAlignment = kCTJustifiedTextAlignment;//这种对齐方式会自动调整，使左右始终对齐
	textAlignment = textStyle.textAlignment;
    CTParagraphStyleSetting alignmentSet;
    alignmentSet.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentSet.valueSize=sizeof(textAlignment);
    alignmentSet.value=&textAlignment;
	
    /// 4. 首行缩进
    CGFloat fristlineindent = textStyle.fristlineindent;
    CTParagraphStyleSetting fristlineSet;
    fristlineSet.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristlineSet.value = &fristlineindent;
    fristlineSet.valueSize = sizeof(float);
    
	///< 5. 设置文本行间距
    CGFloat lineSpace = textStyle.lineSpace;
    CTParagraphStyleSetting lineSpacingSet;
    lineSpacingSet.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpacingSet.value = &lineSpace;
    lineSpacingSet.valueSize = sizeof(lineSpace);
	
	///< 6. 设置文本段间距
    CGFloat paragraphSpace = textStyle.paragraphSpace;
    CTParagraphStyleSetting paragraphSpacingSet;
    paragraphSpacingSet.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpacingSet.value = &paragraphSpace;
    paragraphSpacingSet.valueSize = sizeof(paragraphSpace);
	
	///< 7. 设置段前间距
    CGFloat paragraphSpaceBefore = textStyle.paragraphSpaceBefore;
    CTParagraphStyleSetting paragraphSpacingBeforeSet;
    paragraphSpacingBeforeSet.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    paragraphSpacingBeforeSet.value = &paragraphSpaceBefore;
    paragraphSpacingBeforeSet.valueSize = sizeof(paragraphSpaceBefore);
	
    //组合设置
    CTParagraphStyleSetting settings[] = {
		alignmentSet,
		fristlineSet,
        lineSpacingSet,
        paragraphSpacingSet,
        paragraphSpacingBeforeSet
    };
	
	//通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(CTParagraphStyleSetting));
	
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
	
    // set attributes to attributed string
    [attributedString addAttributes:attributes range:range];
}

/*格式化章节内容*/
+ (NSString *)normalizedContentText:(NSString *)content
{
    //替换分段符
    NSString *contentStr = [[[content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"] stringByReplacingOccurrencesOfString:@"[br]" withString:@"\n"];
    contentStr = [[contentStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    NSArray* array = [contentStr componentsSeparatedByString:@"\n"];
    NSMutableArray *newArray = [[[NSMutableArray alloc] initWithArray:array] autorelease];
    
    for (int i = newArray.count-1; i >= 0; i--) {
        NSString *paraStr = [newArray objectAtIndex:i];
        paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([paraStr isEqualToString:@""]) {
            [newArray removeObjectAtIndex:i];
        } else {
            if (!([paraStr hasPrefix:@"----------"] || [paraStr hasPrefix:@"************"])) {
                paraStr = [NSString stringWithFormat:@"　　%@", paraStr];
            }
            [newArray replaceObjectAtIndex:i withObject:paraStr];
        }
    }
    
    NSString *newContentStr = [newArray componentsJoinedByString:@"\n"];
    
    return newContentStr;
}

- (id)initWithLayoutConfig:(BookLayoutConfig*)config andChapterItem:(NBChapterItem*)chapterItem andPagesInfo:(NBChapterPagesInfo*)pagesInfo andChapterContent:(NSString*)content
{
    assert(config && chapterItem && pagesInfo);
//    assert(pagesInfo.chapterIndex == chapterItem.chapterIndex);
    self = [super init];
    if (self)
    {
        self.layoutConfig = config;
        self.chapterItem = chapterItem;
        self.pagesInfo = pagesInfo;
        
		NSString * contentStr = nil;
        if (pagesInfo.isSplitError)
        {
            contentStr = pagesInfo.errorSubstitute;
        }
        else
        {
            if (content && [content length])
            {
                contentStr = [PageSplitRender getChapterContentStr:content withChapterItem:chapterItem];
            }
        }
        
        if (contentStr)
        {
            self.chapterTextContent = contentStr;
            m_frameSetter = [PageSplitRender formatString:contentStr withChapterItem:chapterItem andLayoutConfig:config];
        }
        
        //NSLog(@"[%p]PageSplitRender:initWithLayoutConfig chapterIndex:%d", self, chapterItem.chapterIndex);
    }
    
    return self;
}

- (void)dealloc
{
    //NSLog(@"[%p]~PageSplitRender:dealloc chapterIndex:%d, chapterName:%@, contentKey:%@", self, self.chapterItem.chapterIndex, self.chapterItem.chapterName, self.chapterItem.contentKey);
    self.layoutConfig = nil;
    self.chapterItem = nil;
    self.pagesInfo = nil;
    self.chapterTextContent = nil;
    if (m_frameSetter)
    {
        CFRelease(m_frameSetter);
        m_frameSetter = nil;
    }
    
    [super dealloc];
}

- (BOOL)drawInContext:(CGContextRef)context withRect:(CGRect)rect andPageIndex:(int)pageIndex
{
    //assert(CGSizeEqualToSize(rect.size, CGSizeMake(self.layoutConfig.pageWidth, self.layoutConfig.pageHeight)));
    assert((pageIndex >= 0) && (pageIndex < [self.pagesInfo getPagesCount]));
    HTIME_DUMP_IF("PageSplitRender:drawInContext", 20);
    
    NBPageItem* pageItem = [self.pagesInfo getPageItem:pageIndex];
    assert(pageItem);
    if ((nil == pageItem) || (nil == m_frameSetter))
    {
        return NO;
    }
	
    CFIndex textRangeStart = pageItem.startInChapter;
    CFRange textRange = CFRangeMake(textRangeStart, 0);
    if (textRangeStart >= [self.chapterTextContent length])
    {
        DDLogVerbose(@"!!!drawInContext，绘制文本超界。");
        return NO;
    }

	//翻转坐标系统（文本原来是倒的要翻转下）
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFramesetterRef framesetter = m_frameSetter;
	
#ifdef ENABLE_Check_Page_Param
	NBMD_LOG_NSLOG(@"_layoutConfig=%@", _layoutConfig);
	NBMD_LOG_NSLOG(@"当前页面[c=%d][p=%d]内容\n%@", pageItem.chapterIndex, (int)pageItem.pageIndex, pageItem.pageTextContent);
//	framesetter = [PageSplitRender formatString:pageItem.pageTextContent withChapterItem:self.chapterItem andLayoutConfig:self.layoutConfig];
//	textRange = CFRangeMake(0, 0);
#endif
	
	// 由于在绘制文字时, 坐标系会沿X轴发生翻转, 故Y方向需要调换
	UIEdgeInsets edgeInsets = self.layoutConfig.contentInset;
	edgeInsets.top = self.layoutConfig.contentInset.bottom;
	edgeInsets.bottom = self.layoutConfig.contentInset.top;
	
    CGRect columnFrame = rect;
    columnFrame.size = CGSizeMake(self.layoutConfig.pageWidth, self.layoutConfig.pageHeight);
    columnFrame = UIEdgeInsetsInsetRect(columnFrame, edgeInsets);
//	columnFrame.origin.y -= 2*self.layoutConfig.lineSpace;
	assert(rect.size.height == self.layoutConfig.pageHeight);
	DDLogVerbose(@"==columnFrame=(%@)", NSStringFromCGRect(columnFrame));
	
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
    CTFrameRef contentFrame = CTFramesetterCreateFrame(framesetter, textRange, framePath, NULL);
    CTFrameDraw(contentFrame, context);
	
	if (contentFrame)
	{
		CFRelease(contentFrame);
	}
	if (framePath)
	{
		CFRelease(framePath);
	}
    
//	[self drawScaleLine:context withRect:rect];
	
    return YES;
}

- (void)drawScaleLine:(CGContextRef)context withRect:(CGRect)rect
{
#ifdef ENABLE_Check_Page_Param
	// 绘制刻度线, 查看文字绘制是否正常
	
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
	
	int x = 10;
	int y = 0;
	
	// Restore the previous drawing state, and save it again.
	//CGContextRestoreGState(context);
	CGContextSaveGState(context);
	for (; y < 50; y += 5)
	{
		CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
		DDLogVerbose(@"==(x,y)=(%d,%d)", x, y);
		// Draw a single line from left to right
		CGContextMoveToPoint(context, x, y);
		CGContextAddLineToPoint(context, rect.size.width - x, y);
	}
	CGContextStrokePath(context);
	// Restore the previous drawing state, and save it again.
	//CGContextRestoreGState(context);
	CGContextSaveGState(context);
	
	for (; y < rect.size.height - 50; y += 20)
	{
		CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
		// Draw a single line from left to right
		CGContextMoveToPoint(context, x, y);
		CGContextAddLineToPoint(context, rect.size.width - x, y);
	}
	CGContextStrokePath(context);
	// Restore the previous drawing state, and save it again.
	//CGContextRestoreGState(context);
	CGContextSaveGState(context);
	
	for (; y < rect.size.height; y += 5)
	{
		CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
		DDLogVerbose(@"==(x,y)=(%d,%d)", x, y);
		// Draw a single line from left to right
		CGContextMoveToPoint(context, x, y);
		CGContextAddLineToPoint(context, rect.size.width - x, y);
	}
	CGContextStrokePath(context);
	// Restore the previous drawing state, and save it again.
	//CGContextRestoreGState(context);
	CGContextSaveGState(context);
#endif
}

@end

