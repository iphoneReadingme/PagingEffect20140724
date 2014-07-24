/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 UC Mobile Limited. All Rights Reserved
 * File         :  ContentViewController.h
 * Description	:  每一页的viewController
 * Author       :  yuping@ucweb.com
 * History      :  Creation, 2013/12/18, yuping, Create the file
 ******************************************************************************
 **/



#import <UIKit/UIKit.h>
#import "PageView.h"


@protocol ContentViewControllerDelegate <NSObject>
@optional

///< 通知touch事件触发begin时的坐标
- (void)beginTouch:(CGPoint)begin;

///< 通知锁定手势
- (void)lockGesture;

///< 通知释放手势
- (void)releaseGesture;

///< 获取当前是否已锁定手势
- (BOOL)isLocked;

@end


@interface ContentViewController : UIViewController

@property (nonatomic) NSInteger chapterIndex;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) BOOL isBackPage;
@property (nonatomic, assign) id<ContentViewControllerDelegate> delegate;

+ (ContentViewController*)contentViewControllerForChapterIndex:(NSInteger)chapterIndex
                                                     pageIndex:(NSInteger)pageIndex
                                                      delegate:(id<ContentViewControllerDelegate>)delegate
                                            pageViewDataSource:(id<PageViewDataSource>)dataSource
                                              pageViewDelegate:(id<PageViewDelegate>)pageDelegate
                                                          rect:(CGRect)rect
                                                    layoutSize:(CGSize)size;

- (void)updateTitle:(NSString*)title;

@end
