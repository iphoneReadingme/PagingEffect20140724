/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: BookLayoutConfig.mm
 *
 * Description	: 书籍排版配置信息数据结构
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/

#import "BookLayoutConfig.h"
//#import "NBDataProviderDefine.h"

#define kDefaultTitleFontSize                     14.f


@implementation BookLayoutConfig

+ (BookLayoutConfig*)bookLayoutConfigWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;
{
    BookLayoutConfig * layout = [[[BookLayoutConfig alloc] initWithFontSize:size andWidth:width andHeight:height] autorelease];
    
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
    
    BookLayoutConfig * aConfig = [[[self class] allocWithZone:zone] initWithFontSize:self.fontSize andWidth:self.pageWidth andHeight:self.pageHeight];
    
	aConfig.titleCharMaxCount = self.titleCharMaxCount;
	aConfig.titleTextColor = self.titleTextColor;
	aConfig.titleFontSize = self.titleFontSize;
    aConfig.showBigTitle = self.showBigTitle;
	
	aConfig.pageTextColor = self.pageTextColor;
	aConfig.fontName = self.fontName;
	aConfig.paragraphSpacing = self.paragraphSpacing;
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
	self.firstLineHeadIndent = 0;
	self.paragraphSpacing = 0;
	self.lineSpace = 14;
	self.textAlignment = kCTLeftTextAlignment;
	self.contentInset = UIEdgeInsetsMake(0, 15, 4, 12); // {top, left, bottom, right}
#ifdef NBMD_LOG_DEBUG_ENABLE
	self.contentInset = UIEdgeInsetsMake(0, 15, 0, 12); // {top, left, bottom, right}
#endif
	
	// #ff333333, 0x33 = 51
	self.pageTextColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
	
	// #ff777777, 0x77 = 119
	self.titleTextColor = [UIColor colorWithRed:119/255.0f green:119/255.0f blue:119/255.0f alpha:1];
	self.titleCharMaxCount = 17;
	self.titleFontSize = kDefaultTitleFontSize;
    
    self.showBigTitle = NO;
}

- (BOOL)isEqualToLayoutConfig:(BookLayoutConfig*)aConfig
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

- (BOOL)isMainParamEqualToLayoutConfig:(BookLayoutConfig*)aConfig
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
    return [NSString stringWithFormat:@"<BookLayoutConfig: %p;\n \
			titleCharMaxCount %d;\n \
            titleTextColor: %@;\n \
			titleFontSize %d;\n \
            showBigTitle %d;\n \
            pageTextColor: %@;\n \
            fontName: %@;\n \
            paragraphSpacing: %d \n \
            lineSpace: %d \n \
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
            self.paragraphSpacing,
            self.lineSpace,
            self.fontSize,
            self.pageWidth,
            self.pageHeight,
            self.textAlignment,
            NSStringFromUIEdgeInsets(self.contentInset)];
}

- (NSString*)keyName       ///< 生成一个字符串Key，用于关联存储该排版配置的分页信息
{
    return [NSString stringWithFormat:@"ft(%@-%dpt)sp(%d-%d)sz(%dx%d)ta(%d)ci(%@)tcmc(%d)tfs(%d)sbt(%d)"
			, self.fontName, self.fontSize, self.paragraphSpacing, self.lineSpace, self.pageWidth, self.pageHeight
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

@end
