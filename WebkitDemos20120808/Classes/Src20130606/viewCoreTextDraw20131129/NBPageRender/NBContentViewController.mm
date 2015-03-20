/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 UC Mobile Limited. All Rights Reserved
 * File         :  ContentViewController.m
 * Description	:  每一页的viewController
 * Author       :  yuping@ucweb.com
 * History      :  Creation, 2013/12/18, yuping, Create the file
 ******************************************************************************
 **/



#import "NBContentViewController.H"
#import "ResManager.h"
#import "NSObject_Event.h"
#import "NovelBoxMacroDefine.h"
#import "UIViewAdditions.h"
#import "NBSkinResManager.h"
#import "BottomStatusView.h"


#define BOTTOMSTATUS_PAGEVIEW_MARGIN    7

#define RETURN_IF_IS_NOT_FullPage \
if (NO == self.isFullPage) \
{ \
return; \
}


@interface NBContentViewController()

@property (nonatomic, retain) UILongPressGestureRecognizer*     longPressGestureObj;     ///< 长按手势识别器

@property (nonatomic, retain) PageView* pageView;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) UILabel* pageTitleView;
@property (nonatomic, retain) BottomStatusView* bottomStatusView;
@property (nonatomic, assign) BOOL isFullPage;

@property (nonatomic, retain) UIView                *selectedBackgroundView;

///< 单指点击起始点
@property (nonatomic) CGPoint begin;

@end

@implementation NBContentViewController

+ (NBContentViewController*)contentViewControllerForChapterItem:(NBChapterItemPointer)chapterItem
                                                       pageIndex:(NSInteger)pageIndex
                                                        delegate:(id<NBContentViewControllerDelegate>)delegate
                                            NBPageViewDataSource:(id<NBPageViewDataSource>)dataSource
                                                            rect:(CGRect)rect
                                                      layoutSize:(CGSize)size
                                                      isFullPage:(BOOL)isFullPage
{
    return [[[self alloc] initWithChapterIndex:chapterItem
                                    pageIndex:pageIndex
                                     delegate:delegate
                           NBPageViewDataSource:dataSource
                                          rect:rect
                                    layoutSize:size
                                    isFullPage:isFullPage] autorelease];
}

- (id)initWithChapterIndex:(NBChapterItemPointer)chapterItem
                 pageIndex:(NSInteger)pageIndex
                  delegate:(id<NBContentViewControllerDelegate>)delegate
        NBPageViewDataSource:(id<NBPageViewDataSource>)dataSource
                      rect:(CGRect)rect
                layoutSize:(CGSize)size
                isFullPage:(BOOL)isFullPage
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil)
    {
        self.chapterItem = chapterItem;
        self.pageIndex = pageIndex;
        self.delegate = delegate;
        self.rect = rect;
        self.isBackPage = YES;
        self.isFullPage = isFullPage;
		
		[self addSelectedBGView];
        [self addTxtPageView:dataSource layoutSize:size];
        [self updateTxtPageView];
        
        connectGlobalEvent(@selector(didThemeChange), self, @selector(didThemeChange));
        connectGlobalEvent(@selector(didNovelBoxSkinChange), self, @selector(didNovelBoxSkinChange));
        connectGlobalEvent(@selector(didNovelBoxThemeChangeInAdvance), self, @selector(didNovelBoxThemeChangeInAdvance));
    }
    return self;
}

#pragma mark - UI Layout

- (void)addPageTitleView
{
	if (_pageTitleView == nil)
	{
        CGRect rect = CGRectMake(0, 0, self.view.width, kPageTitleViewHeight);
		UIView* titleBgView = [[[UIView alloc] initWithFrame:rect] autorelease];
		titleBgView.backgroundColor = resGetColorFromNovelBoxSkin(@"NovelBox/NovelReaderBackground");
        titleBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.view addSubview:titleBgView];
		
		CGRect titleRect = CGRectMake(kPageTitleMarginX, 0, rect.size.width - kPageTitleMarginX, rect.size.height);
		self.pageTitleView = [[[UILabel alloc] initWithFrame:titleRect] autorelease];
		_pageTitleView.textAlignment = NSTextAlignmentLeft;
		_pageTitleView.lineBreakMode = NSLineBreakByTruncatingTail;
        _pageTitleView.font = [UIFont systemFontOfSize:kTitleFontSize];
        [_pageTitleView setTextColor:resGetColorFromNovelBoxSkin(@"NovelBox/titleTextColor")];
		_pageTitleView.backgroundColor = [UIColor clearColor];
		_pageTitleView.accessibilityLabel = @"pageTitleView_章节标题";
        _pageTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[titleBgView addSubview:_pageTitleView];
    }
}

- (void)addBottomStatusView
{
#ifndef UC_ENABLE_KIF_TEST
    if (!_bottomStatusView)
    {
        CGRect rect = self.view.bounds;
        self.bottomStatusView = [[[BottomStatusView alloc] initWithFrame:CGRectMake(0, rect.size.height - kBottomStatusbarHeight, rect.size.width, kBottomStatusbarHeight)] autorelease];
        self.bottomStatusView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_bottomStatusView];
        
        [self updateBatteryLevel];
    }
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = self.rect;
	self.view.accessibilityLabel = @"NBContentViewController_view";
    
    if (self.isFullPage)
    {
        [self addPageTitleView];
        [self addBottomStatusView];
        [self registerBatteryNotification];
    }
	
	[self addLongPressGestureRecognizer];
}

- (void)dealloc
{
    disconnectAllEvent(self);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[self removeLongPressGestureObj];
	
    self.chapterItem = nil;
    
    self.pageView.dataSource = nil;
    self.pageView.layer.contents = nil;
    self.pageView = nil;
    
    self.pageTitleView = nil;
    self.bottomStatusView = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)updateBottomStatusTimeLabel
{
    RETURN_IF_IS_NOT_FullPage

    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"hh:mm"];
    [_bottomStatusView updateTimeLabel:[formatter stringFromDate:[NSDate date]]];
}

#pragma mark - battery change notifications.
- (void)registerBatteryNotification
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(batteryLevelChanged:)
												 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(batteryStateChanged:)
												 name:UIDeviceBatteryStateDidChangeNotification object:nil];
}

- (void)batteryLevelChanged:(NSNotification*)notification
{
    RETURN_IF_IS_NOT_FullPage
    [self updateBatteryLevel];
}

- (void)batteryStateChanged:(NSNotification*)notification
{
    RETURN_IF_IS_NOT_FullPage
    [self updateBatteryLevel];
}


- (void)updateBatteryLevel
{
    RETURN_IF_IS_NOT_FullPage
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    if (batteryLevel < 0.0)
    {
        // -1.0 means battery state is UIDeviceBatteryStateUnknown
        batteryLevel = 0;
    }
    
    [_bottomStatusView updateBattery:batteryLevel];
}

#pragma mark - PageTitleView

- (void)updatePageTitleView:(NSString*)chapterName
{
    RETURN_IF_IS_NOT_FullPage
    
    if (![_pageTitleView.text isEqualToString:chapterName])
    {
       _pageTitleView.text = chapterName;
    }
}

#pragma mark - BottomStatusView

- (void)updatePageNumberLabel:(NSString*)text
{
    RETURN_IF_IS_NOT_FullPage
    
    [_bottomStatusView updatePageNumberLabel:text];
    
    ///< battery
    [self updateBatteryLevel];
    
    ///< time
    [self updateBottomStatusTimeLabel];
}

#pragma mark - Update TxtPageView

- (void)addTxtPageView:(id<NBPageViewDataSource>)dataSource layoutSize:(CGSize)size
{
    if (!_pageView)
    {
        CGRect frame = self.rect;
        
        if (self.isFullPage)
        {
            frame.origin.y += kPageTitleViewHeight;
            frame.size.height -= (kBottomStatusbarHeight + kPageTitleViewHeight);
        }
        
        self.pageView = [[[PageView alloc] initWithFrame:frame layoutSize:size] autorelease];
        _pageView.dataSource = dataSource;
        [_pageView setPageBackgroundColor:resGetColorFromNovelBoxSkin(@"NovelBox/NovelReaderBackground")];
        [self.view addSubview:_pageView];
    }
}

- (void)updateTxtPageView
{
    CGImageRef imageRef = [_pageView.pageCache cachedImageForPageIndex:_pageIndex chapterItem:_chapterItem];
    _pageView.layer.contents = (id)imageRef;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (event.allTouches.count == 1)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(beginTouch:)])
        {
            _begin = [[[event.allTouches allObjects] objectAtIndex:0] locationInView:self.view];
            [_delegate beginTouch:_begin];
        }
    }
    else if (event.allTouches.count == 2)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(lockGesture)])
        {
            [_delegate lockGesture];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(releaseGesture)])
    {
        [_delegate releaseGesture];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(releaseGesture)])
    {
        [_delegate releaseGesture];
    }
}

#pragma mark - theme change
- (void)didThemeChange
{
    [_pageView setPageBackgroundColor:resGetColorFromNovelBoxSkin(@"NovelBox/NovelReaderBackground")];
}

- (void)didNovelBoxSkinChange
{
    [_pageView setPageBackgroundColor:resGetColorFromNovelBoxSkin(@"NovelBox/NovelReaderBackground")];
}

- (void)didNovelBoxThemeChangeInAdvance
{
    [self didThemeChange];
}

#pragma mark -==选择背景的处理
- (CGRect)getPageViewFrame
{
	CGRect frame = self.rect;
	
	if (self.isFullPage)
	{
		frame.origin.y += kPageTitleViewHeight;
		frame.size.height -= (kBottomStatusbarHeight + kPageTitleViewHeight);
	}
	
	return frame;
}
- (void)addSelectedBGView
{
	_selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	_selectedBackgroundView.backgroundColor = [UIColor grayColor];
	[self.view addSubview:_selectedBackgroundView];
}

- (void)releaseSelectedBGView
{
	[_selectedBackgroundView release];
	_selectedBackgroundView = nil;
}

#pragma mark -==长按手势处理
- (void)removeLongPressGestureObj
{
	[_longPressGestureObj removeTarget:self action:@selector(handleLongPress:)];
	_longPressGestureObj.delegate = nil;
	[_longPressGestureObj release];
	_longPressGestureObj = nil;
}

- (void)addLongPressGestureRecognizer
{
	if (_longPressGestureObj)
	{
		return;
	}
	
	// 添加长按手势
	_longPressGestureObj = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	[self.view addGestureRecognizer:_longPressGestureObj];
}

-(void)handleLongPress:(UILongPressGestureRecognizer*)longPressRecognizer
{
	if (longPressRecognizer.state == UIGestureRecognizerStateBegan)
	{
		NSLog(@"==handleLongPress=gestureRecognizer===%@", longPressRecognizer);
		
		CGPoint pt = (CGPoint)[longPressRecognizer locationInView:self.pageView];
		CGRect rect = CGRectZero;
		rect.origin = pt;
		rect.size.width = 100;
		rect.size.height = 60;
		[_selectedBackgroundView setFrame:rect];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

@end
