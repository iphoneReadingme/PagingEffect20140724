
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiParameterInfo.h
 *
 * Description  : 节日表情参数信息
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/



#import <Foundation/Foundation.h>


@interface FEEmojiParameterInfo : NSObject

@property (nonatomic, copy) NSString*          emojiChar;             ///< 表情字符
@property (nonatomic, retain) NSMutableArray*    coordinateArray;       ///< 表情图标显示坐标和大小（CGRect String)

@property (nonatomic, assign) NSInteger          fontSize;              ///< 界面视图大小

@end

