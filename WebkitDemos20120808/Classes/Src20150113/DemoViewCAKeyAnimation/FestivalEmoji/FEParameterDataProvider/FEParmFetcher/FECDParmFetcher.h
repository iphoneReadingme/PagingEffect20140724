
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FECDParmFetcher.h
 *
 * Description  : CD参数管理器
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import <Foundation/Foundation.h>


@interface FECDParmFetcher : NSObject

///< 节日图形类型
+ (NSString*)getShapeType;

///< 表情字符
+ (NSString*)getEmojiChar;


@end

