//
//  ViewController.m
//  pageDemo
//
//  Created by ren kai on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//

#import "NBPageViewController.h"

@implementation NBPageViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController *startCtrl = [[UIViewController alloc] init];
    startCtrl.view.backgroundColor = [UIColor blueColor];
    self.delegate = self;
    self.dataSource = self;
    
    [self setViewControllers:[NSArray arrayWithObject:startCtrl] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController{
    if ([viewController.view.backgroundColor isEqual:[UIColor blackColor]]) {
        return nil;
    }
	//    + (UIColor *)blackColor;      // 0.0 white
	//	+ (UIColor *)darkGrayColor;   // 0.333 white
	//	+ (UIColor *)lightGrayColor;  // 0.667 white
	//	+ (UIColor *)whiteColor;      // 1.0 white
	//	+ (UIColor *)grayColor;       // 0.5 white
	//	+ (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB
	//	+ (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB
	//	+ (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB
	//	+ (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB
	//	+ (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB
	//	+ (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB
	//	+ (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB
	//	+ (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB
	//	+ (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB
	//	+ (UIColor *)clearColor;      // 0.0 white, 0.0 alpha
	
	
    UIViewController *viewCtrl = [[UIViewController alloc] init];
    if ([viewController.view.backgroundColor isEqual:[UIColor blueColor]]) {
        viewCtrl.view.backgroundColor = [UIColor blackColor];
    } else {
        viewCtrl.view.backgroundColor = [UIColor blueColor];
    }
    
	
    
    return viewCtrl;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([viewController.view.backgroundColor isEqual:[UIColor redColor]]) {
        return nil;
    }
    
    UIViewController *viewCtrl = [[UIViewController alloc] init];
    if ([viewController.view.backgroundColor isEqual:[UIColor blueColor]]) {
        viewCtrl.view.backgroundColor = [UIColor redColor];
    } else {
        viewCtrl.view.backgroundColor = [UIColor blueColor];
    }
    
    
    return viewCtrl;
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
