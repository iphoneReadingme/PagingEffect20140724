
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
//	NSLog(@"==[dealloc]==FEEmojiLabel==");
	[super dealloc];
}

- (void)executeHiddenAnimation:(NSTimeInterval)duration
{
	[self hiddenAnimation:self duration:duration];
}

#pragma mark - ==动画执行完成
- (void)animationDidStop:(CAAnimation *)animKeyName finished:(BOOL)flag;
{
	if ([animKeyName isKindOfClass:[CAAnimationGroup class]])
	{
		self.alpha = 0.0f;
	}
}

/*
 大小缩放： 100% -> 80% -> 150%    (正常->缩小->放大)
 透明度:   1.0f -> 1.0f -> 0.0f  (正常->正常->全透明)
 */

- (void)hiddenAnimation:(UIView*)pView duration:(NSTimeInterval)duration
{
	CAKeyframeAnimation *scaleAnimation = [self buildSizeScaleAnimation:duration];
	CAKeyframeAnimation *alphaAnimation = [self buildAlphaAnimateWith:duration];
	
	// Create an animation group to combine the keyframe and basic animations
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction
	theGroup.delegate = self;
	theGroup.duration = scaleAnimation.duration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = @[scaleAnimation, alphaAnimation];
	
	///< 插入动画
	// Add the animation group to the layer
	[pView.layer addAnimation:theGroup forKey:@"theGroupAnimation"];
}

- (CAKeyframeAnimation *)buildAlphaAnimateWith:(NSTimeInterval)duration
{
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:2];
	NSValue* value = nil;
	
	///< 不透明 1
	value = [NSNumber numberWithFloat:1.0f];
	[animationValues safe_AddObject:value];
	
	///< 不透明 1
	value = [NSNumber numberWithFloat:1.0f];
	[animationValues safe_AddObject:value];
	
	///< 全透明 0
	value = [NSNumber numberWithFloat:0.0f];
	[animationValues safe_AddObject:value];
	
	// 创建关键帧动画
	CAKeyframeAnimation *alphaAnimate = [CAKeyframeAnimation animation];
	alphaAnimate.keyPath = @"opacity";
	alphaAnimate.duration = duration;
	alphaAnimate.delegate = self;
	alphaAnimate.values = animationValues;
	
	alphaAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	alphaAnimate.keyTimes = @[@0.0, @(0.4f), @(1.0f)];
	
	return alphaAnimate;
}

- (CAKeyframeAnimation*)buildSizeScaleAnimation:(NSTimeInterval)duration
{
	NSValue* value = nil;
	CGFloat fScale = 1.0f;
	
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:5];
	
	CATransform3D defTransform = CATransform3DIdentity;
	CATransform3D tempTransform = defTransform;
	
	// 放大 1.0f
	fScale = 1.0f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 缩小到 0.8
	fScale = 0.8;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 放大 1.5f
	fScale = 1.5f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"transform";
	animation.duration = duration;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	///< 这里是时间段的比率，第一个动画时间占总时间的比值
	animation.keyTimes = @[@0.0, @(0.4f), @(1.0f)];
	
	return animation;
}

@end
