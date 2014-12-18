/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: NBBookLayoutConfig.mm
 *
 * Description	: 书籍排版配置信息数据结构
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/

#import "NBBookLayoutConfig.h"
//#import "NBDataProviderDefine.h"
//#import "NovelBoxConfig.h"
///< 默认字体列表
typedef struct
{
	NSInteger fontSize;     ///< 字体大小
	NSInteger rowSpace;     ///< 行距
	NSInteger headIndent;   ///< 首行缩进
}FontConfig;

const FontConfig g_fontAndRowSpace[] =
{
	28 / 2, 12 / 2, 48 / 2
	,30 / 2, 12 / 2, 52 / 2
	,34 / 2, 14 / 2, 64 / 2     ///< 默认配置
	,40 / 2, 16 / 2, 72 / 2
	,48 / 2, 20 / 2, 92 / 2
	,56 / 2, 22 / 2, 100 / 2
};

#define kTitleFontSizeOffset      4

#define kCountFontSizeOption     (sizeof(g_fontAndRowSpace) / sizeof(g_fontAndRowSpace[0]))


@implementation NBBookLayoutConfig

+ (NBBookLayoutConfig*)bookLayoutConfigWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;
{
    NBBookLayoutConfig * layout = [[[NBBookLayoutConfig alloc] initWithFontSize:size andWidth:width andHeight:height] autorelease];
    
    return layout;
}

- (void)dealloc
{
    self.fontName = nil;
	self.titleTextColor = nil;
	self.pageTextColor = nil;
    
    [super dealloc];
}

- (id)initWithFontSize:(int)size andWidth:(int)width andHeight:(int)height
{
    self = [super init];
    if (self)
    {
		self.fontSize = size;
		self.pageWidth = width;
		self.pageHeight = height;
		
		[self setDefaultParam];
	}
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    NBBookLayoutConfig * aConfig = [[[self class] allocWithZone:zone] initWithFontSize:self.fontSize andWidth:self.pageWidth andHeight:self.pageHeight];
    
	aConfig.titleCharMaxCount = self.titleCharMaxCount;
	aConfig.titleTextColor = self.titleTextColor;
	aConfig.titleFontSize = self.titleFontSize;
    aConfig.showBigTitle = self.showBigTitle;
	
	aConfig.pageTextColor = self.pageTextColor;
	aConfig.fontName = self.fontName;
	aConfig.paragraphSpacing = self.paragraphSpacing;
	aConfig.paragraphSpacingBefore = self.paragraphSpacingBefore;
	aConfig.lineSpace = self.lineSpace;
	aConfig.fontSize = self.fontSize;
	aConfig.textAlignment = self.textAlignment;
	
	aConfig.pageWidth = self.pageWidth;
	aConfig.pageHeight = self.pageHeight;
	aConfig.contentInset = self.contentInset;
	
    return aConfig;
}

- (void)setDefaultParam
{
	self.fontName = @"STHeitiSC-Light";
	self.fontSize = g_fontAndRowSpace[2].fontSize;
	self.firstLineHeadIndent = 0;
	self.paragraphSpacing = 0;
	self.paragraphSpacingBefore = 0;
	self.lineSpace = g_fontAndRowSpace[2].fontSize;
	self.textAlignment = kCTLeftTextAlignment;
	self.contentInset = UIEdgeInsetsMake(0, 15, 4, 12); // {top, left, bottom, right}
	
	// #ff333333, 0x33 = 51
	self.pageTextColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
	
	// #ff777777, 0x77 = 119
	self.titleTextColor = [UIColor colorWithRed:119/255.0f green:119/255.0f blue:119/255.0f alpha:1];
	self.titleCharMaxCount = 17;
	self.titleFontSize = self.fontSize + kTitleFontSizeOffset;
    
    self.showBigTitle = NO;
	
	[self updateLayoutProperty];
}

- (BOOL)isEqualToLayoutConfig:(NBBookLayoutConfig*)aConfig
{
    BOOL br = NO;
    
    if (   [self isMainParamEqualToLayoutConfig:aConfig]
        && CGColorEqualToColor(self.pageTextColor.CGColor, aConfig.pageTextColor.CGColor)
		)
    {
        br = YES;
    }
    
    return br;
}

- (BOOL)isMainParamEqualToLayoutConfig:(NBBookLayoutConfig*)aConfig
{
    BOOL br = NO;
    if (   (self.lineSpace == aConfig.lineSpace)
        && ([self.fontName isEqualToString:aConfig.fontName])
        && (self.fontSize == aConfig.fontSize)
        && (self.pageWidth == aConfig.pageWidth)
        && (self.pageHeight == aConfig.pageHeight)
        && (self.titleCharMaxCount == aConfig.titleCharMaxCount)
        && (self.titleFontSize == aConfig.titleFontSize)
        && (self.showBigTitle == aConfig.showBigTitle)
        && (self.paragraphSpacing == aConfig.paragraphSpacing)
		&& (self.paragraphSpacingBefore == aConfig.paragraphSpacingBefore)
        && (self.textAlignment == aConfig.textAlignment)
        && UIEdgeInsetsEqualToEdgeInsets(self.contentInset, aConfig.contentInset)
        )
    {
        br = YES;
    }
	
    return br;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<NBBookLayoutConfig: %p;\n \
			titleCharMaxCount %d;\n \
            titleTextColor: %@;\n \
			titleFontSize %d;\n \
            showBigTitle %d;\n \
            pageTextColor: %@;\n \
            fontName: %@;\n \
			firstLineHeadIndent: %.3f\n \
			paragraphSpacing: %.3f \n \
			paragraphSpacingBefore: %.3f \n \
            lineSpace: %.3f \n \
            fontSize: %d \n \
            pageWidth: %d \n \
            pageHeight: %d \n \
            textAlignment: %d \n \
            contentInset: %@ >",
            self,
			self.titleCharMaxCount,
            [self stringFromColor:self.titleTextColor],
			self.titleFontSize,
            self.showBigTitle,
            [self stringFromColor:self.pageTextColor],
            self.fontName,
			self.firstLineHeadIndent,
            self.paragraphSpacing,
			self.paragraphSpacingBefore,
            self.lineSpace,
            self.fontSize,
            self.pageWidth,
            self.pageHeight,
            self.textAlignment,
            NSStringFromUIEdgeInsets(self.contentInset)];
}

- (NSString*)keyName       ///< 生成一个字符串Key，用于关联存储该排版配置的分页信息
{
    return [NSString stringWithFormat:@"ft(%@-%dpt)sp(UC1010_RC2-%d-2%d-%d)sz(%dx%d)ta(%d)ci(%@)tcmc(%d)tfs(%d)sbt(%d)"
			, self.fontName, self.fontSize, (int)self.paragraphSpacing, (int)self.paragraphSpacingBefore, (int)self.lineSpace, self.pageWidth, self.pageHeight
            , self.textAlignment, NSStringFromUIEdgeInsets(self.contentInset)
			, self.titleCharMaxCount , self.titleFontSize, self.showBigTitle
			];
}

#pragma mark - 获取颜色的字符串
- (NSString *)stringFromColor:(UIColor *)color
{
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"RGB(%.1f,%.1f,%.1f)",cs[0]*255,cs[1]*255,cs[2]*255];
}

- (void)updateLayoutProperty
{
	for (NSInteger i = 0; i < kCountFontSizeOption; i++)
	{
		if (g_fontAndRowSpace[i].fontSize == self.fontSize)
		{
			self.paragraphSpacing = (CGFloat)g_fontAndRowSpace[i].rowSpace * 0.8f;
			break;
		}
	}
}

@end
