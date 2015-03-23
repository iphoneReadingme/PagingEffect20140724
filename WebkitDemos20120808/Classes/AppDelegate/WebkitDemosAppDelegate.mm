//
//  WebkitDemosAppDelegate.m
//  WebkitDemos
//
//  Created by yangfs on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UITestView.h"
#import "WebkitDemosAppDelegate.h"
#import "WebkitDemosAppDelegate+Notification.h"
#import "RootViewController.h"
#import "MainFrameView.h"


@implementation WebkitDemosAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)setViewColor:(UIView*)pView
{
	//pView.backgroundColor = [UIColor clearColor];
	pView.backgroundColor = [UIColor grayColor];
	
	// for test
	//pView.backgroundColor = [UIColor brownColor];
	//pView.layer.borderWidth = 20;
	//pView.layer.borderColor = [UIColor colorWithRed:0.0 green:1 blue:1.0 alpha:1.0].CGColor;
	//pView.alpha = 0.5;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
	[self setViewColor:self.window];
	[self.window addTitleView:@"Window View"];
	
	//[[MainFrameView shareInstance] showMainFrame:[[navigationController navigationBar] superview]];
	//[[MainFrameView shareInstance] showMainFrame:[[navigationController view] superview]];
	//[[MainFrameView shareInstance] showMainFrame:[navigationController view]];
	//[[MainFrameView shareInstance] showMainFrame:self.window];
	
	// 捕捉崩溃日志
	//[[CrashCaptureController shareInstance] registerCallBack];
//	UC_START_CAPTURE_CRASH_LOG  // 捕捉UCWEB崩溃日志
	
	[self registerNotification:application];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

