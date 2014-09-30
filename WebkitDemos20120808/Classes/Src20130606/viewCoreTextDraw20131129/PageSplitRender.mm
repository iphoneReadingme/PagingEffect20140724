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
#import "NBDataProviderDefine.h"
#import "NovelBoxConfig.h"
#import "iUCCommon.h"
#import "DDLog.h"
#import "NSArray+ExceptionSafe.h"

//#define USE_HTIME_DUMP
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
@property (nonatomic, assign)CGFloat paragraphSpacing;
@property (nonatomic, assign)CGFloat paragraphSpacingBefore;
@end

@implementation NBFTCoreTextStyle
@end


@interface PageSplitRender ()
{
    CTFramesetterRef  m_frameSetter;
}
@property (nonatomic, retain) BookLayoutConfig * layoutConfig;
@property (nonatomic, retain) NSString * chapterTextContent;
@property (nonatomic, retain) NSString * chapterName;

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

+ (NSString*)getChapterContentStr:(NSString*)content
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

+ (NBChapterPagesInfo*)splittingPagesForString:(NSString*)content withChapterName:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config
{
    NBChapterPagesInfo * pagesInfo = [[[NBChapterPagesInfo alloc] init] autorelease];
    if (content && ([content length] > 0))
    {
        NSString *contentStr = [PageSplitRender getChapterContentStr:content];
        pagesInfo.pageItems = [self _splittingPagesForString:contentStr withChapterName:chapterName andLayoutConfig:config];
    }
    
    if ((nil == pagesInfo.pageItems) || (0 == [pagesInfo.pageItems count]))
    {
        pagesInfo.isSplitError = YES;
        pagesInfo.errorSubstitute = SPLIT_ERROR_SUBTITUTE;
        pagesInfo.pageItems = [self _splittingPagesForString:pagesInfo.errorSubstitute withChapterName:chapterName andLayoutConfig:config];
        assert([pagesInfo.pageItems count]);
    }
    
    return pagesInfo;
}

// 返回 NBPageItem array
+ (NSMutableArray*)_splittingPagesForString:(NSString*)content withChapterName:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config
{
    NSMutableArray *pageArray = nil;
	if ([content length] > 0)
	{
		//HTIME_DUMP_IF("splittingPagesForString", 50);
		pageArray = [[[NSMutableArray alloc] init] autorelease];
		
		NSString* frameShowText = [PageSplitRender getShowTextOfChapter:content withChapterName:chapterName andLayoutConfig:config];
		UIEdgeInsets contentInset = config.contentInset;
		
		CTFramesetterRef framesetter = [PageSplitRender formatString:content withChapterName:chapterName andLayoutConfig:config];
		CFIndex textRangeStart = 0;
		BOOL bBreak = NO;
		for(size_t i = 0; i < INT16_MAX; i++)
		{
			CGRect columnFrame = CGRectMake(i*config.pageWidth, 0, config.pageWidth, config.pageHeight);
			columnFrame = UIEdgeInsetsInsetRect(columnFrame, contentInset);
			CGMutablePathRef framePath = CGPathCreateMutable();
			CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
			CFRange textRange = CFRangeMake(textRangeStart, 0);
			CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, framePath, NULL);
			CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
			NBPageItem *item = [[[NBPageItem alloc] init] autorelease];
			item.startInChapter = textRangeStart;
			item.length = visibleRange.length;
			item.pageIndex = i;
			
			[pageArray addObject:item];
			textRangeStart += visibleRange.length;
			
			if(textRangeStart >= [frameShowText length]) ///< 删除最后一个全空页
			{
				NSString* strEnd = [frameShowText substringFromIndex:visibleRange.location];
				strEnd = [strEnd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				DDLogVerbose(@"最后一页面[%d]", (int)i);
				if ((0 == [strEnd length]) || ![PageSplitRender isVisibleString:strEnd])
				{
					// 显示空白,则删除
					[pageArray removeObject:item];
				}
				bBreak = YES;
			}
			
			if (frame != nil)
			{
				CFRelease(frame);
			}
			if (framePath != nil)
			{
				CFRelease(framePath);
			}
			
			if (bBreak)
			{
				break;
			}
		}
		
		if (framesetter != nil)
		{
			CFRelease(framesetter);
		}
	}
	
    return pageArray;
}

///< 返回当前章节显示的文本内容（上下翻页时第一页面带章节标题名）
+ (NSString*)getShowTextOfChapter:(NSString *)contentStr withChapterName:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config
{
	BOOL bShowTitle = (config.showBigTitle && [chapterName length] > 0);   ///< 文字排版时是否显示标题
	
	NSString* chapterText = contentStr;
	if (bShowTitle)
	{
		chapterText = [NSString stringWithFormat:@"%@\n\n%@", chapterName, contentStr];
	}
	
	return chapterText;
}

/*格式化绘画样式*/
+ (CTFramesetterRef)formatString:(NSString *)contentStr withChapterName:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config
{
	if (config == nil || ([contentStr length] < 1))
	{
		return nil;
	}
	
	BOOL bShowTitle = (config.showBigTitle && [chapterName length] > 0);   ///< 文字排版时是否显示标题
	int nStart = 0;
	int nTextLength = [contentStr length];  ///< 章节内容文字长度（不含标题文字）
	
	NSString* frameShowText = [PageSplitRender getShowTextOfChapter:contentStr withChapterName:chapterName andLayoutConfig:config];
    NSMutableAttributedString *attributedString = [[[NSMutableAttributedString alloc] initWithString:frameShowText] autorelease];
    
	if (bShowTitle)
	{
		///< 格式化标题
		NSRange range = NSMakeRange(0, [chapterName length]);
		[PageSplitRender formatChapterTitle:attributedString with:range andLayoutConfig:config];
	}
	
	///< 格式化章节内容
	if (bShowTitle)
	{
		///< 补充2个换行符:　1.'\n',章节标题与章节内容之间换行; 2. '\n',标题与章节内容之间的间距（以一个空行来实现）
		nStart = [chapterName length] + 2;
	}
	NSRange range = NSMakeRange(nStart, nTextLength);
	[PageSplitRender formatChapterContent:attributedString with:range andLayoutConfig:config];
	
	///< 创建framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((DTCFAttributedStringRef)attributedString);
    return framesetter;
}

+ (void)formatChapterTitle:(NSMutableAttributedString*)attributedString with:(NSRange)range andLayoutConfig:(BookLayoutConfig*)config
{
	if (range.length < 1)
	{
		return;
	}
	
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
	
	if ([[fontObj fontName] length] > 0)
	{
		CTFontRef font = CTFontCreateWithName((DTCFStringRef)fontObj.fontName, fontSize, NULL);
		if (font != nil)
		{
			[attributedString addAttribute:(NSString *)kCTFontAttributeName value:(DTid)font range:range];
			CFRelease(font);
		}
    }
    
	NBFTCoreTextStyle *stype = [[[NBFTCoreTextStyle alloc] init] autorelease];
	if (stype != nil)
	{
		stype.textAlignment = kCTLeftTextAlignment;
		stype.fristlineindent = 0.0f;
		stype.lineSpace = config.lineSpace;
		stype.paragraphSpacing = config.paragraphSpacing;
		stype.paragraphSpacingBefore = config.paragraphSpacingBefore;
		
		//设置对齐方式、行间距、首行缩进
		[PageSplitRender formatTextAttributes:attributedString with:range withStyle:stype];
	}
}

+ (void)formatChapterContent:(NSMutableAttributedString*)attributedString with:(NSRange &)range andLayoutConfig:(BookLayoutConfig*)config
{
	///< 1. 文本内容颜色
	UIColor* colorText = [UIColor blueColor];
	if (config != nil && config.pageTextColor != nil)
	{
		colorText = config.pageTextColor;
	}
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)colorText.CGColor range:range];
	
    ///< 2. 设置文本内容字体
	CGFloat fontSize = config.fontSize;
	UIFont* fontObj = [PageSplitRender loadCustomFont:[config fontName] with:fontSize];
	
	if ([[fontObj fontName] length] > 0)
	{
		CTFontRef font = CTFontCreateWithName((DTCFStringRef)fontObj.fontName, fontSize, NULL);
		if (font != nil)
		{
			[attributedString addAttribute:(NSString *)kCTFontAttributeName value:(DTid)font range:range];
			CFRelease(font);
		}
	}
	
	NBFTCoreTextStyle *stype = [[[NBFTCoreTextStyle alloc] init] autorelease];
	if (stype != nil)
	{
		stype.textAlignment = kCTLeftTextAlignment;
		stype.fristlineindent = config.firstLineHeadIndent;
		stype.lineSpace = config.lineSpace;
		stype.paragraphSpacing = config.paragraphSpacing;
		stype.paragraphSpacingBefore = config.paragraphSpacingBefore;
		
		//设置对齐方式、行间距、首行缩进
		[PageSplitRender formatTextAttributes:attributedString with:range withStyle:stype];
	}
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
			fontObj = [UIFont fontWithName:fontName size:fontSize];
		}
		if (fontObj == nil)
		{
			fontObj = [UIFont boldSystemFontOfSize:fontSize];  ///< 系统字体;
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
			fontObj = [UIFont fontWithName:fontName size:fontSize];
		}
		if (fontObj == nil)
		{
			fontObj = [UIFont systemFontOfSize:fontSize];  ///< 系统字体;
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
		fontObj = [PageSplitRender dynamicLoadFont:fontSize];
		if (fontObj == nil)
		{
			fontObj = [UIFont systemFontOfSize:fontSize];  ///< 系统字体;
		}
	}
	
	return fontObj;
}

+ (NSString*)getFontFilePath
{
	NSString* filePath = [NSString stringWithFormat:@"%@/Documents/huawenxingkai.ttf", NSHomeDirectory()];
	
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

+ (UIFont*)dynamicLoadFont:(int)fontSize
{
	UIFont* fontObj = nil;
	
	//加载字体
	CFErrorRef error;
	NSString *fontPath = [PageSplitRender getFontFilePath]; // a TTF file in iPhone Documents folder //字体文件所在路径
	if ([fontPath length] < 1)
	{
		return fontObj;
	}
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
	CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
	
	bool bRegister = CTFontManagerRegisterGraphicsFont(customFont, &error);
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
	///< 2. 换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping; //出现在单词边界时起作用，如果该单词不在能在一行里显示时，整体换行。此为段的默认值。
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    lineBreakMode.value = &lineBreak;
	
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
    CGFloat paragraphSpacing = textStyle.paragraphSpacing;
    CTParagraphStyleSetting paragraphSpacingSet;
    paragraphSpacingSet.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpacingSet.value = &paragraphSpacing;
    paragraphSpacingSet.valueSize = sizeof(paragraphSpacing);
	
	///< 7. 设置段前间距
    CGFloat paragraphSpacingBefore = textStyle.paragraphSpacingBefore;
    CTParagraphStyleSetting paragraphSpacingBeforeSet;
    paragraphSpacingBeforeSet.spec = kCTParagraphStyleSpecifierParagraphSpacingBefore;
    paragraphSpacingBeforeSet.value = &paragraphSpacingBefore;
    paragraphSpacingBeforeSet.valueSize = sizeof(paragraphSpacingBefore);
	
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
	if (style)
	{
		// build attributes
		NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
		
		// set attributes to attributed string
		[attributedString addAttributes:attributes range:range];
		
		CFRelease(style);
	}
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
        NSString *paraStr = [newArray safe_ObjectAtIndex:i];
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

- (id)initWithLayoutConfig:(BookLayoutConfig*)config chapterName:(NSString*)chapterName chapterText:(NSString*)chapterText
{
    assert(config && chapterName);
    self = [super init];
    if (self)
    {
        self.layoutConfig = config;
		self.chapterName = chapterName;
        
		NSString * contentStr = nil;
		if (chapterText && [chapterText length])
		{
			contentStr = [PageSplitRender getChapterContentStr:chapterText];
		}
		
        if (contentStr)
        {
            self.chapterTextContent = contentStr;
			m_frameSetter = [PageSplitRender formatString:contentStr withChapterName:chapterName andLayoutConfig:config];
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.layoutConfig = nil;
	self.chapterName = nil;
    self.chapterTextContent = nil;
    if (m_frameSetter)
    {
        CFRelease(m_frameSetter);
        m_frameSetter = nil;
    }
    
    [super dealloc];
}

- (BOOL)drawInContext:(CGContextRef)context withRect:(CGRect)rect withStart:(int)nTextStartLocation withLength:(int)nPageTextLength
{
    //HTIME_DUMP_IF("PageSplitRender:drawInContext", 20);
	if (nil == m_frameSetter)
	{
		return NO;
	}
	
	NSString* frameShowText = [PageSplitRender getShowTextOfChapter:self.chapterTextContent withChapterName:self.chapterName andLayoutConfig:self.layoutConfig];
    if (nTextStartLocation >= [frameShowText length])
    {
        DDLogError(@"!!!drawInContext，绘制文本超界。");
		assert(0);
		
        return NO;
    }
	
	if (nTextStartLocation + nPageTextLength >= [frameShowText length])
	{
		nPageTextLength = [frameShowText length] - nTextStartLocation;
	}
	
	CFRange textRange = CFRangeMake(nTextStartLocation, nPageTextLength);
	
	//翻转坐标系统（文本原来是倒的要翻转下）
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
    CTFramesetterRef framesetter = m_frameSetter;
	
	UIEdgeInsets contentInset = self.layoutConfig.contentInset;
	// 由于在绘制文字时, 坐标系会沿X轴发生翻转, 故Y方向需要调换
	UIEdgeInsets edgeInsets = contentInset;
	edgeInsets.top = contentInset.bottom;
	edgeInsets.bottom = contentInset.top;
	
    CGRect columnFrame = rect;
    columnFrame.size = CGSizeMake(self.layoutConfig.pageWidth, self.layoutConfig.pageHeight);
    columnFrame = UIEdgeInsetsInsetRect(columnFrame, edgeInsets);
	assert(rect.size.height == self.layoutConfig.pageHeight);
	DDLogVerbose(@"==columnFrame=(%@)", NSStringFromCGRect(columnFrame));
	
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
    CTFrameRef pageFrame = CTFramesetterCreateFrame(framesetter, textRange, framePath, NULL);
//    CTFrameDraw(pageFrame, context);
	
	[self CTLinesDraw:pageFrame with:context withRect:columnFrame];
	
	if (pageFrame)
	{
		CFRelease(pageFrame);
	}
	if (framePath)
	{
		CFRelease(framePath);
	}
    
    return YES;
}

#define kMaxLineOfFrame     30
- (void)CTLinesDraw:(CTFrameRef)pageFrame with:(CGContextRef)context withRect:(CGRect)columnFrame
{
	CGFloat x = 0;
	CGFloat y = 0;
	CGPoint lineOrigins[kMaxLineOfFrame];
	CGPoint linePtOrigins[kMaxLineOfFrame];
	
	//计算这一栏，有几行文字。
	NSArray *lines = (NSArray*)CTFrameGetLines(pageFrame);
	
	int nLineCount = [lines count];
	if (nLineCount > 0 && nLineCount < kMaxLineOfFrame)
	{
		CTFrameGetLineOrigins(pageFrame, CFRangeMake(0, 0), lineOrigins);
		
		BOOL bRet = [self getLineNewOrigins:pageFrame withRect:columnFrame withOut:linePtOrigins];
		if (!bRet)
		{
			///< 不需要调整行间距时，直接绘制
			CTFrameDraw(pageFrame, context);
		}
		else
		{
			int i = 0;
			for (id lineObj in lines)
			{
				CTLineRef line = (CTLineRef)lineObj;
				
				x = columnFrame.origin.x;
				y = linePtOrigins[i].y;
				
				CGContextSetTextPosition(context, x, y);
				CTLineDraw(line, context);
				
				i++;
			}
		}
	}
}

- (BOOL)getLineNewOrigins:(CTFrameRef)pageFrame withRect:(CGRect)columnFrame withOut:(CGPoint*)linePtOrigins
{
	BOOL bRet = NO;
	CGPoint lineOrigins[kMaxLineOfFrame];
	
	//计算这一栏，有几行文字。
	NSArray *lines = (NSArray*)CTFrameGetLines(pageFrame);
	
	int nLineCount = [lines count];
	if (nLineCount > 0 && nLineCount < kMaxLineOfFrame)
	{
		CGFloat fYOffset = 0;
		
		CTFrameGetLineOrigins(pageFrame, CFRangeMake(0, 0), lineOrigins);
		
		CGFloat fLineHeight = 0;
		if (nLineCount >= 2)
		{
			fLineHeight = (lineOrigins[0].y - lineOrigins[1].y);
		}
		
		CGFloat lineSpace = self.layoutConfig.lineSpace;
		CGFloat y = lineOrigins[nLineCount-1].y - 2.5;
		if (nLineCount < 2 ||
			((lineSpace - 3) < y && y < (lineSpace + 1)) || ///< 底部间距与lineSpace相差很小
			(y > fLineHeight+3.0) ///< 底部间距超过一行，一般是最后一页，空白较多的情况
			)
		{
			///< 章节的最后一页留有多于一行的空白，则不调整行间距
			fYOffset = 0;
		}
		else
		{
			if (y < lineSpace)
			{
				fYOffset = (y - lineSpace)/(nLineCount - 1);
			}
			else
			{
				fYOffset = (y - self.layoutConfig.lineSpace)/(nLineCount);
			}
			bRet = YES;
		}
		
		int i = 0;
		for (id lineObj in lines)
		{
			linePtOrigins[i].x = columnFrame.origin.x;
			linePtOrigins[i].y = lineOrigins[i].y - fYOffset*i; ///< 向下偏移fYOffset
			
			i++;
		}
	}
	
	return bRet;
}

///< 测试接口
#pragma mark -==页面文字排版测试
//#define ENABLE_Check_Page_Param   // 启用页面参数查看宏
///< 测试代码：(显示当前页面的排版文字)
///< [self showPageEveryLineText:contentFrame with:curChapterText withChapterName:chapterName];
///< 绘制文字时格式化：	framesetter = [PageSplitRender formatString:self.chapterTextContent withChapterName:chapterName andLayoutConfig:self.layoutConfig];

#ifdef ENABLE_Check_Page_Param

///< 打印当前页面各行文字的排版
- (NSMutableString*)showPageEveryLineText:(CTFrameRef)frame with:(NSString*)curChapterText withChapterName:(NSString*)chapterName
{
	///< CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, framePath, NULL);
	///< (int)CFArrayGetCount((CFArrayRef)CTFrameGetLines(frame));
	NSMutableString* chapterLineStrs = [NSMutableString stringWithCapacity:1];
	//计算这一栏，有几行文字。
	NSArray *lines = (NSArray *)CTFrameGetLines(frame);
	//查看每一行文字的起始位置，和包含几个文字。并提取某行文字内容
	int i = 0;
	for (id lineObj in lines)
	{
		CTLineRef line = (CTLineRef)lineObj;
		CFRange singleRange=CTLineGetStringRange(line);
		
		NSRange range = NSMakeRange(singleRange.location, singleRange.length);
		range.length = singleRange.length;
		//取得單行文字的起始位置，和包含幾個文字。
		//NSLog(@"lineNumber[%d], %ld,%ld", i, singleRange.location, singleRange.length);
		i++;
		
		NSString* lineText = [curChapterText substringWithRange:range];
		NSString* lastChar = [lineText substringFromIndex:[lineText length] - 1]; ///< 最后一个字符
		if ([lastChar isEqualToString:@"\n"])
		{
			[chapterLineStrs appendFormat:@"%@", [curChapterText substringWithRange:range]];
		}
		else
		{
			[chapterLineStrs appendFormat:@"%@\n", [curChapterText substringWithRange:range]];
		}
	}
	
	//印出單行文字的起始位置，和包含幾個文字。
	NSLog(@"\n%@\nchapter[%d], page[%d], 字[%d]\n %@", chapterName, 0, 0, [chapterLineStrs length], chapterLineStrs);
	
	return chapterLineStrs;
}

#endif

#ifdef ENABLE_Check_Page_Param

///< [self drawLineOfTextLine:context withRect:columnFrame withFrame:pageFrame];
- (void)drawLineOfTextLine:(CGContextRef)context withRect:(CGRect)columnFrame withFrame:(CTFrameRef)pageFrame
{
	///< 当前页面排版矩形
	[self drawRect:context with:columnFrame];
	return;
	// 每行文字绘制下边缘线, 查看文字绘制是否正常
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
	
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
	
	CGFloat x = 0;
	CGFloat y = columnFrame.origin.y;
	//计算这一栏，有几行文字。
	NSArray *lines = (NSArray*)CTFrameGetLines(pageFrame);
	CGPoint lineOrigins[kMaxLineOfFrame];
	
	if ([lines count] >= kMaxLineOfFrame)
	{
		return;
	}
	
	CTFrameGetLineOrigins(pageFrame, CFRangeMake(0, 0), lineOrigins);
	//return;
	int i = 0;
	CGRect aBounsRect[kMaxLineOfFrame];
	CGRect imageBounsRect[kMaxLineOfFrame];
	CGRect rectTest;
	
	for (id lineObj in lines)
	{
		CTLineRef line = (CTLineRef)lineObj;
		aBounsRect[i]= CTLineGetBoundsWithOptions(line, kCTLineBoundsUseOpticalBounds);
		imageBounsRect[i] = CTLineGetImageBounds(line, context);///< 但是在iOS(iPhone/iPad)上这个函数的结果略有不同。
		i++;
	}
	
	CGPoint linePtOrigins[kMaxLineOfFrame];
	BOOL bRet = [self getLineNewOrigins:pageFrame withRect:columnFrame withOut:linePtOrigins];
	
	NSString* frameShowText = [PageSplitRender getShowTextOfChapter:self.chapterTextContent withChapterName:self.chapterName andLayoutConfig:self.layoutConfig];
	//查看每一行文字的起始位置，和包含几个文字。并提取某行文字内容
	i = 0;
	for (id lineObj in lines)
	{
		CTLineRef line = (CTLineRef)lineObj;
		
		CFRange singleRange=CTLineGetStringRange(line);
		NSRange range = NSMakeRange(singleRange.location, singleRange.length);
		range.length = singleRange.length;
		//取得單行文字的起始位置，和包含幾個文字。
		//NSLog(@"lineNumber[%d], %ld,%ld", i, singleRange.location, singleRange.length);
		NSString* lineText = nil;
		if (range.location >= [frameShowText length] || range.location + range.length > [frameShowText length])
		{
			assert(0);
		}
		
		lineText = [frameShowText substringWithRange:range];
		NSLog(@"lineNumber[%d], %ld,%ld, %@", i, singleRange.location, singleRange.length, lineText);
		
		CGRect lineRect = aBounsRect[i];
		lineRect = imageBounsRect[i];
		
//		lineRect.origin.x += lineOrigins[i].x;
//		lineRect.origin.y += lineOrigins[i].y;
//		NSLog(@"CTLine ImageBounds:%@, %@", NSStringFromCGRect(lineRect), NSStringFromCGRect(aBounsRect[i]));
		NSLog(@"CTLine :%@, %@", NSStringFromCGPoint(lineOrigins[i]), NSStringFromCGRect(aBounsRect[i]));
//		x = lineRect.origin.x;
//		y = lineRect.origin.y;
		
//		x = lineOrigins[i].x;
		y = lineOrigins[i].y;
		x = columnFrame.origin.x;
		
		lineRect = aBounsRect[i];
		rectTest = CGRectMake(x, y, 0, 0);
		rectTest.size = lineRect.size;
		///< 本行的文字矩形
		//[self drawRect:context with:rectTest];
		
		///< 行文字的下边线
		x = columnFrame.origin.x;
		y = linePtOrigins[i].y;
		if (bRet)
		{
			y -= 2; ///< 下移2px
		}
		
		CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
		// Draw a single line from left to right
		CGContextMoveToPoint(context, x, y);
		
		x += columnFrame.size.width;
		CGContextAddLineToPoint(context, x, y);
		CGContextStrokePath(context);
		
		///< 行号
		x = columnFrame.origin.x;
		NSString* text = [NSString stringWithFormat:@"%d,(%.1f, %.1f)", i, x, y];
		[self drawString:context withText:text with:CGPointMake(columnFrame.origin.x, y)];
		
		CGContextStrokePath(context);
		
		i++;
	}
	
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
	
}

/*
 
 //CTLineGetImageBounds的应用，
 获取一行文字的范围， 就是指把这一行文字点有的像素矩阵作为一个image图片， 来得到整个矩形区域
 //相对于每一行基线原点的偏移量和宽高（例如：{{1.2， -2.57227}, {208.025, 19.2523}}，
 就是相对于本身的基线原点向右偏移1.2个单位，向下偏移2.57227个单位，后面是宽高）
 CGRect lineBounds = CTLineGetImageBounds((CTLineRef)oneLine, context);
 
 //获取一行文字最佳可视范围（会把所有文字都包含进去）
 //    CGRect lineRect = CTLineGetImageBounds(firstLine, context);
 //    NSLog(@"整行的范围:%@",NSStringFromCGRect(lineRect));
 
 //获取一行中上行高(ascent)，下行高(descent)，行距(leading),整行高为(ascent+|descent|+leading) 返回值为整行字符串长度占有的像素宽度。
 //    CGFloat asc,des,lead;
 //    double lineWidth = CTLineGetTypographicBounds(firstLine, &asc, &des, &lead);
 //    NSLog(@"ascent = %f,descent = %f,leading = %f,lineWidth = %f",asc,des,lead,lineWidth);
 
 
 */
- (void)drawRect:(CGContextRef)context with:(CGRect)columnFrame
{
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
	
	///< 排版区域的边界矩形
	CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
	
	CGContextMoveToPoint(context, columnFrame.origin.x, columnFrame.origin.y);
	CGContextAddRect(context, columnFrame);
	
	CGContextStrokePath(context);
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
}

- (void)drawString:(CGContextRef)context withText:(NSString*)text with:(CGPoint)pt
{
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
	
	CGContextSelectFont(context, "Helvetica", 12.0, kCGEncodingMacRoman);
	///< 排版区域的边界矩形
	
	CGContextSetRGBFillColor(context, 1.0, 0, 0, 1.0);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextShowTextAtPoint(context, pt.x, pt.y, [text UTF8String], [text length]);
	
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
}

- (void)drawScaleLine:(CGContextRef)context withRect:(CGRect)rect
{
	// 绘制刻度线, 查看文字绘制是否正常
	
	// Drawing lines with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
	
	int x = 10;
	int y = 0;
	
	// Restore the previous drawing state, and save it again.
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
	CGContextSaveGState(context);
}
#endif

@end

