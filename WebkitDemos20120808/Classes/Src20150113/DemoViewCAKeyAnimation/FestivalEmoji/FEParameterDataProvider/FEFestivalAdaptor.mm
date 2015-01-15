
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


@interface FEFestivalAdaptor ()


@end

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


@end

