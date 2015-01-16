
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


#import "FEEmojiLabel.h"
#import "FEEmojiView.h"
//#import "UCUIKit/UCUIKit.h"
#import "NSMutableArray+ExceptionSafe.h"



#define kkeyTimes                             1

#define kkeyShowEmojiViewTime                 0.5f*kkeyTimes
#define kkeyHiddenEmojiViewTime               0.5f*kkeyTimes

///< 0.5f 之后隐藏
#define kkeyBeforeHiddenWaitTime              0.5f


#define kAnimationKeyShowView                 @"kAnimationKeyShowView"
#define kAnimationKeyHiddenView               @"kAnimationKeyHiddenView"


@interface FEEmojiView ()

@property (nonatomic, retain) FEEmojiParameterInfo* parameterInfo;   ///< 表情图标参数信息
@property (nonatomic, retain) UIView *emojiContentView;

@end


@implementation FEEmojiView

- (void)forTest
{
	// for test
	self.backgroundColor = [UIColor brownColor];
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame withData:(FEEmojiParameterInfo*)parameterInfo
{
    if (self = [super initWithFrame:frame])
	{
		self.backgroundColor = [UIColor clearColor];
//		[self forTest];
		self.parameterInfo = parameterInfo;
		
		[self addEmojiContentView];
		[self addLabels:parameterInfo];
    }
	
    return self;
}

- (void)dealloc
{
//	NSLog(@"==[dealloc]==FEEmojiView==");
	
	_delegate = nil;
	
	[_parameterInfo release];
	_parameterInfo = nil;
	
	[super dealloc];
}

- (CGRect)getFrameContentView
{
	CGRect bounds = [self bounds];
	CGRect rect = CGRectMake(0, 0, 320*[self getUIScale], 320*[self getUIScale]);
	rect.origin.x = 0.5f*(bounds.size.width - rect.size.width);
	rect.origin.y = 0.5f*(bounds.size.height - rect.size.height);
	
	return rect;
}

- (void)addEmojiContentView
{
	_emojiContentView = [[UIView alloc] initWithFrame:[self getFrameContentView]];
	
	[self addSubview:_emojiContentView];
	
	_emojiContentView.accessibilityLabel = @"_emojiContentView";
}

- (void)addLabels:(FEEmojiParameterInfo*)parameterInfo
{
	for (NSString* temp in parameterInfo.coordinateArray)
	{
		CGPoint pt = CGPointFromString(temp);
		pt = [self getPointWith:pt with:0.5f];
		CGRect rect = CGRectMake(pt.x, pt.y, 32, 32);
		[self addLabelView:parameterInfo with:rect parent:_emojiContentView];
	}
}

- (void)addLabelView:(FEEmojiParameterInfo*)parameterInfo with:(CGRect)frame parent:(UIView*)parentView
{
	UILabel* titleLabel = [[[FEEmojiLabel alloc] initWithFrame:frame] autorelease];
	titleLabel.font = [UIFont systemFontOfSize:parameterInfo.fontSize*[self getUIScale]];
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = parameterInfo.emojiChar;
	
	frame.size = [FEEmojiView getConstrainedToSize:titleLabel with:[self frame].size.width];
	[titleLabel setFrame:frame];
	
	[parentView addSubview:titleLabel];
}

- (CGFloat)getUIScale
{
	return [self getUISizeScale];
}

- (CGFloat)getUISizeScale
{
	static CGFloat fUIScale = 1.0f;
	
	///< 如果是iphone6 plus, 比例为1.15
//	if ([UCUIGlobal is55inchDisplay])
//	{
//		fUIScale = 1.15;
//	}
	
	return fUIScale;
}

- (CGPoint)getPointWith:(CGPoint&)pt with:(CGFloat)scale
{
	pt.x *= scale*[self getUIScale];
	pt.y *= scale*[self getUIScale];
	
	return pt;
}

+ (CGSize)getConstrainedToSize:(UILabel*)pLabel with:(int)nMaxWidth
{
	static CGSize textSize = CGSizeZero;
	if (textSize.width == 0 || textSize.height == 0)
	{
		textSize.width = nMaxWidth;
		textSize.height = nMaxWidth;
		
		if ([pLabel.text length] > 0)
		{
			textSize = [pLabel.text sizeWithFont:pLabel.font constrainedToSize:textSize lineBreakMode:pLabel.lineBreakMode];
		}
		
		textSize.width = (int)(textSize.width + 0.99f);
		textSize.height = (int)(textSize.height + 0.99f);
	}
	
	return textSize;
}

- (void)onChangeFrame
{
	[self.emojiContentView setFrame:[self getFrameContentView]];
}

#pragma mark - ==外部接口

- (void)show3DAnimation
{
	self.alpha = 1.0f;
	[self executeShow3DAnimation:_emojiContentView with:kkeyShowEmojiViewTime];
}

#pragma mark - ==动画执行完成
- (void)animationDidStop:(CAAnimation *)animKeyName finished:(BOOL)flag;
{
	NSString* keyPath = nil;
	
	if ([animKeyName isKindOfClass:[CAAnimationGroup class]])
	{
		self.alpha = 1.0f;
		
		///< 自动隐藏
		[self performSelector:@selector(hiddenFestivalEmojiView) withObject:nil afterDelay:kkeyBeforeHiddenWaitTime];
	}
	
	if ([animKeyName isKindOfClass:[CAKeyframeAnimation class]])
	{
		keyPath = [(CAKeyframeAnimation*)animKeyName keyPath];
		if ([keyPath isEqualToString:kAnimationKeyHiddenView])
		{
			//NSLog(@"=动画执行完成==kAnimationKeyHiddenView===");
			[self hiddenAnimationDidFinished];
		}
	}
}

- (void)hidden3DAnimation
{
	//NSLog(@"=执行隐藏emoji视图动画==delayHiddenAnimation===");
	[self executeHidden3DAnimation:_emojiContentView with:kkeyHiddenEmojiViewTime];
}

///< 隐藏
- (void)hiddenFestivalEmojiView
{
	[self performSelector:@selector(hidden3DAnimation) withObject:nil afterDelay:0.0f];
}

- (void)hiddenAnimationDidFinished
{
	if (_delegate && [_delegate respondsToSelector:@selector(hiddenAnimationDidFinished)])
	{
		[_delegate hiddenAnimationDidFinished];
	}
}

#pragma mark - ==显示动画

- (void)executeShow3DAnimation:(UIView*)pView with:(NSTimeInterval)duration
{
	CAKeyframeAnimation *scaleAnimation = [self buildSizeScaleAnimation:duration];
	CAKeyframeAnimation *alphaAnimation = [self buildAlphaAnimate:duration/6];
	
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

- (CAKeyframeAnimation *)buildAlphaAnimate:(NSTimeInterval)duration
{
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:2];
	NSValue* value = nil;
	
	///< 全透明 0
	value = [NSNumber numberWithFloat:0.0f];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	///< 不透明 1
	value = [NSNumber numberWithFloat:1.0f];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 创建关键帧动画
	CAKeyframeAnimation *alphaAnimate = [CAKeyframeAnimation animation];
	alphaAnimate.keyPath = @"opacity";
	alphaAnimate.duration = duration;
	alphaAnimate.delegate = self;
	alphaAnimate.values = animationValues;
	
	alphaAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	alphaAnimate.keyTimes = @[@0.0, @(1.0f)];
	
	return alphaAnimate;
}

- (CAKeyframeAnimation*)buildSizeScaleAnimation:(NSTimeInterval)duration
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
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 放大 1.0f
	fScale = 1.1f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 缩小到 0.96
	fScale = 0.96f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 恢复到 1.0f
	fScale = 1.0f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"transform";
	animation.duration = duration;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunctions = @[
								  [CAMediaTimingFunction functionWithControlPoints:0.29 :0.00 :0.15 :1.00],
								  [CAMediaTimingFunction functionWithControlPoints:0.29 :0.00 :0.15 :1.00],
								  [CAMediaTimingFunction functionWithControlPoints:0.29 :0.00 :0.15 :1.00]
								  ];
	
	///< 这里是时间段的比率，第一个动画时间占总时间的比值
	animation.keyTimes = @[@(0.0), @(2.0f/6), @(4.0f/6), @(6.0f/6)];
	
	return animation;
}

#pragma mark - ==隐藏动画
- (void)executeHidden3DAnimation:(UIView*)pView with:(NSTimeInterval)duration
{
	///< 隐藏视图动画
	[pView.layer addAnimation:[self buildNothingAnimation:duration] forKey:kAnimationKeyHiddenView];
	[self executeHiddenSubviews3DAnimation:duration];
}

- (void)executeHiddenSubviews3DAnimation:(NSTimeInterval)duration
{
	for (FEEmojiLabel* subLabel in [_emojiContentView subviews])
	{
		if ([subLabel isKindOfClass:[FEEmojiLabel class]])
		{
			[subLabel executeHiddenAnimation:duration];
		}
	}
}

- (CAKeyframeAnimation*)buildSizeScaleInAnimation2:(NSTimeInterval)duration
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
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 放大 1.2f
	fScale = 1.2f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 缩小到 0.2
	fScale = 0.01f;
	tempTransform = CATransform3DScale(defTransform, fScale, fScale, 1.0);
	value = [NSValue valueWithCATransform3D:tempTransform];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"transform";
	animation.duration = duration;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	///< 这里是时间段的比率，第一个动画时间占总时间的比值
	animation.keyTimes = @[@(0.0), @(0.15), @(1.0)];
	
	return animation;
}

///< 没有实际的效果
- (CAKeyframeAnimation*)buildNothingAnimation:(NSTimeInterval)duration
{
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:2];
	NSValue* value = nil;
	
	///< 不透明 1
	value = [NSNumber numberWithFloat:1.0f];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	///< 不透明 1
	value = [NSNumber numberWithFloat:1.0f];
	if (value)
	{
		[animationValues safe_AddObject:value];
	}
	
	// 创建关键帧动画
	CAKeyframeAnimation *alphaAnimate = [CAKeyframeAnimation animation];
	alphaAnimate.keyPath = kAnimationKeyHiddenView;
	alphaAnimate.duration = duration;
	alphaAnimate.delegate = self;
	alphaAnimate.values = animationValues;
	
	alphaAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	
	alphaAnimate.keyTimes = @[@0.0, @(1.0f)];
	
	return alphaAnimate;
}

/*
 keyTimes
 
 一个与 values 值数组对应的时间数组，定义了动画在什么时间应该到达什么值。时间以0开始，1结束。
 */


@end
