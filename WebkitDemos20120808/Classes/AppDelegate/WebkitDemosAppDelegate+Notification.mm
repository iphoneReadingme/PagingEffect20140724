

#import "UIUserNotificationSettings+Extension.h"
#import "WebkitDemosAppDelegate+Notification.h"


#ifndef UIUserNotificationTypeAll
#define UIUserNotificationTypeAll (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound)
#endif
#ifndef UIRemoteNotificationTypeAll
#define UIRemoteNotificationTypeAll (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)
#endif



@implementation WebkitDemosAppDelegate (Notification)


- (void)registerNotification:(UIApplication *)application
{
	//注册push服务
#ifdef __IPHONE_8_0
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
	{
		[application cancelAllLocalNotifications];
		UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAll categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		
	}
	else
#endif
	{
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAll];
	}
}

- (void)setupNotificationSettings:(UIApplication *)application
{
	UIUserNotificationAction *openAction = [UIUserNotificationAction foregroundActionWithIdentifier:@"open_action" title:@"Open with alert 😉"];
	UIUserNotificationAction *deleteAction = [UIUserNotificationAction backgroundDestructiveActionWithIdentifier:@"delete_action" title:@"Delete 😱" authenticationRequired:YES];
	UIUserNotificationAction *okAction = [UIUserNotificationAction backgroundActionWithIdentifier:@"ok_action" title:@"Ok 👍" authenticationRequired:NO];
	
	UIUserNotificationCategory *userNotificationCategory = [UIUserNotificationCategory categoryWithIdentifier:@"default_category"
																							   defaultActions:@[openAction, deleteAction, okAction]
																							   minimalActions:@[okAction, deleteAction]];
	
	UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAll
																						categoriesArray:@[userNotificationCategory]];
	
	[application registerUserNotificationSettings:userNotificationSettings];
}

#pragma mark - ==[1] Local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSLog(@"[11 Receive]didReceiveLocalNotification: %@", notification);
	[self clearNotifications];
}

#pragma mark - User Notifications for iOS8
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
	NSLog(@"[11 Register]didRegisterUserNotificationSettings: %@", notificationSettings);
	//[application registerForRemoteNotifications];
	[self setupNotificationSettingsEx:application];
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
	[self clearNotifications];
}

- (void)clearNotifications
{
	//清除通知中心的消息时通过设置角标为0的方法实现的，这里表示很难理解苹果的做法。并且目前方案是推送的消息不带角标的
	//即角标默认为0，但此时如果直接设置角标为0，消息无法清除，必须先设非0值，再设为0才能实现，我认为这是个Bug。
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
	NSLog(@"handleActionWithIdentifier: %@", identifier);
	
	if ([identifier isEqualToString:@"open_action"])
	{
		[[[UIAlertView alloc] initWithTitle:@"Opened!" message:@"This action only open the app... 😀" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	}
	
	if (completionHandler)
	{
		completionHandler();
	}
	[self clearNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
	[self clearNotifications];
}
#endif


///< 本地通知,注册到用户设置中
- (void)setupNotificationSettingsEx:(UIApplication *)application
{
	///<检查通知的类型是否已经被设定了，没有设定执行注册。
	if ([application currentUserNotificationSettings].types != UIUserNotificationTypeNone)
	{
		///< 避免了重复注册通知类型
		return;
	}
	
	///< 1. 一个简单的通知，点击后消失，不会做任何事情。
	///< 2. 点击通知动作后添加一个物品。
	///< 3. 点击通知动作后删除整个清单。
	UIMutableUserNotificationAction *justInformAction = nil;
	UIMutableUserNotificationAction *modifyListAction = nil;
	UIMutableUserNotificationAction *trashAction = nil;
	
	UIMutableUserNotificationAction *instance = nil;
	
	///< 动作的标示符是“提示而已（justInform）”。动作只会在backgroun运行，不会产生任何安全问题，所以我们设置了destructive和authenticationRequired为false。
	instance = [UIMutableUserNotificationAction new];
	instance.identifier = @"justInform";
	instance.title = @"OK, got it";
	instance.activationMode = UIUserNotificationActivationModeBackground; ///< 决定App在通知动作点击后是应该被启动还是不被启动。
	instance.authenticationRequired = NO;
	instance.destructive = NO; ///< 操作有破坏性,当设置为true时，通知中相应地按钮的背景色会变成红色。这只会在banner通知中出现。通常，当动作代表着删除、移除或者其他关键的动作是都会被标记为destructive以获得用户的注意。
	justInformAction = instance;
	
	///< 为了让用户能够标记物品清单，我们需要App启动。而且我们不希望用户的物品清单被未验明身份的人乱动，我们设置了authenticationRequired为true。
	instance = [UIMutableUserNotificationAction new];
	instance.identifier = @"editlist";
	instance.title = @"Edit list";
	instance.activationMode = UIUserNotificationActivationModeForeground;
	instance.authenticationRequired = YES;
	instance.destructive = NO;
	modifyListAction = instance;
	
	///< 我们允许用户在App没有启动的情况下删除整个物品清单。这个动作可能导致用户丢失所有数据，所以我们设置了destructive和authenticationRequired为true。
	instance = [UIMutableUserNotificationAction new];
	instance.identifier = @"trashAction";
	instance.title = @"Delete list";
	instance.activationMode = UIUserNotificationActivationModeBackground;
	instance.authenticationRequired = YES;
	instance.destructive = YES;
	trashAction = instance;
	
	//NSArray* defaultActions = @[openAction, deleteAction, okAction];
	NSArray* defaultActions = @[justInformAction, modifyListAction, trashAction];
	//NSArray* minimalActions = @[okAction, deleteAction];
	///< 包含所有动作的数组
	NSArray* minimalActions = @[trashAction, modifyListAction];
	
	///< 创建一个新的类目（category）
	UIMutableUserNotificationCategory *instanceCategory = [UIMutableUserNotificationCategory new];
	
	instanceCategory.identifier = @"default_category"; ///< 标示符（identifier）
	[instanceCategory setActions:defaultActions forContext:UIUserNotificationActionContextDefault];
	[instanceCategory setActions:minimalActions forContext:UIUserNotificationActionContextMinimal];
	///< 第一个参数指明了需要包含进来的动作。是一个包含所有动作的数组，他们在数组中的顺序也代表着他们将会在一个通知中调用的先后顺序。
	///< 第二个参数非常重要。context形参是一个枚举类型，描述了通知alert显示时的上下文，有两个值：
	///< 1. UIUserNotificationActionContextDefault：在屏幕的中央展示一个完整的alert。(未锁屏时)
	///< 2. UIUserNotificationActionContextMinimal：展示一个banner alert。
	///< 在默认上下文（default context）中，类目最多接受4个动作，会以预先定义好的顺序依次在屏幕中央显示。在minimal上下文中，最多可以在banner alert中设置2个动作。注意在第二个情况中，你必须选择一个较为重要的动作以显示到banner通知里。
	
	///< 注册通知设置
	UIUserNotificationSettings *userNotificationSettings = nil;
	//userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAll categoriesArray:@[instanceCategory]];
	userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAll categories:[NSSet setWithArray:@[instanceCategory]]];
	[application registerUserNotificationSettings:userNotificationSettings];
}

///< 安排本地通知
- (void)scheduleLocalNotification
{
	UILocalNotification *localNotification = [UILocalNotification new];
	
	localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
	localNotification.alertBody = @"You've closed me?!? 😡";
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
	{
		localNotification.alertAction = @"trashAction";
		localNotification.category = @"default_category";
	}
	
	NSDictionary *userInfo = @{@"Type" : @"DemoNotification", @"displayName" : @"消息通知测试"};
	localNotification.userInfo = userInfo;
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	[UIApplication sharedApplication].applicationIconBadgeNumber += 1;
	
	[localNotification release];
}


@end

