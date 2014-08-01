/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 me. All Rights Reserved
 * File         :  ContentViewController.mm
 * Description	:  每一页的viewController
 * Author       :  xxx@ucweb.com
 * History      :  Creation, 2014/08/01
 ******************************************************************************
 **/



#import "ContentViewController.h"
//#import "ResManager.h"
//#import "NSObject_Event.h"
//#import "NovelBoxMacroDefine.h"
#define kTitleFontSize                     (28/2.0f)
#define kPageTitleMarginX                  (32/2.0f)
#define kPageTitleViewHeight               ((96-20)/2.0f)


@interface ContentViewController()

@property (nonatomic, retain) UILabel* pageTitleView;
@property (nonatomic, retain) PageView* pageView;
@property (nonatomic, assign) CGRect rect;

///< 单指点击起始点
@property (nonatomic) CGPoint begin;

@end

@implementation ContentViewController

+ (ContentViewController*)contentViewControllerForChapterIndex:(NSInteger)chapterIndex
                                                     pageIndex:(NSInteger)pageIndex
                                                      delegate:(id<ContentViewControllerDelegate>)delegate
                                            pageViewDataSource:(id<PageViewDataSource>)dataSource
                                              pageViewDelegate:(id<PageViewDelegate>)pageDelegate
                                                          rect:(CGRect)rect
                                                    layoutSize:(CGSize)size
{
    return [[[self alloc] initWithChapterIndex:chapterIndex
                                    pageIndex:pageIndex
                                     delegate:delegate
                           pageViewDataSource:dataSource
                             pageViewDelegate:pageDelegate
                                          rect:rect
                                    layoutSize:size] autorelease];
}

- (id)initWithChapterIndex:(NSInteger)chapterIndex
                 pageIndex:(NSInteger)pageIndex
                  delegate:(id<ContentViewControllerDelegate>)delegate
        pageViewDataSource:(id<PageViewDataSource>)dataSource
          pageViewDelegate:(id<PageViewDelegate>)pageDelegate
                      rect:(CGRect)rect
                layoutSize:(CGSize)size
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil)
    {
        self.chapterIndex = chapterIndex;
        self.pageIndex = pageIndex;
        self.delegate = delegate;
        self.rect = rect;
        self.isBackPage = YES;

        
        [self addTxtPageView:pageDelegate dataSource:dataSource layoutSize:size];
        [self updateTxtPageView];
        
//        connectGlobalEvent(@selector(didThemeChange), self, @selector(didThemeChange));
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = self.rect;
}

- (void)dealloc
{
    self.pageView.delegate = nil;
    self.pageView = nil;
    self.pageTitleView = nil;
	
	self.textViewObj = nil;
	self.delegate = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)addTxtPageView:(id<PageViewDelegate>)pageDelegate dataSource:(id<PageViewDataSource>)dataSource layoutSize:(CGSize)size
{
	CGRect rect = self.rect;
	rect.size.height = kPageTitleViewHeight;
	[self addPageTitleView:rect];
	
    if (!_pageView)
    {
		rect.origin.y += rect.size.height;
		rect.size.height = self.rect.size.height - rect.origin.y;
        self.pageView = [[[PageView alloc] initWithFrame:rect layoutSize:size] autorelease];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pageView.dataSource = dataSource;
        _pageView.delegate = pageDelegate;
        //[_pageView setPageBackgroundColor:resGetColor(@"NovelBox/NovelReaderBackground")];
        [_pageView setPageBackgroundColor:[UIColor grayColor]];
        
        [self.view addSubview:_pageView];
    }
}

- (void)addPageTitleView:(CGRect)rect
{
	if (_pageTitleView == nil)
	{
		UIView* titleContentView = [[[UIView alloc] initWithFrame:rect] autorelease];
        titleContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//titleContentView.backgroundColor = resGetColor(@"NovelBox/NovelReaderBackground");
		titleContentView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:titleContentView];
		
		CGRect titleRect = CGRectMake(kPageTitleMarginX, 0, rect.size.width - kPageTitleMarginX, 40);
		titleRect.origin.y = (int)(rect.size.height - titleRect.size.height) * 0.5f;
		UILabel* titleLabel = [[[UILabel alloc] initWithFrame:titleRect] autorelease];
		titleLabel.textAlignment = NSTextAlignmentLeft;
		titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        //[titleLabel setTextColor:resGetColor(@"NovelBox/titleTextColor")];
        [titleLabel setTextColor:[UIColor blackColor]];
		titleLabel.backgroundColor = [UIColor clearColor];
		[titleContentView addSubview:titleLabel];
		
		self.pageTitleView = titleLabel;
	}
}

- (void)updateTxtPageView
{
    CGImageRef imageRef = [_pageView.pageCache cachedImageForPageIndex:_pageIndex chapterIndex:_chapterIndex];
    _pageView.layer.contents = (id)imageRef;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (event.allTouches.count == 1)
    {
        _begin = [[[event.allTouches allObjects] objectAtIndex:0] locationInView:self.view];
        [_delegate beginTouch:_begin];
    }
    else if (event.allTouches.count == 2)
    {
        [_delegate lockGesture];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_delegate releaseGesture];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_delegate releaseGesture];
}

#pragma mark - theme change
- (void)didThemeChange
{
    [[_pageTitleView superview] setBackgroundColor:[UIColor grayColor]];
    [_pageTitleView setTextColor:[UIColor blackColor]];
    [_pageView setPageBackgroundColor:[UIColor grayColor]];
}

#pragma mark - pageView Update
- (void)updateTitle:(NSString*)title
{
    if (![_pageTitleView.text isEqualToString:title])
	{
        _pageTitleView.text = title;
	}
}

@end
