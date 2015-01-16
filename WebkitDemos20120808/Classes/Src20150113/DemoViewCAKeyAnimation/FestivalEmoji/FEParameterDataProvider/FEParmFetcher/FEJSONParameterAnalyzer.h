
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEJSONParameterAnalyzer.h
 *
 * Description  : JSON数据参数解释器
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import <Foundation/Foundation.h>


@interface FEJSONParameterAnalyzer : NSObject

+ (NSDictionary*)readJSONDataFromFile;

+ (NSMutableArray*)parseShapeJSONData:(NSDictionary*)paramDict;
+ (NSMutableArray*)parseFestivalJSONData:(NSDictionary*)paramDict with:(NSDateFormatter*)dateFormator;


@end

