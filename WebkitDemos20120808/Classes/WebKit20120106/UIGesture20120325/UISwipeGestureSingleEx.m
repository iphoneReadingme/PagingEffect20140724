//
//  UISwipeGestureSingleEx.m
//  WebkitDemos20120209_i4
//
//  Created by yang yang on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UISwipeGestureSingleEx.h"


static BOOL strokeUp = NO;
// =================================================================
#pragma mark -
#pragma mark 实现UISwipeGestureSingleEx


#define kSingleSwipe     1
#define kDoubleSwipe     2
#define kGestureType     kSingleSwipe

@implementation UISwipeGestureSingleEx

- (id)initWithTarget:(id)target action:(SEL)action
{
	if ((self=[super initWithTarget:target action:action]))
	{
		//direction = UISwipeGestureRecognizerDirectionRight;
		//self.numberOfTouchesRequired = 2;
	}
	return self;
}

-(CGPoint)getMidPoint
{
	return midPoint;
}

- (void)reset
{
	[super reset];
	// self.midPoint = CGPointZero;
	strokeUp = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	strokeUp = NO;
	midPoint = CGPointZero;
	[super touchesBegan:touches withEvent:event];
	
	// =================================================================
	int nCountTouches = 0;
	//---get all touches on the screen---
	NSSet *allTouches = [event allTouches];
	//---compare the number of touches on the screen---
	nCountTouches = [allTouches count];
	NSLog(@"=== ([allTouches count] = %d) ", nCountTouches);
	//---compare the number of touches on the screen---
	switch ([allTouches count])
	{
			//---single touch---
		case 1:
		{
			//---get info of the touch---
			//UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			break;
		}
		case 2:
		{
			//---get info of first touch---
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			//---get info of second touch---
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			
			//---get the points touched---
			CGPoint touch1PT = [touch1 locationInView:[self view]];
			CGPoint touch2PT = [touch2 locationInView:[self view]];
			
			NSLog(@"Touch1: %.0f, %.0f", touch1PT.x, touch1PT.y);
			NSLog(@"Touch2: %.0f, %.0f", touch2PT.x, touch2PT.y);
			
			break;
		}
	}
	// =================================================================
	
	//nCountTouches = [[event touchesForGestureRecognizer:self] count];
	nCountTouches = [allTouches count];
	NSLog(@"=== (nCountTouches = %d) ", nCountTouches);
	if (nCountTouches != kGestureType)
	{
		self.state = UIGestureRecognizerStateFailed;
		NSLog(@"=== (nCountTouches = %d)==UIGestureRecognizerStateFailed\n\n", nCountTouches);
		return;
	}
	
	//if ([touches count] != 2)
	{
		nCountTouches = [touches count];
		//self.state = UIGestureRecognizerStateFailed;
		NSLog(@"=== ([touches count] = %d)==\n\n", nCountTouches);
		//return;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"===touchesMoved ==UISwipeGestureDouble===\n\n");
	[super touchesMoved:touches withEvent:event];
	
	// =================================================================
	int nCountTouches = 0;
	//---get all touches on the screen---
	NSSet *allTouches = [event allTouches];
	//---compare the number of touches on the screen---
	nCountTouches = [allTouches count];
	
	NSLog(@"=== ([allTouches count] = %d) ", nCountTouches);
	//---compare the number of touches on the screen---
	switch ([allTouches count])
	{
			//---single touch---
		case 1:
		{
			//---get info of the touch---
			//UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			break;
		}
		case 2:
		{
			//---get info of first touch---
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
			//---get info of second touch---
			UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			
			//---get the points touched---
			CGPoint touch1PT = [touch1 locationInView:[self view]];
			CGPoint touch2PT = [touch2 locationInView:[self view]];
			
			NSLog(@"Touch1: %.0f, %.0f", touch1PT.x, touch1PT.y);
			NSLog(@"Touch2: %.0f, %.0f", touch2PT.x, touch2PT.y);
			
			break;
		}
	}
	// =================================================================
	
	if (self.state == UIGestureRecognizerStateFailed)
	{
		NSLog(@"===touchesMoved=if (self.state == UIGestureRecognizerStateFailed)\n\n");
		return;
	}
	
	UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
	CGPoint nowPoint2 = [touch1 locationInView:[self view]];
	CGPoint prevPoint2 = [touch1 previousLocationInView:[self view]];
	
	if (nCountTouches >= 2)
	{
		UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
		nowPoint2 = [touch2 locationInView:[self view]];
		prevPoint2 = [touch2 previousLocationInView:[self view]];
	}
	
	CGPoint nowPoint = [[touches anyObject] locationInView:[self view]];
	CGPoint prevPoint = [[touches anyObject] previousLocationInView:[self view]];
	//if (self.direction == UISwipeGestureRecognizerDirectionUp || self.direction == UISwipeGestureRecognizerDirectionDown)
	//if (nowPoint.x >= prevPoint.x && nowPoint.y >= prevPoint.y)
	if (nowPoint.x >= prevPoint.x)
	{
		//iUIGestureView* pView = (iUIGestureView*)self.view;
		//if ( (nowPoint.x >= prevPoint.x && nowPoint.y <= prevPoint.y))
		{
			//[pView handleSwipeFromEx:self];
		}
	}
	else
	{
		self.state = UIGestureRecognizerStateFailed;
		
		NSLog(@"===touchesMoved=====if (self.direction == == UIGestureRecognizerStateFailed)\n\n");
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	//	if (self.state == UIGestureRecognizerStatePossible)
	//	{
	//		self.state = UIGestureRecognizerStateRecognized ;
	//	}
	if ((self.state == UIGestureRecognizerStatePossible))
	{
		self.state = UIGestureRecognizerStateRecognized;
	}
	NSLog(@"===touchesEnded     UISwipeGestureDouble==   touchesEnded=\n\n");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	
	//self.state = UIGestureRecognizerStateFailed;
	midPoint = CGPointZero;
	strokeUp = NO;
	self.state = UIGestureRecognizerStateFailed;
	
	NSLog(@"===touchesCancelled====UISwipeGestureDouble =\n\n");
}

@end

// =================================================================
#pragma mark -
#pragma mark 文件尾

