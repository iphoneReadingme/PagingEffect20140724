//
//  PageAppViewController.m
//  PageTest2
//
//  Created by apple on 13-9-13.
//  Copyright (c) 2013年 kongyu. All rights reserved.
//

#import "PageAppViewController.h"

@interface PageAppViewController ()

@end

@implementation PageAppViewController
@synthesize pageContent,pageController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createContentPages];
    
    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:(UIPageViewControllerTransitionStylePageCurl) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:options];
    pageController.dataSource = self;
    [pageController.view setFrame:self.view.bounds];
    ContentViewController * initialViewController = [self viewCintrollerAtIndex:0];
    ContentViewController * endViewController = [self viewCintrollerAtIndex:1];

    NSArray * viewControllers = [NSArray arrayWithObjects:initialViewController,endViewController,nil];
    [pageController setViewControllers:viewControllers direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createContentPages{
    NSMutableArray * pageStrings = [[NSMutableArray alloc]init];
    for (int i = 1; i < 11; i ++) {
        NSString * contentString = [[NSString alloc]initWithFormat:
									@"<html><head></head><body><h1>Chapter %d</h1><p>This is the page %d of content displayed using UIPageViewController in iOS 5.</p></body></html>",i,i];
        [pageStrings addObject:contentString];
    }
    pageContent = [[NSArray alloc]initWithArray:pageStrings];
}
- (ContentViewController *)viewCintrollerAtIndex:(NSUInteger)index{
    if ([self.pageContent count] == 0 || (index >= [self.pageContent count])) {
        return nil;
    }
    ContentViewController * dataViewController = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:nil];
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    return dataViewController;
}
- (NSUInteger)indexOfViewController:(ContentViewController*)viewController{
    return  [self.pageContent indexOfObject:viewController.dataObject];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewCintrollerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index --;
    return [self viewCintrollerAtIndex:index];
}
@end
