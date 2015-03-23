
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: WebkitDemosAppDelegate+Notification.h
 *
 * Description	: 消息通知相关
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-03-23.
 * History		: modify: 2015-03-23.
 *
 ******************************************************************************
 **/


#import <UIKit/UIKit.h>
#import "WebkitDemosAppDelegate.h"

@interface WebkitDemosAppDelegate (Notification)

- (void)registerNotification:(UIApplication *)application;

///< 安排本地通知
- (void)scheduleLocalNotification;

- (void)clearNotifications;

@end

