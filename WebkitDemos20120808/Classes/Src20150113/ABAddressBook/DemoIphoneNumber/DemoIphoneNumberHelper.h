
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: DemoIphoneNumberHelper.h
 *
 * Description	: 读写电话号码 demo
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-03-11.
 * History		: modify: 2015-03-11.
 *
 ******************************************************************************
 **/


@interface DemoIphoneNumberHelper : NSObject
{
}

+ (void)clearAllPersons;

+ (void)addPersons;

+ (NSMutableArray*)readPersons;


@end

