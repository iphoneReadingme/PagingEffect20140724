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

@implementation BookLayoutConfig

+ (BookLayoutConfig*)bookLayoutConfigWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;
{
    BookLayoutConfig * layout = [[[BookLayoutConfig alloc] initWithFontSize:size andWidth:width andHeight:height] autorelease];
    
    return layout;
}

- (void)dealloc
{
    self.fontName = nil;
    
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
		self.pageTextColor = [UIColor blackColor];
		self.titleTextColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)setDefaultParam
{
	self.fontName = @"STHeitiSC-Light";
	self.paragraphSpacing = 0;
	self.lineSpace = 4;
	self.textAlignment = kCTLeftTextAlignment;
	self.fontSize = 16;
	self.contentInset = UIEdgeInsetsMake(15, 10, 0, 10);
}

- (BOOL)isEqualToLayoutConfig:(BookLayoutConfig*)aConfig
{
    BOOL br = NO;
    if (   (self.fontSize == aConfig.fontSize)
        && (self.pageWidth == aConfig.pageWidth)
        && (self.pageHeight == aConfig.pageHeight)
        && UIEdgeInsetsEqualToEdgeInsets(self.contentInset, aConfig.contentInset)
        )
    {
        br = YES;
    }
    
    return br;
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"<BookLayoutConfig: %p; %@>", self, [self keyName]];
}

- (NSString*)keyName       ///< 生成一个字符串Key，用于关联存储该排版配置的分页信息
{
    return [NSString stringWithFormat:@"%dpt(%dx%d)%@", self.fontSize, self.pageWidth, self.pageHeight, NSStringFromUIEdgeInsets(self.contentInset)];
}

@end
