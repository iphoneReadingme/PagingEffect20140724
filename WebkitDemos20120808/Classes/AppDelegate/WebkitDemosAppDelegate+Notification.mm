

#import "UIUserNotificationSettings+Extension.h"
#import "WebkitDemosAppDelegate+Notification.h"


#ifndef UIUserNotificationTypeAll
#define UIUserNotificationTypeAll (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound)
#endif
#ifndef UIRemoteNotificationTypeAll
#define UIRemoteNotificationTypeAll (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)
#endif



@implementation WebkitDemosAppDelegate (Notification)


- (BOOL)isEnableMessageNotification
{
	//如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
	///< 检查通知的类型是否已经被设定了,这一个判定，可使系统弹出消息推送提示框，让用户设置
	return ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone);
}

- (void)registerNotification:(UIApplication *)application
{
	//注册push服务
#ifdef __IPHONE_8_0
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
	{
		if ([self isEnableMessageNotification])
		{
			[application cancelAllLocalNotifications];
			[self setupNotificationSettingsEx:application];
		}
		else
		{
			UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIRemoteNotificationTypeAll categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
		}
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
/*
 当你安排了一个通知之后，无论你的App是否在运行，这个通知都将被推送。通常情况下，开发者设置通知如何在App没有运行或者被挂起的时候被推 送，
 所有的代码实现也聚焦在这两个方面。但是，我们也应该处理当App在运行时通知如何被处理。
*/
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	NSLog(@"[11 Receive]didReceiveLocalNotification: %@", notification);
	[self clearNotifications];
}

#pragma mark - User Notifications for iOS8
#pragma mark 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
///< 通过上述的方法，你可以得到所有UIUserNotificationSettings支持的类型。当你需要检查你的App所支持的通知和动作的类型时，这个方法非常有用。
///< 别忘了，用户可以通过用户设置来改变通知类型，所以我们不能保证，初始的通知类型一直都有效
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
	///< 设备令牌（device token）
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
///< 当用户点击了一个通知动作按钮后将会调用的代理方法。
/*
 注意到，我们在方法的结束调用了 completionHandler()方法，根据规定我们必须调用它，这样系统才能知道我们已经处理完了通知动作。
 在处理本地通知时，这个代理方法非常 重要，在这里你通过用户的点击执行相应地代码。
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
	NSLog(@"handleActionWithIdentifier: %@", identifier);
	/*
	 1. 简单地让通知消失（标示符：justInform）。
	 2. 添加一个新的物品（标示符：editList）。
	 3. 删除整个物品清单（标示符：trashAction）。
	 */
	if ([identifier isEqualToString:@"open_action"])
	{
		[[[UIAlertView alloc] initWithTitle:@"Opened!" message:@"This action only open the app... 😀" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
	}
	else if ([identifier isEqualToString:@"justInform"])
	{
	}
	else if ([identifier isEqualToString:@"editList"])
	{
	}
	else if ([identifier isEqualToString:@"trashAction"])
	{
		
	}
	
	if (completionHandler)
	{
		completionHandler();
	}
	[self clearNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
	if ([identifier isEqualToString:@"justInform"])
	{
	}
	else if ([identifier isEqualToString:@"editList"])
	{
	}
	else if ([identifier isEqualToString:@"trashAction"])
	{
		
	}
	
	
	if (completionHandler)
	{
		completionHandler();
	}
	
	[self clearNotifications];
}
#endif

///< 本地通知,注册到用户设置中
- (void)setupNotificationSettingsEx:(UIApplication *)application
{
#ifdef __IPHONE_8_0
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
	
#endif
}


///< 安排本地通知
- (void)scheduleLocalNotification
{
	if (![self isEnableMessageNotification])
	{
		return;
	}
	
	/*
	 创建UILocalNotification。
	 设置处理通知的时间fireDate。
	 配置通知的内容：通知主体、通知声音、图标数字等。
	 配置通知传递的自定义数据参数userInfo（这一步可选）。
	 调用通知，可以使用schedule LocalNotification:按计划调度一个通知，
	 也可以使用presentLocalNotificationNow立即调用通知。
	 */
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

