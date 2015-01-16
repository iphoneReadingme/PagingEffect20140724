
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiView.mm
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


#import "NSMutableArray+ExceptionSafe.h"
#import "FEEmojiLabel.h"
#import "FEEmojiViewMacroDefine.h"



@interface FEEmojiLabel ()

@end


@implementation FEEmojiLabel

- (void)dealloc
{
	[super dealloc];
}

- (void)executeHiddenAnimation:(NSTimeInterval)duration
{
	[self hiddenView:duration];
}

/*
 大小缩放： 100% -> 80% -> 150%    (正常->缩小->放大)
 透明度:   1.0f -> 1.0f -> 0.0f  (正常->正常->全透明)
 */
- (void)hiddenView:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration * 5.0f/12 animations:^{
		self.transform = CGAffineTransformMakeScale(0.8, 0.8);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:duration * 8.0f/12 animations:^{
			self.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
			self.alpha = 0.0f;
		} completion:^(BOOL finished) {
			self.hidden = YES;
		}];
	}];
}

@end
