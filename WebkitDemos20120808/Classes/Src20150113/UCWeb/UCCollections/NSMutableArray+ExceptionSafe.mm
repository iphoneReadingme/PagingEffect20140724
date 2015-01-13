/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSMutableArray+ExceptionSafe.mm
 *
 * Description	: NSMutableArray_ExceptionSafe
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/18/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "NSMutableArray+ExceptionSafe.h"
#import "UCFNDCollection.h"

@implementation NSMutableArray (safe)

- (void)safe_AddObject:(id)anObject
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    [self addObject:anObject];
    
#else
    
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSArray addObject:]: object cannot be nil"];
    }
    else
    {
        [self addObject:anObject];
    }
    
    
#endif
}

- (void)safe_InsertObject:(id)anObject atIndex:(NSUInteger)index
{
#if IS_DISABLE_EXCEPTION_SAFE

    [self insertObject:anObject atIndex:index];

#else
    
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSArray insertObject:atIndex:]: object cannot be nil"];
    }
    else if (index > [self count])
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSArrayI insertObject:atIndex:]: index %u beyond bounds [0 .. %u]",
                                                                   index, [self count]]];
    }
    else
    {
        [self insertObject:anObject atIndex:index];
    }
    
#endif
}

- (void)safe_RemoveObject:(id)anObject inRange:(NSRange)aRange
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self removeObject:anObject inRange:aRange];
    
#else
    
    NSUInteger count = [self count];
    if (aRange.location >= count || aRange.location + aRange.length > count)
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[NSArray safe_RemoveObject:inRange:]: range {%u, %u} extends beyond bounds [0 .. %u]",
                                                                   aRange.location, aRange.length, count]];
    }
    else
    {
        [self removeObject:anObject inRange:aRange];
    }
    
#endif
}

- (void)safe_RemoveObject:(id)anObject
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    [self removeObject:anObject];
    
#else
    
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSArray removeObject:]: object cannot be nil"];
    }
    else
    {
        [self removeObject:anObject];
    }
    
    
#endif
}

- (void)safe_RemoveObjectAtIndex:(NSUInteger)index
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self removeObjectAtIndex:index];
    
#else

    if (index >= [self count])
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSArrayI safe_RemoveObjectAtIndex:]: index %u beyond bounds [0 .. %u]",
                                                                   index, [self count]]];
    }
    else
    {
        [self removeObjectAtIndex:index];
    }
    
#endif
}

- (void)safe_RemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)aRange
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self removeObjectIdenticalTo:anObject inRange:aRange];
    
#else
    
    NSUInteger count = [self count];
    if (aRange.location >= count || aRange.location + aRange.length > count)
    {
        [UCFNDCollection dumpException:@"NSRangeException"
                                reason:[NSString stringWithFormat:@"*** -[NSArray safe_RemoveObjectIdenticalTo:inRange:]: range {%u, %u} extends beyond bounds [0 .. %u]",
                                                                   aRange.location, aRange.length, count]];
    }
    else
    {
        [self removeObjectIdenticalTo:anObject inRange:aRange];
    }
    
#endif
}

- (void)safe_ReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    [self replaceObjectAtIndex:index withObject:anObject];
    
#else
    
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSArray replaceObjectAtIndex:withObject:]: object cannot be nil"];
    }
    else if (index >= [self count])
    {
        [UCFNDCollection dumpException:@"NSRangeException" reason:[NSString stringWithFormat:@"*** -[__NSArrayI replaceObjectAtIndex:withObject:]: index %u beyond bounds [0 .. %u]",
                                                                   index, [self count]]];
    }
    else
    {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
    
#endif
}


@end
