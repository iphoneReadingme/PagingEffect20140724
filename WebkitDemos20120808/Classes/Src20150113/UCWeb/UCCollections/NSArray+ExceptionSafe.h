/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSArray+ExceptionSafe.h
 *
 * Description	: 异常安全的NSArray Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/15/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface NSArray (safe)

///<异常安全的objectAtIndex ，如果不在边界内返回nil
- (id)safe_ObjectAtIndex:(NSUInteger)index;

///<异常安全的arrayByAddingObject, 如果anObject为nil 返回nil
- (NSArray *)safe_ArrayByAddingObject:(id)anObject;

///<异常安全的indexOfObject:inRange:, 如果range 不在数组内 返回 NSNotFound.
- (NSUInteger)safe_IndexOfObject:(id)anObject inRange:(NSRange)range;


///<异常安全的objectsAtIndexes: ，如果任何一个index不在边界内返回nil
- (NSArray *)safe_ObjectsAtIndexes:(NSIndexSet *)indexes;

///<异常安全的subarrayWithRange: range 不在数组内 返回 nil.
- (NSArray *)safe_SubarrayWithRange:(NSRange)range;

@end
