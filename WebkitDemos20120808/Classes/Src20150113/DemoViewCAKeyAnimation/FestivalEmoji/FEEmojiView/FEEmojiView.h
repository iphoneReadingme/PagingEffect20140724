
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiView.h
 *
 * Description  : 节日表情图标视图
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/



#import <UIKit/UIKit.h>
#import "FEEmojiParameterInfo.h"
#import "FEEmojiViewMacroDefine.h"

@interface FEEmojiView : UIView

- (id)initWithFrame:(CGRect)frame withData:(FEEmojiParameterInfo*)parameterInfo;

- (void)onChangeFrame;

- (void)didThemeChange;

- (void)executeHidden3DAnimation:(NSTimeInterval)duration;

@end

