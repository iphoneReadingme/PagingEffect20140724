/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: PageSplitRender.h
 *
 * Description	: 章节分页并渲染
 *
 * Author		: yangcy@ucweb.com
 * History		:
 *			   Creation, 2013/11/26, yangcy, Create the file
 ***************************************************************************************
 **/

#import "NBBookLayoutConfig.h"
//#import "NBProviderDataStructures.h"

typedef enum
{
    NBDrawStateSuccesful,              ///< 绘制成功
    NBDrawStateFailFrameNotInit,       ///< 绘制失败(绘制框架没初始化)
    NBDrawStateFailOverFrame,          ///< 绘制失败(绘制框架越界)
} NBDrawState;

@interface PageSplitRender : NSObject

//+ (NBChapterPagesInfo*)splittingPagesForString:(NSString*)content withChapterName:(NSString*)chapterName andLayoutConfig:(NBBookLayoutConfig*)config;

+ (NSString *)normalizedContentText:(NSString *)content;
+ (NSString*)getChapterContentStr:(NSString*)content;


- (id)initWithLayoutConfig:(NBBookLayoutConfig*)config chapterName:(NSString*)chapterName chapterText:(NSString*)chapterText;

/*!
 @function	绘制当前页的文字内容
 
 @param		nTextStartLocation: 当前页文本在整个排版文本字符串中的起始位置
 
 @param		nPageTextLength：当前页面字符长度
 
 */
- (NBDrawState)drawInContext:(CGContextRef)context withRect:(CGRect)rect withStart:(int)nTextStartLocation withLength:(int)nPageTextLength;


@end


