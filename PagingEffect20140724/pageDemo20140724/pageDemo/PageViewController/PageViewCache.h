/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 UC Mobile Limited. All Rights Reserved
 * File         :  PageViewCache.h
 * Description	:  PageView缓存
 * Author       :  yuping@ucweb.com
 * History      :  Creation, 2013/11/23, yuping, Create the file
 ******************************************************************************
 **/


#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <CoreGraphics/CGImage.h>


@protocol PageViewDataSource;

@interface PageViewCache : NSObject

@property (nonatomic, assign) CGSize pageSize;
@property (assign) id<PageViewDataSource> dataSource;

- (id)initWithPageSize:(CGSize)aPageSize;
- (CGImageRef)cachedImageForPageIndex:(NSUInteger)pageIndex chapterIndex:(NSUInteger)chapterIndex;
- (void)precacheImageForPageIndex:(NSUInteger)pageIndex chapterIndex:(NSUInteger)chapterIndex;

@end
