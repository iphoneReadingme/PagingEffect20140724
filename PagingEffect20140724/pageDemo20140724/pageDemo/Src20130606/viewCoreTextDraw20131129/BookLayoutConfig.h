/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: BookLayoutConfig.h
 *
 * Description	: 书籍排版配置信息数据结构
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/


#import <Foundation/Foundation.h>

@interface BookLayoutConfig : NSObject


@property (nonatomic, retain) UIColor* pageTextColor;       ///< 文本文字颜色
@property (nonatomic, retain) UIColor* titleTextColor;      ///< 标题文字颜色
@property (nonatomic, retain) NSString* fontName;           ///< 文字字体, 默认:@"Arial"
@property (nonatomic, assign) int paragraphSpacing;         ///< 段间距  default:0.0f
@property (nonatomic, assign) int lineSpace;                ///< 行间距  default: 4.0f
@property (nonatomic, assign) int fontSize;                 ///< 正文字号 16
@property (nonatomic, assign) int textAlignment;            ///< 文本对齐方式  default: kCTLeftTextAlignment

@property (nonatomic, assign) int pageWidth;                ///< 页面宽度
@property (nonatomic, assign) int pageHeight;               ///< 页面高度
@property (nonatomic, assign) UIEdgeInsets contentInset;    ///< 页边距

- (NSString*)description;
- (NSString*)keyName;       ///< 生成一个字符串Key，用于存储该排版配置的分页信息

- (id)initWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;
- (BOOL)isEqualToLayoutConfig:(BookLayoutConfig*)aConfig;

- (void)setDefaultParam;

+ (BookLayoutConfig*)bookLayoutConfigWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;

@end
