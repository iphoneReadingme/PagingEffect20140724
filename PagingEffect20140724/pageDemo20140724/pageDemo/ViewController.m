//
//  ViewController.m
//  pageDemo
//
//  Created by ren kai on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//


#import "ContentViewController.h"
#import "ViewController.h"


@interface NBPageViewController()

@property (nonatomic, assign)int currentPageIndex; ///< 当前显示页面的索引

@end

@implementation NBPageViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
    self.dataSource = self;
	
	_currentPageIndex = 0;
	
    UIViewController *startCtrl = nil;
	startCtrl = [self getCurrentPageViewController:0]; ///< 初始化当前UIViewController
	
    [self setViewControllers:[NSArray arrayWithObject:startCtrl] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
}

///< 翻到下一页
- (UIViewController *)turnToNextPage
{
	_currentPageIndex++;
	if (_currentPageIndex > 13)
	{
		_currentPageIndex = 0;
	}
	
	return [self getCurrentPageViewController:_currentPageIndex];
}

///< 翻到上一页
- (UIViewController *)turnToPreviousPage
{
	_currentPageIndex--;
	if (_currentPageIndex < 0)
	{
		_currentPageIndex = 0;
	}
	return [self getCurrentPageViewController:_currentPageIndex];
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
	
    UIViewController *viewCtrl = [[[ContentViewController alloc] init] autorelease];
//    UIViewController *viewCtrl = [[[UIViewController alloc] init] autorelease];
	
	UILabel* lable = [[UILabel alloc] initWithFrame:[viewCtrl.view frame]];
	//viewCtrl.view = lable;
	lable.text = [NSString stringWithFormat:@"color=%d, %@", index, [UIColor purpleColor]];
	[lable release];
	
	viewCtrl.view.backgroundColor = bgColor[index];
	
    return viewCtrl;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
       viewControllerAfterViewController:(UIViewController *)viewController
{
	return [self turnToNextPage];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
	return [self turnToPreviousPage];
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController 
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    UIViewController *currentViewController = [self.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.doubleSided = NO;
	
	UIPageViewControllerSpineLocation spine = UIPageViewControllerSpineLocationMax;
	spine = UIPageViewControllerSpineLocationMin;
    return spine;
}


@end
