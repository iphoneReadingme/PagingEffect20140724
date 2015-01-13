/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSMutableArray+ExceptionSafe.h
 *
 * Description	: 异常安全的NSMutableArray Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/18/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface NSMutableArray (safe)

///<异常安全的addObject ，如果为nil不做任何操作
- (void)safe_AddObject:(id)anObject;

///<异常安全的insertObject:atIndex: ，如果为nil 或者 if index is greater than the number of elements in the array，不做任何操作
- (void)safe_InsertObject:(id)anObject atIndex:(NSUInteger)index;

///<异常安全的removeObject:inRange: ，如果aRange超出边界 将不做任何操作
- (void)safe_RemoveObject:(id)anObject inRange:(NSRange)aRange;

///<异常安全的removeObject: 如果为nil 将不做任何操作
- (void)safe_RemoveObject:(id)anObject;

///<异常安全的removeObjectAtIndex: ，如果index超出边界 将不做任何操作
- (void)safe_RemoveObjectAtIndex:(NSUInteger)index;

///<异常安全的removeObjectIdenticalTo:inRange: ，如果aRange超出边界 将不做任何操作
- (void)safe_RemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)aRange;

///<异常安全的replaceObjectAtIndex:withObject: ，如果index超出边界 或 anObject为nil 将不做任何操作,
- (void)safe_ReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
