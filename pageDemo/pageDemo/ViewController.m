//
//  ViewController.m
//  pageDemo
//
//  Created by ren kai on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

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
	
    UIViewController *viewCtrl = [[UIViewController alloc] init];
	static int index = 0;
	index++;
	if (index > 13)
	{
		index = 0;
	}
	
	UILabel* lable = [[UILabel alloc] initWithFrame:[viewCtrl.view frame]];
	viewCtrl.view = lable;
	lable.text = [NSString stringWithFormat:@"color=%d, %@", index, [UIColor purpleColor]];
	[lable release];
	
	viewCtrl.view.backgroundColor = bgColor[index];
//    if ([viewController.view.backgroundColor isEqual:[UIColor blueColor]]) {
//        viewCtrl.view.backgroundColor = [UIColor blackColor];
//    } else {
//        viewCtrl.view.backgroundColor = [UIColor blueColor];
//    }
    
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
