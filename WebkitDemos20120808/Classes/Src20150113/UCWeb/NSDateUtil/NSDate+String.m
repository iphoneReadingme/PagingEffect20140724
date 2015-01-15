/*
 ***************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: NSDate+String.m
 *
 * Description	: 提供NSDate与String互转的便捷方法作为基础类
 *
 * Creation		: 2015/01/05
 * Author		: wangqz@ucweb.com
 * History		:
 *			   Creation, 2015/01/05, Create the file
 ***************************************************************************
 **/

#import "NSDate+String.h"

@implementation NSDate (string)

//rfc2616#section-3.3.1
//HTTP applications have historically allowed three different formats
//for the representation of date/time stamps:
//
//Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
//Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
//Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
//
//The first format is preferred as an Internet standard and represents
//a fixed-length subset of that defined by RFC 1123 [8] (an update to
//                                                       RFC 822 [9]). The second format is in common use, but is based on the
//obsolete RFC 850 [12] date format and lacks a four-digit year.
//HTTP/1.1 clients and servers that parse the date value MUST accept
//all three formats (for compatibility with HTTP/1.0), though they MUST
//only generate the RFC 1123 format for representing HTTP-date values
//in header fields. See section 19.3 for further information.

- (NSString*)toRFC1123FormatString
{
    static NSLock* g_formatLock = NULL;
    static NSDateFormatter *RFC1123DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_formatLock = [[NSLock alloc] init];
        RFC1123DateFormatter = [[[self class] createDateFormatter:@"EEE, dd MMM yyyy HH:mm:ss z"] retain];
    });
    
    NSString* result = nil;
    [g_formatLock lock];
    result = [RFC1123DateFormatter stringFromDate:self];
    [g_formatLock unlock];
    
    return result;
}

+ (NSDateFormatter*) createDateFormatter:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [dateFormatter setLocale:locale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:format];
    [locale release];
    
    return [dateFormatter autorelease];
}

/*
 * Parse HTTP Date: http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 */
+ (NSDate *)dateFromString:(NSString *)dateString
{
    static NSDateFormatter *RFC1123DateFormatter;
    static NSDateFormatter *ANSICDateFormatter;
    static NSDateFormatter *RFC850DateFormatter;
    NSDate *date = nil;
    
    static NSLock* g_formatLock = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_formatLock = [[NSLock alloc] init];
    });
    
    //因为总在一个线程调用,不需要确保线程安全
    assert(g_formatLock);
    [g_formatLock lock];// NSDateFormatter isn't thread safe
    {
        // RFC 1123 date format - Sun, 06 Nov 1994 08:49:37 GMT
        if (!RFC1123DateFormatter) RFC1123DateFormatter = [[self createDateFormatter:@"EEE, dd MMM yyyy HH:mm:ss z"] retain];
        date = [RFC1123DateFormatter dateFromString:dateString];
        if (!date)
        {
            // ANSI C date format - Sun Nov  6 08:49:37 1994
            if (!ANSICDateFormatter) ANSICDateFormatter = [[self createDateFormatter:@"EEE MMM d HH:mm:ss yyyy"] retain];
            date = [ANSICDateFormatter dateFromString:dateString];
            if (!date)
            {
                // RFC 850 date format - Sunday, 06-Nov-94 08:49:37 GMT
                if (!RFC850DateFormatter) RFC850DateFormatter = [[self createDateFormatter:@"EEEE, dd-MMM-yy HH:mm:ss z"] retain];
                date = [RFC850DateFormatter dateFromString:dateString];
            }
        }
    }
    [g_formatLock unlock];
    
    return date;
}
@end
