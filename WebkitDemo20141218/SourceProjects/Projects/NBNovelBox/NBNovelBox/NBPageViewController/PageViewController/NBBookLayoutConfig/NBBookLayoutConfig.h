/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: NBBookLayoutConfig.h
 *
 * Description	: 书籍排版配置信息数据结构
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/


#import <UIKit/UIKit.h>

@interface NBBookLayoutConfig : NSObject <NSCopying>

@property (nonatomic, assign) int titleCharMaxCount;        ///< 标题最大文字个数 默认:17, 后面的显示...[书籍排版配置信息数据结构...]
@property (nonatomic, retain) UIColor* titleTextColor;      ///< 标题文字颜色 默认:0x777777

///< 大标题
@property (nonatomic, assign) int titleFontSize;            ///< 标题字号 默认:17 (大标题字体大小)
@property (nonatomic, assign) BOOL showBigTitle;            ///< 是否显示章节分割的大标题（在上下翻页时候每章开头显示大标题）

@property (nonatomic, retain) UIColor* pageTextColor;       ///< 文本文字颜色
@property (nonatomic, retain) NSString* fontName;           ///< 文字字体, 默认:@"Arial"
@property (nonatomic, assign) CGFloat firstLineHeadIndent;      ///< 首行缩进  default:0.0f
@property (nonatomic, assign) CGFloat paragraphSpacing;         ///< 段间距  default:0.0f
@property (nonatomic, assign) CGFloat paragraphSpacingBefore;   ///< 段前间距  default:0.0f
@property (nonatomic, assign) CGFloat lineSpace;                ///< 行间距  default: 4.0f
@property (nonatomic, assign) int fontSize;                 ///< 正文字号 16
@property (nonatomic, assign) int textAlignment;            ///< 文本对齐方式  default: kCTLeftTextAlignment
 
@property (nonatomic, assign) int pageWidth;                ///< 页面宽度
@property (nonatomic, assign) int pageHeight;               ///< 页面高度
@property (nonatomic, assign) UIEdgeInsets contentInset;    ///< 页边距

- (NSString*)description;
- (NSString*)keyName;       ///< 生成一个字符串Key，用于存储该排版配置的分页信息

- (id)initWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;
- (BOOL)isEqualToLayoutConfig:(NBBookLayoutConfig*)aConfig;  ///< 精确匹配相等判断
- (BOOL)isMainParamEqualToLayoutConfig:(NBBookLayoutConfig*)aConfig; ///< 模糊匹配相等判断
- (void)setDefaultParam;

+ (NBBookLayoutConfig*)bookLayoutConfigWithFontSize:(int)size andWidth:(int)width andHeight:(int)height;

///< 更新部分动态排版参数,　bHeadIndent:是否要缩进
- (void)updateLayoutProperty;

@end
