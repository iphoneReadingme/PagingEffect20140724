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

#import "NSMutableString+ExceptionSafe.h"
#import "UCFNDCollection.h"

@implementation NSMutableString (safe)

- (void)safe_setString:(NSString *)aString
{
#if IS_DISABLE_EXCEPTION_SAFE
    [self setString:aString];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFString setString:]: nil argument"];
    }
    else
    {
        [self setString:aString];
    }
#endif
}

- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    [self insertString:aString atIndex:loc];
#else
    if (aString == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFString insertString:atIndex:]: nil argument"];
    }
    else if (loc > [self length])
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:[NSString stringWithFormat:@"*** -[__NSCFString insertString:atIndex:]: Index %u out of bounds; string length %u",loc,[self length]]];
    }
    else
    {
        [self insertString:aString atIndex:loc];
    }
#endif
    
}

- (void)safe_deleteCharactersInRange:(NSRange)range
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    [self deleteCharactersInRange:range];
#else
    NSUInteger length = [self length];
    if (range.location > length || range.location + range.length > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFString deleteCharactersInRange:]: Range {%u,%u} out of bounds; string length %u",range.location,range.length,length]];
    }
    else
    {
        [self deleteCharactersInRange:range];
    }
#endif
    
}

- (NSUInteger)safe_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    
#if IS_DISABLE_EXCEPTION_SAFE
    return [self replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
#else
    NSUInteger length = [self length];
    if (target == nil || replacement == nil)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[__NSCFString replaceOccurrencesOfString:withString:options:range:]: nil argument"];
    }
    else if (searchRange.location > length || searchRange.location + searchRange.length > length)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSCFString deleteCharactersInRange:]: Range {%u,%u} out of bounds; string length %u",searchRange.location,searchRange.length,length]];
    }
    else
    {
        return [self replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    
    return 0;
#endif
    
}

@end
