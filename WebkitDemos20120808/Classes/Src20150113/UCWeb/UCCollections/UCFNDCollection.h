/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: UCFNDCollection.h
 *
 * Description	: 定义异常安全容器的基础信息
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/18/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

extern NSString* const kExceptionSafeCollectionNotification;
extern NSString* const kUserInfoExceptionName;
extern NSString* const kUserInfoExceptionReason;
extern NSString* const kUserInfoExceptionCallStack;

#define IS_DISABLE_EXCEPTION_SAFE                (defined(UC_ENABLE_NET_PERFORMANCE) || defined(UC_MONKEY_TEST) || defined(UC_COMMON_AUTOMATED_TEST) || \
defined(UC_ENABLE_PERFORMANCE_TEST) || defined(UC_ENABLE_ASSIST_SCRIPT_TESTING) || (defined(DEBUG)))

@interface UCFNDCollection : NSObject

///<dump异常文件到crash目录，与UC崩溃日志一起上传
+ (void)dumpException:(NSString *)name reason:(NSString *)reason;

@end
