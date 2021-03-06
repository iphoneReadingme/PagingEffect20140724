//
//  WebkitDemosAppDelegate.m
//  WebkitDemos
//
//  Created by yangfs on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UITestView.h"
#import "WebkitDemosAppDelegate.h"
#import "RootViewController.h"
#import "MainFrameView.h"

//#import "CrashCaptureController.h"


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
	
	[self registerNotification];
	
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

- (void)registerNotification
{
	//注册push服务
#ifdef __IPHONE_8_0
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
	{
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge) categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
	}
	else
#endif
	{
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
	}
}

#pragma mark - ==[1] Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSLog(@"[11 Receive]didReceiveLocalNotification: %@", notification);
	//[application clearNotifications];
	
	//清除通知中心的消息时通过设置角标为0的方法实现的，这里表示很难理解苹果的做法。并且目前方案是推送的消息不带角标的
	//即角标默认为0，但此时如果直接设置角标为0，消息无法清除，必须先设非0值，再设为0才能实现，我认为这是个Bug。
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - User Notifications for iOS8
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
	NSLog(@"[11 Register]didRegisterUserNotificationSettings: %@", notificationSettings);
	[application registerForRemoteNotifications];
}
#endif

#pragma mark - Remote Notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	
	NSLog(@"[22 Receive]didReceiveRemoteNotification: %@", userInfo);
	
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	
	NSLog(@"[22 Register]didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
	
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	
	
	NSLog(@"[44 did fail]didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	
	
	NSLog(@"[33 Receive]didReceiveRemoteNotification: %@", userInfo);
}

#pragma mark - Background Fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	
	
	NSLog(@"performFetchWithCompletionHandler: %@", completionHandler);
}

@end

