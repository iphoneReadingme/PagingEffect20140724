
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEFestivalAdaptor.h.h
 *
 * Description  : 节日相关适配器接口
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import "NSDateUtility.h"
#import "FEFestivalAdaptor.h"


///< 最近一次加载节日数据的日期
#define kLastLoadFestivalDataDate            @"kLastLoadFestivalDataDate"


@implementation FEFestivalAdaptor


+ (void)setLoadDataDate
{
	NSDate* today = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:today forKey:kLastLoadFestivalDataDate];
}

+ (NSDate*)getLastLoadFestivalDataDate
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:kLastLoadFestivalDataDate];
}

+ (BOOL)isNeedReloadFestivalData
{
	BOOL bRet = YES;
	
	NSDate* date = [self getLastLoadFestivalDataDate];
	
	if (date != nil)
	{
		bRet = ![self isTodayWithDate:date];
	}
	
	return bRet;
}

+ (BOOL)isTodayWithDate:(NSDate*)dateObject
{
	return [dateObject isToday];
}

+ (BOOL)isValidFestivalDate:(NSDate*)festivalDate days:(NSUInteger)nDays
{
	BOOL bRet = NO;
	
	NSDate* date = [NSDate date];
	
	NSInteger nDayTemp = -1;
	if (festivalDate != nil)
	{
		nDayTemp = [date daysAfterDate:festivalDate];
	}
	
	if (0 <= nDayTemp)
	{
		///< 节日是今天或之前
		
		bRet = [date isEqualToDateIgnoringTime:festivalDate];
		
		if (!bRet)
		{
			///< 昨天是节日
			///< 相差不足一天或一天时, 如果是昨天，并且nDays>1
			bRet = (nDays > 1 && [festivalDate isYesterday]);
		}
		if (!bRet)
		{
			///< 节日在昨天之前
			bRet = (0 < nDayTemp && nDayTemp < nDays);
		}
	}
	
	return bRet;
}

@end

