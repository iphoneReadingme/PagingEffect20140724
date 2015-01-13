/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSMutableDictionary+ExceptionSafe.h
 *
 * Description	: 异常安全的NSMutableDictionary Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/19/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (safe)

///<异常安全的removeObjectForKey: ， if aKey is nil. 将不做任何操作
- (void)safe_RemoveObjectForKey:(id)aKey;

///<异常安全的setObject:forKey: ， if aKey is nil or if anObject is nil. 将不做任何操作. If you need to represent a nil value in the dictionary, use NSNull.
- (void)safe_SetObject:(id)anObject forKey:(id < NSCopying >)aKey;

@end
