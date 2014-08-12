//
//  UISwipeGestureSingleEx.h
//  WebkitDemos20120209_i4
//
//  Created by yang yang on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 File             =  UISwipeGestureDouble.h
 Description  =  实现双手指滑动手势识别(Double finger swipe Gesture Recognizer).
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2011-11-29
 
 */

//#import <UIKit/UIKit.h>
#ifndef _DEF_UISwipeGestureSingleEx_H_
#define _DEF_UISwipeGestureSingleEx_H_




@interface UISwipeGestureSingleEx : 
UIGestureRecognizer
//UISwipeGestureRecognizer
{
	CGPoint midPoint;
}

-(CGPoint)getMidPoint;

@end

#endif // #ifndef _DEF_UISwipeGestureDouble_H_
