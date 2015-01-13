/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSDictionary+ExceptionSafe.h
 *
 * Description	: 异常安全的NSDictionary Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/19/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface NSDictionary (safe)

///<异常安全的dictionaryWithObject:forKey: ，如果anObject or aKey为nil返回nil
+ (instancetype)safe_DictionaryWithObject:(id)anObject forKey:(id<NSCopying>)aKey;

///<异常安全的dictionaryWithObjects:forKeys: ，如果objects 与 keys元素不相等返回nil
+ (instancetype)safe_DictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;

///<异常安全的dictionaryWithObjects:forKeys: ，if the objects and keys arrays do not have the same number 返回nil
- (instancetype)safe_InitWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;


@end
