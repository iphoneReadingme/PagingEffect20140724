/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: UCFNDCollection.mm
 *
 * Description	: 定义异常安全容器的基础信息
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/18/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "UCFNDCollection.h"

//NSString* const kNetworkPredictorShutdown = @"NetworkPredictorShutdown";

NSString* const  kExceptionSafeCollectionNotification     = @"ExceptionSafeCollectionNotification";
NSString* const  kUserInfoExceptionName                   = @"name";
NSString* const  kUserInfoExceptionReason                 = @"reason";
NSString* const  kUserInfoExceptionCallStack              = @"callStack";

@implementation UCFNDCollection

+ (void)dumpException:(NSString *)name reason:(NSString *)reason
{
    
    NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] init] autorelease];
    if (nil != name)
    {
        [userInfo setObject:name forKey:kUserInfoExceptionName];
    }
    if (nil != reason)
    {
        [userInfo setObject:reason forKey:kUserInfoExceptionReason];
    }
    
    /* Save the call stack, if available */
    NSArray *callStacks = [NSThread callStackSymbols];
    if (nil != callStacks)
    {
        [userInfo setObject:callStacks forKey:kUserInfoExceptionCallStack];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kExceptionSafeCollectionNotification object:nil userInfo:userInfo];
}


@end
