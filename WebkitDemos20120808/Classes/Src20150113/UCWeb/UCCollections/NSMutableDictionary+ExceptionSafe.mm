/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSMutableDictionary+ExceptionSafe.mm
 *
 * Description	: 异常安全的NSMutableDictionary Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/19/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "NSMutableDictionary+ExceptionSafe.h"
#import "UCFNDCollection.h"

@implementation NSMutableDictionary (safe)

- (void)safe_RemoveObjectForKey:(id)aKey
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self removeObjectForKey:aKey];
    
#else
    
    if (nil == aKey)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSMutableDictionary safe_RemoveObjectForKey:]: key cannot be nil"];
    }
    else
    {
        [self removeObjectForKey:aKey];
    }
    
#endif
}

- (void)safe_SetObject:(id)anObject forKey:(id < NSCopying >)aKey
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    [self setObject:anObject forKey:aKey];
    
#else
    
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSMutableDictionary safe_SetObject:forkey:]: object cannot be nil"];
    }
    else if (nil == aKey)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSMutableDictionary safe_SetObject:forkey:]: key cannot be nil"];
    }
    else
    {
        [self setObject:anObject forKey:aKey];
    }
    
#endif

}

@end
