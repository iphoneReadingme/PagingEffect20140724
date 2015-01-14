
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEFestivalParameterInfo.h
 *
 * Description  : 节日表情参数信息
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import <Foundation/Foundation.h>


@interface FEFestivalParameterInfo : NSObject

@property (nonatomic, copy) NSString*          festivalType;          ///< 节日类型
@property (nonatomic, copy) NSString*          shapeType;             ///< 类型
@property (nonatomic, copy) NSString*          emojiChar;             ///< 表情字符
@property (nonatomic, copy) NSString*          year;                  ///< 年
@property (nonatomic, copy) NSString*          month;                 ///< 月
@property (nonatomic, copy) NSString*          day;                   ///< 日

@property (nonatomic, assign) NSUInteger       days;                  ///< 持续日期（天数）
@property (nonatomic, assign) NSInteger        fontSize;              ///< 文字大小
@property (nonatomic, assign) BOOL             bRepeat;               ///< NO:只显示一次; YES:重复显示

@property (nonatomic, retain) NSMutableArray*    searchHotWords;        ///< 关键字列表

///< 对象是否有效
- (BOOL)isValid;

@end

