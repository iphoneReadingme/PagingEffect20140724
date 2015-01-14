
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
#import "NSMutableArray+ExceptionSafe.h"


#define kAnimationKeyShowView                 @"kAnimationKeyShowView"
#define kAnimationKeyShowView                 @"kAnimationKeyShowView"
#define kAnimationKeyHiddenView               @"kAnimationKeyHiddenView"


static BOOL g_bAnimation = NO;
static FEEmojiViewController* g_emojiViewController = nil;


@interface FEEmojiViewController ()


@property (nonatomic, retain) FEEmojiView *emojiView;

@end


@implementation FEEmojiViewController

+ (void)showFEEmojiView:(UIView*)parentView
{
	if (g_bAnimation)
	{
		return;
	}
	
	g_bAnimation = YES;
	
	static int nType = 0;
	
	if (g_emojiViewController == nil)
	{
		nType++;
		if (nType >= FEEITypeMaxCount)
		{
			nType = 1;
		}
		g_emojiViewController = [[FEEmojiViewController alloc] initWithParentView:parentView WithType:nType];
	}
	else
	{
		[g_emojiViewController hiddenAnimation];
	}
}

+ (void)hiddenFEEmojiView
{
	[g_emojiViewController performSelector:@selector(removeSelf) withObject:nil afterDelay:0.0f];
	g_emojiViewController = nil;
}

- (void)removeSelf
{
	[self autorelease];
}

- (id)initWithParentView:(UIView*)parentView WithType:(FEServerCmdType)type;
{
	if (self = [super init])
	{
		[self addEmojiView:parentView WithType:type];
		
		[self showAnimation];
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

#pragma mark - ==动画显示和隐藏
///< 显示
- (void)showAnimation
{
	[self performSelector:@selector(delayShowAnimation) withObject:nil afterDelay:0.05f];
}

- (void)delayShowAnimation
{
	self.emojiView.alpha = 1.0f;
	[self executeShow3DAnimation:self.emojiView];
}

///< 隐藏
- (void)hiddenAnimation
{
	[self performSelector:@selector(delayHiddenAnimation) withObject:nil afterDelay:0.05f];
}

- (void)delayHiddenAnimation
{
	[self executeHidden3DAnimation:self.emojiView];
}

- (void)animationDidStop:(CAAnimation *)animKeyName finished:(BOOL)flag;
{
	NSString* keyPath = nil;
	
	if ([animKeyName isKindOfClass:[CAAnimationGroup class]])
	{
		self.emojiView.alpha = 1.0f;
	}
	if ([animKeyName isKindOfClass:[CAKeyframeAnimation class]])
	{
		keyPath = [(CAKeyframeAnimation*)animKeyName keyPath];
	}
	
	g_bAnimation = NO;
}

#pragma mark - ==显示动画

- (void)executeShow3DAnimation:(UIView*)pView
{
	CAKeyframeAnimation *scaleAnimation = [self buildSizeScaleAnimation:0.8f];
	CAKeyframeAnimation *alphaAnimation = [self buildAlphaAnimateWith:0.0f maxAlpha:1.0f];
	//CABasicAnimation *opacityAnimation = [self buildAlphaAnimateWith2];
	
	// Create an animation group to combine the keyframe and basic animations
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction
	theGroup.delegate = self;
	theGroup.duration = scaleAnimation.duration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	theGroup.animations = @[alphaAnimation];
	theGroup.animations = @[scaleAnimation, alphaAnimation];
//	theGroup.animations = @[scaleAnimation, opacityAnimation];
	
	///< 插入动画
	// Add the animation group to the layer
	[pView.layer addAnimation:theGroup forKey:@"theGroupAnimation"];
}


#define kkeyTime   1

- (CAKeyframeAnimation *)buildAlphaAnimateWith:(float)startAlpha maxAlpha:(float)maxAlpha
{
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:2];
	NSValue* value = nil;
	
	///< 全透明 0
	value = [NSNumber numberWithFloat:startAlpha];
	[animationValues safe_AddObject:value];
	
	///< 不透明 1
	value = [NSNumber numberWithFloat:maxAlpha];
	[animationValues safe_AddObject:value];
	
	int nOffset = kkeyTime;
	// 创建关键帧动画
	CAKeyframeAnimation *alphaAnimate = [CAKeyframeAnimation animation];
	alphaAnimate.keyPath = @"opacity";
	alphaAnimate.duration = nOffset*30.0f/60;
	alphaAnimate.delegate = self;
	alphaAnimate.values = animationValues;
	
	alphaAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	alphaAnimate.keyTimes = @[@0.0, @(1.0f)];
	
	return alphaAnimate;
}

- (CABasicAnimation*)buildAlphaAnimateWith2
{
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	opacityAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	opacityAnimation.duration = 0.9f;
	opacityAnimation.beginTime = 0.0;
	
	return opacityAnimation;
}

- (CAKeyframeAnimation*)buildSizeScaleAnimation:(float)startScale
{
	NSValue* value = nil;
	CGFloat fScale = 1.0f;
	
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:5];
	
	CATransform3D defTransform = CATransform3DIdentity;
	CATransform3D tempTransform = defTransform;
	
	// 缩小到 0.8
	fScale = 0.8;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 放大 1.0f
	fScale = 1.0f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 放大 1.2f
	fScale = 1.2f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 缩小到 0.9
	fScale = 0.9f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 恢复到 1.0f
	fScale = 1.0f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	int nOffset = kkeyTime;
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"transform";
	animation.duration = nOffset*60.0f/60;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//	animation.timingFunctions = @[
////								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear],
//								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear],
//								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear],
//								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear],
//								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear],
//								  ];
	
	///< 这里是时间段的比率，第一个动画时间占总时间的比值
	animation.keyTimes = @[@0.0, @(20.0f/60), @(40.0f/60), @(50.0f/60), @(60.0f/60)];
	
	return animation;
}

#pragma mark - ==隐藏动画
- (void)executeHidden3DAnimation:(UIView*)pView
{
	BOOL animated = YES;
	if (animated)
	{
		[UIView animateWithDuration:0.3 animations:^{
			
//			[self lp_explode:pView];
			
			///< 隐藏视图动画
			[pView.layer addAnimation:[self buildSizeScaleInAnimation2] forKey:@"opacity"];
			
			} completion:^(BOOL finished) {
			[FEEmojiViewController hiddenFEEmojiView];
		}];
	}
	else
	{
		[FEEmojiViewController hiddenFEEmojiView];
	}
}

- (CAKeyframeAnimation*)buildSizeScaleInAnimation2
{
	NSValue* value = nil;
	CGFloat fScale = 1.0f;
	
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:5];
	
	CATransform3D defTransform = CATransform3DIdentity;
	CATransform3D tempTransform = defTransform;
	
	// 1.0f
	fScale = 1.0f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 放大 1.2f
	fScale = 1.2f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	// 缩小到 0.2
	fScale = 0.01f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	[animationValues addObject:value];
	
	int nOffset = 1;
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"transform";
	animation.duration = nOffset*60.0f/60;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	///< 这里是时间段的比率，第一个动画时间占总时间的比值
	animation.keyTimes = @[@0.0, @(0.15), @(1.0)];
	
	return animation;
}
/*
 keyTimes
 
 一个与 values 值数组对应的时间数组，定义了动画在什么时间应该到达什么值。时间以0开始，1结束。
 */
@end

