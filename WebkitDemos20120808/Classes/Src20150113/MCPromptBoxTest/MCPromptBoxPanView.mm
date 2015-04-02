
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: MCPromptBoxTestView.mm
 *
 * Description	: MCPromptBoxTestView (测试)
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-03-31.
 * History		: modify: 2015-03-31.
 ******************************************************************************
 **/


#import "MCPromptBoxTestHead.h"

#ifdef Enable_Test_Prompt_Box_MCPromptBoxTestController


#import "MCPromptBoxPanView.h"

CG_INLINE CGPoint CGPointAdd(CGPoint thePoint1, CGPoint thePoint2)
{
	return CGPointMake(thePoint1.x + thePoint2.x, thePoint1.y + thePoint2.y);
}

@interface MCPromptBoxPanView()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIPanGestureRecognizer* panGestureObj;
@property (nonatomic, assign) CGPoint               centerPoint;
@property (nonatomic, assign) BOOL                  bPanningSatate;  ///< 正在滑动

@end


@implementation MCPromptBoxPanView


- (void)forTest
{
	// for test
	self.backgroundColor = [UIColor purpleColor];
	self.layer.borderWidth = 2;
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		self.backgroundColor = [UIColor clearColor];
		[self forTest];
		
		[self setupPanGestureObj];
		self.alpha = 0.5f;
	}
	return self;
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

-(void)releaseObject
{
	[self destroyPanGestureRecognizer];
}

- (void)addSubViews:(CGRect)frame
{
	
}

#pragma mark -==滑动手势相关

- (void)setupPanGestureObj
{
	_panGestureObj = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	_panGestureObj.maximumNumberOfTouches = 1;
	_panGestureObj.delegate = self;
	
	[self addGestureRecognizer:_panGestureObj];
}

- (void)destroyPanGestureRecognizer
{
	if (_panGestureObj)
	{
		_panGestureObj.delegate = nil;
		[_panGestureObj removeTarget:self action:NULL];
		[self removeGestureRecognizer:_panGestureObj];
		[_panGestureObj release];
		_panGestureObj = nil;
	}
}

#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
	BOOL shouldBegin = NO;
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
	{
		CGPoint pt = [_panGestureObj locationInView:self];
		pt = [touch locationInView:self];
		CGRect rect = [self bounds];
		//rect.origin.x += rect.size.width - 20;
		//rect.size.width = 20;
		shouldBegin = CGRectContainsPoint(rect, pt);
	}
	
	return shouldBegin;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
	BOOL shouldBegin = NO;
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
	{
		CGPoint pt = [_panGestureObj locationInView:self];
		//pt = [touch locationInView:self];
		CGRect rect = [self bounds];
		//rect.origin.x += rect.size.width - 20;
		//rect.size.width = 20;
		shouldBegin = CGRectContainsPoint(rect, pt);
	}
	
	return shouldBegin;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
	if (_panGestureObj == gestureRecognizer)
	{
		switch (gestureRecognizer.state)
		{
			case UIGestureRecognizerStateBegan:
			{
				[self panBeganState];
				break;
			}
			case UIGestureRecognizerStateChanged:
			{
				[self panningState];
				break;
			}
			case UIGestureRecognizerStateEnded:
			{
				[self panEndState];
				break;
			}
			case UIGestureRecognizerStateCancelled:
			case UIGestureRecognizerStateFailed:
			{
				[self panFailedState];
				break;
			}
			default:
				break;
		}
	}
}

- (void)panBeganState
{
	_centerPoint = [[self superview] center];
	_bPanningSatate = YES;
}

- (void)panEndState
{
	_bPanningSatate = NO;
}

- (void)panFailedState
{
	_bPanningSatate = NO;
}

- (void)panningState
{
	if (!_bPanningSatate)
	{
		return;
	}
	
	CGPoint translation = [_panGestureObj translationInView:[self superview]];
	
	[self superview].center = CGPointAdd(translation, _centerPoint);
}

@end


#endif
