
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEParameterDataProvider.h
 *
 * Description  : 参数信息数据解释
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import <Foundation/Foundation.h>


@class FEEmojiParameterInfo;

@interface FEParameterDataProvider : NSObject


- (FEEmojiParameterInfo*)getFestivalParameterInfo:(NSString*)festivalType with:(NSString*)shapeType;

@end

