//
//  AppDelegate.m
//  WebkitDemo
//
//  Created by yangfs on 14/12/17.
//  Copyright (c) 2014年 yangfs. All rights reserved.
//

#import "AppDelegate.h"
//#import "../SourceProjects/Projects/NBNovelBox/NBNovelBox/Include/NBNovelBox.h"
#import "NBNovelBox.h"


@interface AppDelegate ()

@property (nonatomic, retain) UIViewController *viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	[self initWindow];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ==对象初始化

- (void)initWindow
{
	UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window autorelease];
	self.window = window;
	// Override point for customization after application launch.
	
	self.viewController = [NBNovelBox createPageViewController];
	
	[self test];
	
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
}

- (void)test
{
	NBNovelBox* nbObj = [[NBNovelBox alloc] init];
	[nbObj autorelease];
	NSLog(@"%@", [nbObj getTestString]);
	nbObj = nil;
}

@end
