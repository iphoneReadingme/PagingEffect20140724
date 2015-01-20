/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: PageSplitter.mm
 *
 * Description	: 章节分页器
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/


#import <CoreText/CoreText.h>
#import "PageSplitter.h"
#import "ChapterPageInfo.h"


//#define       FONTNAME @"FZLanTingHeiS-R-GB" //字体 : 方正-兰亭黑体
#define			FONTNAME			@"STHeitiSC-Light"
//#define			FONTNAME			    @"Helvetica"


@implementation PageSplitter

// 返回 PageItem array
+ (NSMutableArray*)splittingPagesForString:(NSString*)content withLayoutConfig:(BookLayoutConfig*)config
{
	if ([content length] < 1 || config == nil)
	{
		return nil;
	}
	
    CGFloat fontSize = (CGFloat)config.fontSize;
    NSString * chapName = @"";
    
    NSMutableArray *pageArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *contentStr = content;
    CTFramesetterRef framesetter = [self formatString:contentStr size:fontSize color:[UIColor blackColor] chapName:chapName chapNameColor:[UIColor blackColor] isShow:YES];
	CFIndex textRangeStart = 0;
    for(size_t i = 0; i < INT16_MAX; i++) {
        CGRect columnFrame = CGRectMake(i*config.pageWidth, 0, config.pageWidth, config.pageHeight);
        columnFrame = UIEdgeInsetsInsetRect(columnFrame, UIEdgeInsetsMake(0, 0, 0, 0));
//        columnFrame = UIEdgeInsetsInsetRect(columnFrame, config.contentInset);
		
        CGMutablePathRef framePath = CGPathCreateMutable();
        CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
        CFRange textRange = CFRangeMake(textRangeStart, 0);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, framePath, NULL);
        CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
        PageItem *item = [[[PageItem alloc] init] autorelease];
        item.startInChapter = textRangeStart;
        item.length = visibleRange.length;
        [pageArray addObject:item];
        textRangeStart += visibleRange.length;
        CFRelease(frame);
        CFRelease(framePath);
        if(textRangeStart >= [contentStr length])
			break;
    }
    
	CFRelease(framesetter);
    return pageArray;
}

/*格式化绘画样式*/
+ (CTFramesetterRef)formatString:(NSString *)contentStr size:(CGFloat)fontSize color:(UIColor *)color chapName:(NSString *)chapName chapNameColor:(UIColor *)chapNameColor isShow:(NSInteger)_isShow
{
    if ([contentStr length] < 1)
	{
		return nil;
	}
	
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    //设置字体
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)[UIFont fontWithName:FONTNAME size:fontSize].fontName, fontSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, contentStr.length)];
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(0, contentStr.length)];
    CFRelease(font);
    
    //章节名字体
    if (chapName && chapName.length > 0 && _isShow == 1) {
        CTFontRef fontChapName = CTFontCreateWithName((__bridge CFStringRef)[UIFont fontWithName:FONTNAME size:fontSize].fontName, fontSize+2, NULL);
        [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontChapName range:NSMakeRange(2, chapName.length)];
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)chapNameColor.CGColor range:NSMakeRange(2, chapName.length)];
    }
    
    //设置对齐方式、行间距、首行缩进
    CTTextAlignment textAlignment = kCTJustifiedTextAlignment;
    CGFloat lineSpace = 16.0f;
    CGFloat paragraphSpacing = 10.0f;
    CGFloat headIndent = 0.0f;
    if (fontSize == 16) {
        headIndent = 32;
    } else if (fontSize == 18) {
        headIndent = 36;
    } else if (fontSize == 20) {
        headIndent = 42;
    } else if (fontSize == 25) {
        headIndent = 50;
    } else if (fontSize == 30) {
        headIndent = 64;
    } else if (fontSize == 35) {
        headIndent = 72;
    }
    headIndent = 0.0f;
	CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment },
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(lineSpace), &lineSpace },
        { kCTParagraphStyleSpecifierParagraphSpacing, sizeof(paragraphSpacing), &paragraphSpacing },
        { kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(headIndent), &headIndent }
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 4);
	CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(0, [contentStr length]), kCTParagraphStyleAttributeName, paragraphStyle);
	CFRelease(paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    return framesetter;
}

+ (void)drawInContext:(CGContextRef)context withRect:(CGRect)rect with:(NSString*)pageText withLayoutConfig:(BookLayoutConfig*)config
{
	rect = UIEdgeInsetsInsetRect(rect, config.contentInset);
	[self simpleParagraph:context font:config.fontSize with:rect withText:pageText];
}

+ (void)simpleParagraph:(CGContextRef)context font:(int)fontSize with:(CGRect)rect withText:(NSString*)pageContent
{
	if ([pageContent length] < 1)
	{
		return;
	}
	// Initialize a graphics context in iOS.
	//	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Flip the context coordinates, in iOS only.
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Initializing a graphic context in OS X is different:
	// CGContextRef context =
	//     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	// Set the text matrix.
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	//	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
	
	// Create a path which bounds the area where you will be drawing text.
	// The path need not be rectangular.
	CGMutablePathRef path = CGPathCreateMutable();
	
	// In this simple example, initialize a rectangular path.
	CGRect bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
	bounds = rect;
	CGPathAddRect(path, NULL, bounds );
	
	// Initialize a string.
	//CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
	CFStringRef textString = (__bridge CFStringRef)pageContent;
	
	// Create a mutable attributed string with a max length of 0.
	// The max length is a hint as to how much internal storage to reserve.
	// 0 means no hint.
	CFMutableAttributedStringRef attrString =
	CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	
	// Copy the textString into the newly created attrString
	CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0),
									 textString);
	
	// Create a color that will be added as an attribute to the attrString.
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat components[] = { 1.0, 0.0, 0.0, 0.8 };
	CGColorRef red = CGColorCreate(rgbColorSpace, components);
	CGColorSpaceRelease(rgbColorSpace);
	
	// Set the color of the first 12 chars to red.
	CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 0),
								   kCTForegroundColorAttributeName, red);
	
	// Create the framesetter with the attributed string.
//	CTFramesetterRef framesetter =
//	CTFramesetterCreateWithAttributedString(attrString);
	CFRelease(attrString);
	
	CTFramesetterRef framesetter = nil;
	framesetter = [PageSplitter formatString:pageContent size:fontSize color:[UIColor blackColor] chapName:@"name" chapNameColor:[UIColor blackColor] isShow:YES];
	
	// Create a frame.
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
												CFRangeMake(0, 0), path, NULL);
	
	// Draw the specified frame in the given context.
	CTFrameDraw(frame, context);
	
	// Release the objects we used.
	CFRelease(frame);
	CFRelease(path);
	CFRelease(framesetter);
}

- (void)simpleTextLabel:(CGContextRef)context font:(CTFontRef)font withText:(NSString*)pageContent
{
	NSString* strText = @"==text drawText文本绘制测试";
	CFStringRef string = (__bridge CFStringRef)strText;
	//	CTFontRef font;
	
	//	CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), 12.0, NULL);
	//	NSString* fontName = @"Helvetica";
	//	CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontName, 12., NULL);
	//CGContextRef context;
	// Initialize the string, font, and context
	
	CFStringRef keys[] = { kCTFontAttributeName };
	CFTypeRef values[] = { font };
	
	CFDictionaryRef attributes =
    CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
					   (const void**)&values, sizeof(keys) / sizeof(keys[0]),
					   &kCFTypeDictionaryKeyCallBacks,
					   &kCFTypeDictionaryValueCallBacks);
	
	CFAttributedStringRef attrString =
    CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
	CFRelease(string);
	CFRelease(attributes);
	
	CTLineRef line = CTLineCreateWithAttributedString(attrString);
	
	// Set text position and draw the line into the graphics context
	CGContextSetTextPosition(context, 10.0, 100.0);
	CTLineDraw(line, context);
	CFRelease(line);
}

- (void)pageTextLabel:(CGContextRef)context font:(CTFontRef)font withText:(NSString*)pageContent
{
	CFStringRef string = (__bridge CFStringRef)pageContent;
	
	CFStringRef keys[] = { kCTFontAttributeName };
	CFTypeRef values[] = { font };
	
	CFDictionaryRef attributes =
    CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
					   (const void**)&values, sizeof(keys) / sizeof(keys[0]),
					   &kCFTypeDictionaryKeyCallBacks,
					   &kCFTypeDictionaryValueCallBacks);
	
	CFAttributedStringRef attrString =
    CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
	CFRelease(string);
	CFRelease(attributes);
	
	CTLineRef line = CTLineCreateWithAttributedString(attrString);
	
	// Set text position and draw the line into the graphics context
	CGContextSetTextPosition(context, 10.0, 140.0);
	CTLineDraw(line, context);
	CFRelease(line);
}


///< [self drawLineOfTextLine:context withRect:columnFrame withFrame:pageFrame with:bLastPage];
- (void)drawLineOfTextLine:(CGContextRef)context withRect:(CGRect)columnFrame withFrame:(CTFrameRef)pageFrame with:(BOOL)bLastPage
{
	///< 当前页面排版矩形
	[self drawRect:context with:columnFrame];
	//return;
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
	
	int i = 0;
	CGRect aBounsRect[kMaxLineOfFrame];
	CGRect imageBounsRect[kMaxLineOfFrame];
	CGRect rectTest;
	
	for (id lineObj in lines)
	{
		CTLineRef line = (CTLineRef)lineObj;
		aBounsRect[i]= CTLineGetBoundsWithOptions(line, kCTLineBoundsUseGlyphPathBounds);
		imageBounsRect[i] = CTLineGetImageBounds(line, context);///< 但是在iOS(iPhone/iPad)上这个函数的结果略有不同。
		i++;
	}
	
	//CGPoint linePtOrigins[kMaxLineOfFrame];
	//	BOOL bRet = [self getLineNewOrigins:context frame:pageFrame withRect:columnFrame withOut:linePtOrigins with:bLastPage];
	
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
		lineRect.origin.x = lineOrigins[i].x + aBounsRect[i].origin.x + columnFrame.origin.x;
		lineRect.origin.y = lineOrigins[i].y + aBounsRect[i].origin.y + columnFrame.origin.y;
		
		NSLog(@"CTLine :%@", NSStringFromCGRect(lineRect));
		
		rectTest = lineRect;
		///< 本行的文字矩形
		[self drawRect:context with:rectTest];
		
		CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
		
		///< 行号
		x = columnFrame.origin.x;
		y = lineRect.origin.y;
		NSString* text = [NSString stringWithFormat:@"%d,(%.1f, %.1f)", i, x, y];
		[self drawString:context withText:text with:CGPointMake(x, y)];
		
		CGContextStrokePath(context);
		
		i++;
	}
	
	// Restore the previous drawing state, and save it again.
	CGContextSaveGState(context);
	
}

@end


