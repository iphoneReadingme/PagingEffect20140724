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

#import "BookLayoutConfig.h"
#import "NBProviderDataStructures.h"


@interface PageSplitRender : NSObject

@property (nonatomic, readonly) NBChapterItem * chapterItem;
@property (nonatomic, readonly) NBChapterPagesInfo * pagesInfo;

+ (NBChapterPagesInfo*)splittingPagesForString:(NSString*)content withChapterItem:(NBChapterItem*)chapterItem andLayoutConfig:(BookLayoutConfig*)config;

+ (NSString *)normalizedContentText:(NSString *)content;


- (id)initWithLayoutConfig:(BookLayoutConfig*)config andChapterItem:(NBChapterItem*)chapterItem andPagesInfo:(NBChapterPagesInfo*)pagesInfo andChapterContent:(NSString*)content;

- (BOOL)drawInContext:(CGContextRef)context withRect:(CGRect)rect andPageIndex:(int)pageIndex;


@end


