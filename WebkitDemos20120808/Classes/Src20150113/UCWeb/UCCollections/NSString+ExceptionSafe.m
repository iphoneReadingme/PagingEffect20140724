/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSString+ExceptionSafe.m
 *
 * Description	: 异常安全的NSString Category; 如果不处理异常请使用这里的相关函数。只在发布版本有效，其他版本与调用原函数行为一致
 *
 * Author		: liuchun3@ucweb.com
 *
 * History		: Creation, 14/11/26, liuchun3@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "NSString+ExceptionSafe.h"
#import "UCFNDCollection.h"

NSString *const UCCrashErrorDomain = @"UCCrashErrorDomain";

@implementation NSString (safe)


- (unichar)safe_characterAtIndex:(NSUInteger)index error:(NSError **)error;
{
#if IS_DISABLE_EXCEPTION_SAFE
    *error = nil;
    return [self characterAtIndex:index];
#else
    *error = nil;
    NSUInteger length = [self length];
    if (index >= length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString characterAtIndex:]: Index %u out of bounds; string length %u",
                                                                   index, length]];
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_OutOfRange userInfo:nil];
    }
    else
    {
        return [self characterAtIndex:index];
    }
    
    return 0;
#endif
}

- (void)safe_getCharacters:(unichar *)buffer range:(NSRange)aRange error:(NSError **)error
{
#if IS_DISABLE_EXCEPTION_SAFE
    *error = nil;
    [self getCharacters:buffer range:aRange];
#else
    *error = nil;
    NSUInteger length = [self length];
    if (buffer == NULL)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString getCharacters:range:]: NULL buffer"];
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_InvalidArgument userInfo:nil];
    }
    else if (aRange.location > length || aRange.location + aRange.length > length)
    {
        // 这里需求做两个判断 aRange.location > length || aRange.location + aRange.length > length
        // 如果 aRange.location 被设置为负数，强转后aRange.location + aRange.length可能溢出
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString getCharacters:range:]: Range {%u, %u} out of bounds; string length %u",
                                                                   aRange.location, aRange.length, length]];
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_OutOfRange userInfo:nil];
    }
    else
    {
        [self getCharacters:buffer range:aRange];
    }
#endif
}

- (NSString *)safe_substringFromIndex:(NSUInteger)from
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self substringFromIndex:from];
#else
    NSUInteger length = [self length];
    if (from > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString substringFromIndex:]: Index %u out of bounds; string length %u",
                                                                   from, length]];
    }
    else
    {
        return [self substringFromIndex:from];
    }
    
    return nil;
#endif
}

- (NSString *)safe_substringToIndex:(NSUInteger)to
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self substringToIndex:to];
#else
    if (to > [self length])
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString substringToIndex:]: Index %u out of bounds; string length %u",
                                                                   to, [self length]]];
    }
    else
    {
        return [self substringToIndex:to];
    }
    
    return nil;
#endif
   
}

- (NSString *)safe_substringWithRange:(NSRange)range
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self substringWithRange:range];
#else
    NSUInteger length = [self length];
    if (range.location > length || range.location + range.length > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString substringWithRange:]: Range {%u, %u} out of bounds; string length %u",range.location,range.length,length]];
    }
    else
    {
        return [self substringWithRange:range];
    }
    
    return nil;
#endif
   
}

- (BOOL)safe_containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self containsString:aString];
#else
    if(aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfString:options:range:locale:]: nil argument"];
    }
    else
    {
        return [self containsString:aString];
    }
    
    return NO;
#endif
    
}

- (NSRange)safe_rangeOfString:(NSString *)aString
{
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfString:aString];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfString:]: nil argument"];
    }
    else
    {
        return [self rangeOfString:aString];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif

}

- (NSRange)safe_rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfString:aString options:mask range:searchRange];
#else
    NSUInteger length = [self length];
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfString:options:range:locale:]: nil argument"];
    }
    else if (searchRange.location > length || searchRange.location + searchRange.length > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString rangeOfString:options:range:]: Range {%u, %u} out of bounds; string length %u",searchRange.location,searchRange.length,length]];
    }
    else
    {
        return [self rangeOfString:aString options:mask range:searchRange];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
   
}

- (NSRange)safe_rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange locale:(NSLocale *)locale NS_AVAILABLE(10_5, 2_0)
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfString:aString options:mask range:searchRange locale:locale];
#else
    NSUInteger length = [self length];
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfString:options:range:locale:]: nil argument"];
    }
    else if (searchRange.location > length || searchRange.location + searchRange.length > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString rangeOfString:options:range:locale:]: Range {%u, %u} out of bounds; string length %u",searchRange.location,searchRange.length,length]];
    }
    else
    {
        return [self rangeOfString:aString options:mask range:searchRange locale:locale];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
    
}

- (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)aSet
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfCharacterFromSet:aSet];
#else
    if (aSet == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfCharacterFromSet:options:range:]: nil argument"];
    }
    else
    {
        return [self rangeOfCharacterFromSet:aSet];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
   
}
- (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfCharacterFromSet:aSet options:mask];
#else
    if (aSet == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfCharacterFromSet:options:range:]: nil argument"];
    }
    else
    {
        return [self rangeOfCharacterFromSet:aSet options:mask];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
    
}
- (NSRange)safe_rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfCharacterFromSet:aSet options:mask range:searchRange];
#else
    NSUInteger length = [self length];
    if (aSet == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString rangeOfCharacterFromSet:options:range:]: nil argument"];
    }
    else if (searchRange.location > length || searchRange.location + searchRange.length > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString rangeOfCharacterFromSet:options:range:]: Range {%u, %u} out of bounds; string length %u",searchRange.location,searchRange.length,[self length]]];
    }
    else
    {
        return [self rangeOfCharacterFromSet:aSet options:mask range:searchRange];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
    
}

- (NSRange)safe_rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfComposedCharacterSequenceAtIndex:index];
#else
    if (index >= [self length])
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString rangeOfComposedCharacterSequenceAtIndex:]:The index %u is invalid",index]];
    }
    else
    {
        return [self rangeOfComposedCharacterSequenceAtIndex:index];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
    
}

- (NSRange)safe_rangeOfComposedCharacterSequencesForRange:(NSRange)range NS_AVAILABLE(10_5, 2_0)
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self rangeOfComposedCharacterSequencesForRange:range];
#else
    NSUInteger length = [self length];
    if(range.location > length || range.location + range.length > length)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString rangeOfComposedCharacterSequencesForRange:]:The range {%u, %u} is invalid; string length %u",range.location,range.length,[self length]]];
    }
    else
    {
        return [self rangeOfComposedCharacterSequencesForRange:range];
    }
    
    return NSMakeRange(NSNotFound, 0);
#endif
    
}

- (NSString *)safe_stringByAppendingString:(NSString *)aString
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self stringByAppendingString:aString];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString stringByAppendingString:]: nil argument"];
    }
    else
    {
        return [self stringByAppendingString:aString];
    }
    
    return nil;
#endif
    
}

- (NSString *)safe_stringByTrimmingCharactersInSet:(NSCharacterSet *)set
{
#if IS_DISABLE_EXCEPTION_SAFE
    return [self stringByTrimmingCharactersInSet:set];
#else
    if (set == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString stringByTrimmingCharactersInSet:]: nil argument"];
    }
    else
    {
        return [self stringByTrimmingCharactersInSet:set];
    }
    
    return nil;
#endif
}

- (BOOL)safe_hasPrefix:(NSString *)aString
{
#if IS_DISABLE_EXCEPTION_SAFE
    return [self hasPrefix:aString];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString hasPrefix:]: nil argument"];
    }
    else
    {
        return [self hasPrefix:aString];
    }
    
    return NO;
#endif
}

- (BOOL)safe_hasSuffix:(NSString *)aString
{
#if IS_DISABLE_EXCEPTION_SAFE
    return [self hasSuffix:aString];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString hasSuffix:]: nil argument"];
    }
    else
    {
        return [self hasSuffix:aString];
    }
    
    return NO;
#endif
}

- (NSComparisonResult)safe_compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange error:(NSError **)error
{
#if IS_DISABLE_EXCEPTION_SAFE
    *error = nil;
    return [self compare:string options:mask range:compareRange];
#else
    NSUInteger length = [self length];
    *error = nil;
    if (string == nil)
    {
        // Apple: This value must not be nil. If this value is nil, the behavior is undefined and may change in future versions of OS X.
        // 这里当做崩溃处理
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString compare:options:range:]: nil argument"];
        
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_InvalidArgument userInfo:nil];
    }
    else if (compareRange.location > length || compareRange.length + compareRange.location > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString compare:options:range:]: Range {%u, %u} out of bounds; string length %u",
                                                                  compareRange.location, compareRange.length, length]];
        
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_OutOfRange userInfo:nil];
    }
    else
    {
        return [self compare:string options:mask range:compareRange];
    }
    
    return NSOrderedSame;
#endif
}

- (NSComparisonResult)safe_compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange locale:(id)locale error:(NSError **)error
{
#if IS_DISABLE_EXCEPTION_SAFE
    *error = nil;
    return [self compare:string options:mask range:compareRange locale:locale];
#else
    NSUInteger length = [self length];
    *error = nil;
    if (string == nil)
    {
        // Apple: This value must not be nil. If this value is nil, the behavior is undefined and may change in future versions of OS X.
        // 这里当做崩溃处理
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFConstantString compare:options:range:locale:]: nil argument"];
        
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_InvalidArgument userInfo:nil];
    }
    else if (compareRange.location > length || compareRange.length + compareRange.location > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFConstantString compare:options:range:locale:]: Range {%u, %u} out of bounds; string length %u",
                                                                   compareRange.location, compareRange.length, length]];
        
        *error = [NSError errorWithDomain:UCCrashErrorDomain code:UCCrashCode_OutOfRange userInfo:nil];
    }
    else
    {
        return [self compare:string options:mask range:compareRange locale:locale];
    }
    
    return NSOrderedSame;
#endif
}

- (instancetype)safe_initWithCharacters:(const unichar *)characters length:(NSUInteger)length
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self initWithCharacters:characters length:length];
#else
    if (characters == NULL)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithCharacters:length:]: NULL argument"];
        
        [self autorelease];
    }
    else
    {
        return [self initWithCharacters:characters length:length];
    }
    
    return nil;
#endif
    
}

- (instancetype)safe_initWithUTF8String:(const char *)nullTerminatedCString
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self initWithUTF8String:nullTerminatedCString];
#else
    if (nullTerminatedCString == NULL)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithUTF8String:]: NULL cString"];
        
        [self autorelease];
    }
    else
    {
        return [self initWithUTF8String:nullTerminatedCString];
    }
    
    return nil;
#endif
    
}

- (instancetype)safe_initWithString:(NSString *)aString
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self initWithString:aString];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithString:]: nil argument"];
        
        [self autorelease];
    }
    else
    {
        return [self initWithString:aString];
    }
    
    return nil;
#endif
    
}

- (instancetype)safe_initWithBytes:(const void *)bytes length:(NSUInteger)len encoding:(NSStringEncoding)encoding
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self initWithBytes:bytes length:len encoding:encoding];
#else
    if (bytes == NULL)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithBytes:length:encoding:]: NULL argument"];
        
        [self autorelease];
    }
    else
    {
        return [self initWithBytes:bytes length:len encoding:encoding];
    }
    
    return nil;
#endif
    
}

+ (instancetype)safe_stringWithString:(NSString *)string
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [NSString stringWithString:string];
#else
    if (string == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithString:]: nil argument"];
        
    }
    else
    {
        return [NSString stringWithString:string];
    }
    
    return nil;
#endif
    
}

+ (instancetype)safe_stringWithCharacters:(const unichar *)characters length:(NSUInteger)length
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [NSString stringWithCharacters:characters length:length];
#else
    if (characters == NULL)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithCharacters:length:]: NULL argument"];
        
    }
    else
    {
        return [NSString stringWithCharacters:characters length:length];
    }
    
    return nil;
#endif
    
}

+ (instancetype)safe_stringWithUTF8String:(const char *)nullTerminatedCString
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [NSString stringWithUTF8String:nullTerminatedCString];
#else
    if (nullTerminatedCString == NULL)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSPlaceholderString initWithUTF8String:]: NULL cString"];
        
    }
    else
    {
        return [NSString stringWithUTF8String:nullTerminatedCString];
    }
    
    return nil;
#endif
   
}
@end
