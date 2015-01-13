/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: NSDictionary+ExceptionSafe.mm
 *
 * Description	: NSDictionary_ExceptionSafe
 *
 * Author		: zhangjq@ucweb.com
 *
 * History		: Creation, 8/19/14, zhangjq@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "NSDictionary+ExceptionSafe.h"
#import "UCFNDCollection.h"

@implementation NSDictionary (safe)

+ (instancetype)safe_DictionaryWithObject:(id)anObject forKey:(id<NSCopying>)aKey
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [NSDictionary dictionaryWithObject:anObject forKey:aKey];
    
#else
    
    NSDictionary *dictionary = nil;
    if (nil == anObject)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSDictionary safe_DictionaryWithObject:forkey:]: object cannot be nil"];
    }
    else if (nil == aKey)
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException" reason:@"*** -[NSDictionary safe_DictionaryWithObject:forkey:]: key cannot be nil"];
    }
    else
    {
        dictionary = [NSDictionary dictionaryWithObject:anObject forKey:aKey];
    }
    
    return dictionary;
    
#endif
}

+ (instancetype)safe_DictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self dictionaryWithObjects:objects forKeys:keys];
    
#else
    
    NSDictionary *dic = nil;
    if ([objects count] != [keys count])
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException"
                                reason:[NSString stringWithFormat:@"*** -[NSDictionary safe_DictionaryWithObjects:forKeys:]: objects count is %u keys count is %u",
                                        [objects count], [keys count]]];
    }
    else
    {
        dic = [self dictionaryWithObjects:objects forKeys:keys];
    }
    
    return dic;
    
#endif
}

- (instancetype)safe_InitWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
#if IS_DISABLE_EXCEPTION_SAFE
    
    return [self initWithObjects:objects forKeys:keys];
    
#else
    
    NSDictionary *dic = nil;
    if ([objects count] != [keys count])
    {
        [UCFNDCollection dumpException:@"NSInvalidArgumentException"
                                reason:[NSString stringWithFormat:@"*** -[NSDictionary safe_InitWithObjects:forKeys:]: objects count is %u keys count is %u",
                                        [objects count], [keys count]]];
         [self autorelease];
     }
     else
     {
         dic = [self initWithObjects:objects forKeys:keys];
     }
     
     return dic;
         
#endif
}

@end
