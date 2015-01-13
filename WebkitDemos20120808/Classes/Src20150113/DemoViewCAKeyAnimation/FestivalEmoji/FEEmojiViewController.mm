
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

+ (void)showFEEmojiView
{
	static FEEmojiViewController* controller = nil;
	static int nType = 0;
	
	if (controller == nil)
	{
		nType++;
		if (nType >= FEEITypeMaxCount)
		{
			nType = 1;
		}
		controller = [[FEEmojiViewController alloc] initWithParentView:self WithType:nType];
	}
	else
	{
		[controller release];
		controller = nil;
	}
}

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
	view.alpha = 0.0f;
	self.emojiView = view;
	
	[self startAnimation];
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

///< 显示动画
- (void)startAnimation
{
	[self performSelector:@selector(delayStartAnimation) withObject:nil afterDelay:0.05f];
}

- (void)delayStartAnimation
{
	self.emojiView.alpha = 1.0f;
	[self executeAnimation:self.emojiView];
}

- (void)executeAnimation:(UIView*)pView
{
	CGPoint pt = pView.center;
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:5];
	
	NSValue* value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	
	[animationValues addObject:value];
	
	pt.y -= 8/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	pt.y += 14/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	pt.y -= 10/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	pt.y += 4/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"position";
	animation.duration = 50.0f/60;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunctions = @[
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  ];
	
	animation.keyTimes = @[@0.0, @(10.0f/60), @(23.0f/60), @(33.0f/60), @(50.0f/60)];
	// 应用动画
	[pView.layer addAnimation:animation forKey:nil];
}

@end

