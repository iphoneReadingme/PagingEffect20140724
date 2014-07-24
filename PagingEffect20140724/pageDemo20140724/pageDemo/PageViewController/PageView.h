/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 UC Mobile Limited. All Rights Reserved
 * File         :  PageView.h
 * Description	:  小说阅读器每一页视图PageView
 * Author       :  yuping@ucweb.com
 * History      :  Creation, 2013/11/23, yuping, Create the file
 ******************************************************************************
 **/



#import <UIKit/UIKit.h>
#import "PageViewCache.h"


#define CHAPTERINDEX_KEY    @"chapterindex_key"
#define PAGEINDEX_KEY       @"pageindex_key"


@protocol PageViewDataSource;
@protocol PageViewDelegate;
@interface PageView : UIView

@property (assign) id<PageViewDataSource> dataSource;
@property (assign) id<PageViewDelegate> delegate;
@property (nonatomic, retain) PageViewCache* pageCache;

- (id)initWithFrame:(CGRect)frame layoutSize:(CGSize)size;
- (void)setPageBackgroundColor:(UIColor *)color;

@end

@protocol PageViewDataSource <NSObject>

///< 渲染指定的页面
- (BOOL)renderPageAtIndex:(NSInteger)index atChapterIndex:(NSInteger)chapterIndex inContext:(CGContextRef)context;

@end


@protocol PageViewDelegate <NSObject>

@optional

///< 将要切换到指定页面
- (void)pageView:(PageView*)pageView willTurnToPageAtIndex:(NSInteger)pageIndex atChapter:(NSInteger)chapterIndex;

///< 已经切换到指定页面
- (void)pageView:(PageView*)pageView didTurnToPageAtIndex:(NSInteger)pageIndex atChapter:(NSInteger)chapterIndex;

///< 将要显示工具菜单
- (void)pageView:(PageView*)pageView willShowNavBarAndMenu:(BOOL)show;

@end

