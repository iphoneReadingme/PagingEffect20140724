
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiViewController.mm
 *
 * Description  : 节日表情图标视图接口控制器
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/


#import "FEEmojiIconDataFactory.h"
#import "FEEmojiView.h"
#import "FEEmojiViewController.h"



@interface FEEmojiViewController ()


@property (nonatomic, retain) FEEmojiView *emojiView;

@end


@implementation FEEmojiViewController


- (id)initWithParentView:(UIView*)parentView WithType:(FEServerCmdType)type;
{
	if (self = [super init])
	{
		[self addEmojiView:parentView WithType:type];
	}
	
	return self;
}

- (void)dealloc
{
	[self releaseEmojiView];
	
	[super dealloc];
}

- (void)releaseEmojiView
{
	if ([_emojiView superview])
	{
		[_emojiView removeFromSuperview];
	}
	[_emojiView release];
	_emojiView = nil;
}

- (void)addEmojiView:(UIView*)parentView WithType:(FEServerCmdType)type
{
	FEEmojiView* view = [FEEmojiIconDataFactory buildEmojiViewWithType:type withFrame:[parentView bounds]];
	[parentView addSubview:view];
	self.emojiView = view;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self onChangeFrame];
}

- (void)onChangeFrame
{
	CGRect bounds = [[_emojiView superview] bounds];
	[_emojiView setFrame:bounds];
	
	[_emojiView onChangeFrame];
}

- (void)didThemeChange
{
	[_emojiView didThemeChange];
}


@end

