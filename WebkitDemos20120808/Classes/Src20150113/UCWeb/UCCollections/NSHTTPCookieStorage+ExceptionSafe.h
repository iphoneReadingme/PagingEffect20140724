/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSHTTPCookieStorage+ExceptionSafe.h
 *
 * Description	: 异常安全的NSHTTPCookieStorage Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: liuchun3@ucweb.com
 *
 * History		: Creation, 14/11/27, liuchun3@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface NSHTTPCookieStorage (safe)

// Return nil if 'URL' is nil.
- (NSArray *)safe_cookiesForURL:(NSURL *)URL;

@end
