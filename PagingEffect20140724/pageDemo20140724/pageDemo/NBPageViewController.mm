//
//  NBPageViewController.m
//  pageDemo
//
//  Created by ren kai on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//


#import "ContentViewController.h"
#import "NBPageViewController.h"



typedef enum
{
    touchevent_error
	,touchevent_prepage
	,touchevent_menu
	,touchevent_nextpage
}TOUCHEVENT_TYPE;


@interface NBPageViewController()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate
,ContentViewControllerDelegate
>

@property (nonatomic) TOUCHEVENT_TYPE touchType;
@property (nonatomic) CGPoint itemBeginPoint;
@property (nonatomic) BOOL isTurnPage;
@property (nonatomic, assign) double lastTimeTap;
@property (nonatomic) BOOL isMenuShow;

@property (nonatomic, assign)int currentPageIndex; ///< 当前显示页面的索引

@end

@implementation NBPageViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.isTurnPage = YES;
	
	[self addFirstPage];
}

- (void)addFirstPage
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
    self.dataSource = self;
	
	_currentPageIndex = 0;
	
    UIViewController *startCtrl = nil;
    UIViewController *secondCtrl = nil;
	startCtrl = [self getCurrentPageViewController:0]; ///< 初始化当前UIViewController
	secondCtrl = [self getCurrentPageViewController:1];
	
    NSArray *viewControllers = nil;
	viewControllers = [NSArray arrayWithObject:startCtrl];
	//viewControllers = [NSArray arrayWithObjects:startCtrl, secondCtrl, nil];
	
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
}

///< 翻到下一页
- (UIViewController *)turnToNextPage
{
    UIViewController* nextViewController = nil;;
	_currentPageIndex++;
	if (_currentPageIndex > 13)
	{
		_currentPageIndex = 0;
	}
	else
	{
		nextViewController = [self getCurrentPageViewController:_currentPageIndex];
	}
	
	return nextViewController;
}

///< 翻到上一页
- (UIViewController *)turnToPreviousPage
{
	UIViewController* preViewController = nil;
	
	_currentPageIndex--;
	if (_currentPageIndex < 0)
	{
		_currentPageIndex = 0;
	}
	else
	{
		preViewController = [self getCurrentPageViewController:_currentPageIndex];
	}
	return preViewController;
}

- (UIViewController *)getCurrentPageViewController:(int)index
{
	UIColor* bgColor[] =
	{
		[UIColor blueColor],
		[UIColor darkGrayColor],
		[UIColor lightGrayColor],
		[UIColor whiteColor],
		[UIColor grayColor],
		[UIColor redColor],
		[UIColor greenColor],
		[UIColor blueColor],
		[UIColor cyanColor],
		[UIColor yellowColor],
		[UIColor magentaColor],
		[UIColor orangeColor],
		[UIColor purpleColor],
		[UIColor brownColor],
	};
	
    ContentViewController *viewCtrl = [[[ContentViewController alloc] init] autorelease];
	viewCtrl.isBackPage = YES;
	
	CGRect rect = CGRectMake(0, 50, 300, 30);
	UILabel* lable = [[UILabel alloc] initWithFrame:rect];
	lable.backgroundColor = [UIColor grayColor];
	[viewCtrl.view addSubview:lable];
	lable.text = [NSString stringWithFormat:@"color=%d, 显示当前页面显示内容：%d%d%d", index, index, index, index];
	[lable release];
	
	viewCtrl.view.backgroundColor = bgColor[index];
	viewCtrl.delegate = self;
	
    return viewCtrl;
}

//#pragma mark - UIPageViewControllerDataSource
- (void)setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [super setViewControllers:viewControllers direction:direction animated:animated completion:completion];
}

#pragma mark- UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
	NSLog(@"After viewController = %@", viewController);
	
	ContentViewController *newViewController =nil;
	
    ContentViewController* curViewController = (ContentViewController*)viewController;
	if (curViewController.isBackPage)
	{
		newViewController = (ContentViewController*)[self getCurrentPageViewController:_currentPageIndex];
		newViewController.isBackPage = NO;
		newViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
	}
	else
	{
		newViewController = (ContentViewController*)[self turnToNextPage];
	}
    
	return newViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSLog(@"Before viewController = %@", viewController);
	
	ContentViewController *newViewController =nil;
	
    ContentViewController* curViewController = (ContentViewController*)viewController;
	if (curViewController.isBackPage)
	{
		newViewController = (ContentViewController*)[self turnToPreviousPage];
		newViewController.isBackPage = NO;
		newViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
	}
	else
	{
		newViewController = (ContentViewController*)[self getCurrentPageViewController:_currentPageIndex];
	}
    
	return newViewController;
}

#pragma mark- UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController*)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray*)previousViewControllers transitionCompleted:(BOOL)completed
{
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController 
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    UIViewController *currentViewController = [self.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    //self.doubleSided = NO;
	self.doubleSided = YES;
	
	UIPageViewControllerSpineLocation spine = UIPageViewControllerSpineLocationMax;
	spine = UIPageViewControllerSpineLocationMin;
//	spine = UIPageViewControllerSpineLocationMid;
	
	return spine;
}







- (void)goToPrePageView
{
	UIViewController* currentViewController = nil;
	//currentViewController = [self getCurrentPageViewController:_currentPageIndex];
	
	_currentPageIndex--;
	if (_currentPageIndex < 0)
	{
		_currentPageIndex = 0;
	}
	else
	{
		currentViewController = [self getCurrentPageViewController:_currentPageIndex];
		currentViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
		
		UIViewController* preViewController = nil;
		preViewController = [self getCurrentPageViewController:_currentPageIndex];
		
		[self goToPrePageViewController:preViewController backViewController:currentViewController];
	}
}

- (void)goToNextPageView
{
	UIViewController* currentViewController = nil;
//	currentViewController = [self getCurrentPageViewController:_currentPageIndex];
	currentViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
	
	_currentPageIndex++;
	if (_currentPageIndex > 13)
	{
		_currentPageIndex = 0;
	}
	else
	{
		currentViewController = [self getCurrentPageViewController:_currentPageIndex];
		currentViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
		
		UIViewController* nextViewController = nil;
		nextViewController = [self getCurrentPageViewController:_currentPageIndex];
		[self goToNextPageViewController:currentViewController nextViewController:nextViewController];
	}
}

- (void)goToPrePageViewController:(UIViewController*)preViewController backViewController:(UIViewController*)backViewController
{
    if (preViewController == nil || backViewController == nil)
    {
        return;
    }
	
    NSArray *viewControllers = nil;
//	viewControllers = [NSArray arrayWithObject:preViewController];
	viewControllers = [NSArray arrayWithObjects:preViewController, backViewController, nil];
    
    [self setViewControllers:viewControllers
				   direction:UIPageViewControllerNavigationDirectionReverse
					animated:YES
				  completion:NULL];
}

- (void)goToNextPageViewController:(UIViewController*)currentViewController nextViewController:(UIViewController*)nextViewController
{
    if (currentViewController == nil || nextViewController == nil)
    {
        return;
    }
    
    NSArray *viewControllers = nil;
//	viewControllers = [NSArray arrayWithObject:nextViewController];
	viewControllers = [NSArray arrayWithObjects:nextViewController, currentViewController, nil];
	[self setViewControllers:viewControllers
	 			   direction:UIPageViewControllerNavigationDirectionForward
					animated:YES
				  completion:NULL];
}

- (BOOL)touchedMenuRect:(CGPoint)point
{
    CGRect rect = self.view.bounds;
    CGRect menuRect = CGRectMake(rect.size.width / 5, rect.size.height / 3, rect.size.width * 3 / 5, rect.size.height / 3);
    
    return CGRectContainsPoint(menuRect, point);
}

- (BOOL)touchedNextRect:(CGPoint)point
{
    CGRect rect = self.view.bounds;
    CGRect nextRightRect = CGRectMake(rect.size.width * 4 / 5, 0, rect.size.width / 5, rect.size.height * 2 / 3);
    CGRect nextBottomRect = CGRectMake(rect.size.width / 5, rect.size.height * 2 / 3, rect.size.width * 4 / 5, rect.size.height / 3);
    
    return CGRectContainsPoint(nextRightRect, point) || CGRectContainsPoint(nextBottomRect, point);
}

- (BOOL)touchedPrevRect:(CGPoint)point
{
    CGRect rect = self.view.bounds;
    CGRect preLeftRect = CGRectMake(0, rect.size.height / 3, rect.size.width / 5, rect.size.height * 2 / 3);
    CGRect preTopRect = CGRectMake(0, 0, rect.size.width * 4 / 5, rect.size.height / 3);
    
    return CGRectContainsPoint(preLeftRect, point) || CGRectContainsPoint(preTopRect, point);
}

- (TOUCHEVENT_TYPE)touchTypeWithPoint:(CGPoint)point
{
    TOUCHEVENT_TYPE type = touchevent_error;
    if ([self touchedMenuRect:point])
    {
        type = touchevent_menu;
    }
    else if ([self touchedNextRect:point])
    {
        type = touchevent_nextpage;
    }
    else if ([self touchedPrevRect:point])
    {
        type = touchevent_prepage;
    }
    
    return type;
}

- (BOOL)isIgnoreTouchEvent
{
    BOOL ignore = NO;
    double time = [[NSDate date] timeIntervalSince1970];
    if (time - _lastTimeTap >= 0.5)
    {
        _lastTimeTap = time;
    }
    else
    {
        ignore = YES;
    }
    
    return ignore;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        CGPoint pointOne = [touch locationInView:self.view];
        self.touchType = [self touchTypeWithPoint:pointOne];
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    BOOL shouldBegin = YES;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        if (!_isTurnPage)
        {
            shouldBegin = NO;
        }
        else
        {
//            if (![_nbDelegate isUseInteractionEnable])
//            {
//                shouldBegin = NO;
//            }
//            else
            {
                if (fabsf(point.y - _itemBeginPoint.y) / fabsf(point.x - _itemBeginPoint.x) > 1.5)
                {
                    [self lockGesture];
                    shouldBegin = NO;
                }
                else
                {
                    if (_isMenuShow)
                    {
                        //[_nbDelegate hideMenu];
                        _isMenuShow = NO;
                        shouldBegin = NO;
                    }
                    else
                    {
                        shouldBegin = [self isIgnoreTouchEvent] ? NO :YES;
                    }
                }
            }
        }
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (!_isTurnPage)
        {
            shouldBegin = NO;
        }
        else
        {
            if (self.touchType == touchevent_menu
				//|| ![_nbDelegate isUseInteractionEnable]
				)
            {
                if (_isMenuShow)
                {
                    //[_nbDelegate hideMenu];
                    _isMenuShow = NO;
                }
                else
                {
                    //[_nbDelegate showMenu];
                    _isMenuShow = YES;
                }
            }
            else
            {
                if (_isMenuShow)
                {
                    //[_nbDelegate hideMenu];
                    _isMenuShow = NO;
                }
                else
                {
                    if (self.touchType == touchevent_nextpage)
                    {
                        if (![self isIgnoreTouchEvent])
                        {
                            [self goToNextPageView];
                        }
                    }
                    else if (self.touchType == touchevent_prepage)
                    {
                        if (![self isIgnoreTouchEvent])
                        {
                            [self goToPrePageView];
                        }
                    }
                }
            }
            
            shouldBegin = NO;
        }
    }
    
    return shouldBegin;
}

#pragma mark - ContentViewControllerDelegate
- (void)beginTouch:(CGPoint)begin
{
    self.itemBeginPoint = begin;
}

- (void)lockGesture
{
    self.isTurnPage = NO;
}

- (BOOL)isLocked
{
    return !self.isTurnPage;
}

- (void)releaseGesture
{
    self.isTurnPage = YES;
}



@end
