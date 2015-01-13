/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSMutableString+ExceptionSafe.h
 *
 * Description	: 异常安全的NSMutableString Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: liuchun3@ucweb.com
 *
 * History		: Creation, 14/11/27, liuchun3@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>
#import "NSString+ExceptionSafe.h"

@interface NSMutableString (safe)

// Do nothing if 'aString' is nil.
- (void)safe_setString:(NSString *)aString;

// Do nothing if 'aString' is nil or 'loc' is out of bounds.
- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)loc;

// Do nothing if 'range' is out of bounds.
- (void)safe_deleteCharactersInRange:(NSRange)range;

// Return 0 if 'target' or 'replacement' is nil, or 'searchRange' is out of bounds.
- (NSUInteger)safe_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange;

@end
