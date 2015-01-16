
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

///< bForce: YES,强制加载新数据，防止用户不退出uc,第二天继续使用时出现时间判断不正确问题
- (void)loadDataWith:(BOOL)bForce;

///< 通过搜索关键获取节日信息
- (FEEmojiParameterInfo*)getFestivalEmojiParameterInfoByKeyWord:(NSString*)keyWord;


@end

