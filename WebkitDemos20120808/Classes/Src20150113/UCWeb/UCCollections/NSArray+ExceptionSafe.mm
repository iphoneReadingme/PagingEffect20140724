/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSArray+ExceptionSafe.mm
 *
 * Description	: 异常安全的NSArray Category; 如果不处理异常请使用这里的相关函数。
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/15/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "NSArray+ExceptionSafe.h"
#import "UCFNDCollection.h"

@implementation NSArray (safe)

- (id)safe_ObjectAtIndex:(NSUInteger)index
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self objectAtIndex:index];
    
#else
    NSString *obj = nil;
    if (index >= [self count])
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSArrayI objectAtIndex:]: index %u beyond bounds [0 .. %u]",
                                                                   index, [self count]]];
    }
    else
    {
        obj = [self objectAtIndex:index];
    }
    
    return obj;
    
#endif
}

- (NSArray *)safe_ArrayByAddingObject:(id)anObject
{
#if IS_DISABLE_EXCEPTION_SAFE

    return [self arrayByAddingObject:anObject];

#else
    
    NSArray *arr = nil;
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSArray arrayByAddingObject:]: object cannot be nil"];
    }
    else
    {
        arr = [self arrayByAddingObject:anObject];
    }
    
    return arr;
    
#endif
    
}

- (NSUInteger)safe_IndexOfObject:(id)anObject inRange:(NSRange)range
{
#if IS_DISABLE_EXCEPTION_SAFE

    return [self indexOfObject:anObject inRange:range];
    
#else
    
    NSUInteger index = NSNotFound;
    NSUInteger count = [self count];
    if (range.location >= count || range.location + range.length > count)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[NSArray indexOfObject:inRange:]: range {%u, %u} extends beyond bounds [0 .. %u]",
                                                                   range.location, range.length, count]];

    }
    else
    {
        index = [self indexOfObject:anObject inRange:range];
    }
    
    return index;
    
#endif
    
}



- (NSArray *)safe_ObjectsAtIndexes:(NSIndexSet *)indexes
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self objectsAtIndexes:indexes];
    
#else
    
    NSUInteger count = [self count];
    NSIndexSet *outOfRangeIndexes = [indexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
         if (idx >= count)
         {
             *stop = YES;
             return YES;
         }
         else
         {
             return NO;
         }
    }];
    
    NSArray *objs = nil;
    if ([outOfRangeIndexes count] > 0)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSArrayI objectsAtIndexes:]: index %u beyond bounds [0 .. %u]",
                                                                   [outOfRangeIndexes firstIndex], [self count]]];
    }
    else
    {
        objs = [self objectsAtIndexes:indexes];
    }
    
    return objs;
    
#endif
}

- (NSArray *)safe_SubarrayWithRange:(NSRange)range
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self subarrayWithRange:range];
    
#else
    
    NSArray *arr = nil;
    NSUInteger count = [self count];
    if (range.location >= count || range.location + range.length > count)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[NSArray indexOfObject:inRange:]: range {%u, %u} extends beyond bounds [0 .. %u]",
                                                                   range.location, range.length, count]];
        
    }
    else
    {
        arr = [self subarrayWithRange:range];
    }
    
    return arr;
    
#endif
}

@end
