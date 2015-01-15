/*
 ***************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: NSDate+String.h
 *
 * Description	: 提供NSDate与String互转的便捷方法作为基础类
 *
 * Creation		: 2015/01/05
 * Author		: wangqz@ucweb.com
 * History		:
 *			   Creation, 2015/01/05, Create the file
 ***************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface NSDate (string)

- (NSString*)toRFC1123FormatString;

+ (NSDate *)dateFromString:(NSString *)dateString;
@end
