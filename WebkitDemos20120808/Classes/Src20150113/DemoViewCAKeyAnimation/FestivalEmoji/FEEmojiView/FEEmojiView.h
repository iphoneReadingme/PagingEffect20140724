
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


@protocol FEEmojiViewDelegate <NSObject>

- (void)hiddenAnimationDidFinished;

@end

@interface FEEmojiView : UIView

@property (nonatomic, assign) id<FEEmojiViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withData:(FEEmojiParameterInfo*)parameterInfo;

- (void)onChangeFrame;

- (void)show3DAnimation;

@end

