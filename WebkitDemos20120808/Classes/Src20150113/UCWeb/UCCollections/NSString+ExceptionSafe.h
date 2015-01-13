/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSString+ExceptionSafe.h
 *
 * Description	: 异常安全的NSString Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: liuchun3@ucweb.com
 *
 * History		: Creation, 14/11/26, liuchun3@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

extern NSString *const UCCrashErrorDomain;

typedef NS_ENUM(NSInteger, UCCrashCode)
{
    UCCrashCode_OutOfRange = 0,         // 越界错误码
    UCCrashCode_InvalidArgument,        // 无效参数错误码
};

@interface NSString (safe)

#pragma mark - 子字符串相关

// 如果index越界，则*error不为nil；只有error为nil的情况下，返回值才准确
- (unichar)safe_characterAtIndex:(NSUInteger)index error:(NSError **)error;

// 如果aRange越界或者buffer为NULL，则*error不为nil；只有error为nil的情况下，返回值才准确
- (void)safe_getCharacters:(unichar *)buffer range:(NSRange)aRange error:(NSError **)error;

// 如果from越界，则返回nil
- (NSString *)safe_substringFromIndex:(NSUInteger)from;

// 如果to越界，则返回nil
- (NSString *)safe_substringToIndex:(NSUInteger)to;

// 如果range越界，则返回nil
- (NSString *)safe_substringWithRange:(NSRange)range;

// 如果aString为nil，则返回NO
- (BOOL)safe_containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);

// 如果aString为nil，则返回{NSNotFound,0}
- (NSRange)safe_rangeOfString:(NSString *)aString;

// 如果aString为nil或searchRange越界，则返回{NSNotFound,0}
- (NSRange)safe_rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange;

// 如果aString为nil或searchRange越界，则返回{NSNotFound,0}
- (NSRange)safe_rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange locale:(NSLocale *)locale NS_AVAILABLE(10_5, 2_0);

// 如果aSet为nil，则返回{NSNotFound,0}
- (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)aSet;

// 如果aSet为nil，则返回{NSNotFound,0}
- (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask;

// 如果aSet为nil或searchRange越界，则返回{NSNotFound,0}
- (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange;

// 如果index越界（无效），则返回{NSNotFound,0}
- (NSRange)safe_rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index;

// 如果range越界（无效），则返回{NSNotFound,0}
- (NSRange)safe_rangeOfComposedCharacterSequencesForRange:(NSRange)range NS_AVAILABLE(10_5, 2_0);

// 如果aSet为nil，则返回nil
- (NSString *)safe_stringByAppendingString:(NSString *)aString;

// 如果aSet为nil，则返回nil
- (NSString *)safe_stringByTrimmingCharactersInSet:(NSCharacterSet *)set;

// 如果aString为nil，则返回NO
- (BOOL)safe_hasPrefix:(NSString *)aString;

// 如果aString为nil，则返回NO
- (BOOL)safe_hasSuffix:(NSString *)aString;

// 如果compareRange越界，则error不为nil；只有error为nil的情况下，返回值才准确
- (NSComparisonResult)safe_compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange error:(NSError **)error;

// 如果compareRange越界，则error不为nil；只有error为nil的情况下，返回值才准确
- (NSComparisonResult)safe_compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange locale:(id)locale error:(NSError **)error;

#pragma mark - 常用初始化相关

// 如果characters为NULL，则返回nil
- (instancetype)safe_initWithCharacters:(const unichar *)characters length:(NSUInteger)length;

// 如果nullTerminatedCString为NULL，则返回nil
- (instancetype)safe_initWithUTF8String:(const char *)nullTerminatedCString;

// 如果aString为nil，则返回nil
- (instancetype)safe_initWithString:(NSString *)aString;

// 如果bytes为NULL，则返回nil
- (instancetype)safe_initWithBytes:(const void *)bytes length:(NSUInteger)len encoding:(NSStringEncoding)encoding;

// 如果string为nil，则返回nil
+ (instancetype)safe_stringWithString:(NSString *)string;

// 如果characters为NULL，则返回nil
+ (instancetype)safe_stringWithCharacters:(const unichar *)characters length:(NSUInteger)length;

// 如果nullTerminatedCString为NULL，则返回nil
+ (instancetype)safe_stringWithUTF8String:(const char *)nullTerminatedCString;


@end
