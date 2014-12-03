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

#ifdef  Enable_test
//#define PageSplitRender_memober

#import "BookLayoutConfig.h"
//#import "NBProviderDataStructures.h"


@interface PageSplitRender : NSObject

#ifdef PageSplitRender_memober

@property (nonatomic, readonly) id<NBChapterItemProtocol> chapterItem;
@property (nonatomic, readonly) NBChapterPagesInfo * pagesInfo;

+ (NBChapterPagesInfo*)splittingPagesForString:(NSString*)content withChapterItem:(id<NBChapterItemProtocol>)chapterItem andLayoutConfig:(BookLayoutConfig*)config;

+ (NSString *)normalizedContentText:(NSString *)content;


- (id)initWithLayoutConfig:(BookLayoutConfig*)config andChapterItem:(id<NBChapterItemProtocol>)chapterItem andPagesInfo:(NBChapterPagesInfo*)pagesInfo andChapterContent:(NSString*)content;

- (BOOL)drawInContext:(CGContextRef)context withRect:(CGRect)rect andPageIndex:(int)pageIndex;

#endif
+ (CTFramesetterRef)formatString:(NSString *)contentStr withChapterName:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config;

@end

#endif
