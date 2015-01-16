
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



#import <Foundation/Foundation.h>


@interface FEFestivalAdaptor : NSObject

+ (void)setLoadDataDate;
+ (NSDate*)getLastLoadFestivalDataDate;

+ (BOOL)isNeedReloadFestivalData;

#pragma mark - ==时间检测
///< 日期是否在节日有效期内
+ (BOOL)isValidFestivalDate:(NSDate*)festivalDate days:(NSUInteger)nDays;

@end



