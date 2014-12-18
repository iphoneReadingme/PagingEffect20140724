
/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 me. All Rights Reserved
 * File         :  PageViewCache.h
 * Description	:  PageView缓存
 * Author       :  xxx@ucweb.com
 * History      :  Creation, 2014/08/01
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
