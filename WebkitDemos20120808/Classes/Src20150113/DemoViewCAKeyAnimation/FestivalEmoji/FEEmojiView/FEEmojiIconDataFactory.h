
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiIconDataFactory.h
 *
 * Description  : 节日表情数据对象构造工厂
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/


#import "FEEmojiViewMacroDefine.h"
#import "FEEmojiView.h"


@class FEParameterDataProvider;

@interface FEEmojiIconDataFactory : NSObject

+ (FEEmojiView*)buildEmojiViewWithType:(FEServerCmdType)type  withFrame:(CGRect)rect withData:(FEParameterDataProvider*)dataProvider;

@end



