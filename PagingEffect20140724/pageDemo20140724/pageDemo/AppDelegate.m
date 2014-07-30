//
//  AppDelegate.m
//  pageDemo
//
//  Created by ren kai on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//

#import "AppDelegate.h"

#import "NBPageViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	
	// style: 0.卷曲; 1.平滑(ios6.0以上才支持)
	// orient: 0.左右卷曲/滑动; 1.上下卷曲/滑动
	UIPageViewControllerTransitionStyle style[2] = {UIPageViewControllerTransitionStylePageCurl, UIPageViewControllerTransitionStyleScroll};
	UIPageViewControllerNavigationOrientation orient[2] = {UIPageViewControllerNavigationOrientationHorizontal, UIPageViewControllerNavigationOrientationVertical};
	
    self.viewController = [[[NBPageViewController alloc] initWithTransitionStyle:style[0]
                                                          navigationOrientation:orient[0]
                                                                        options:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
