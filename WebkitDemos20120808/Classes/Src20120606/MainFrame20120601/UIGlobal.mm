/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: UIGlobal.mm
 *
 * Description	: UI全局参数接口
 *
 * Author		: yangcy@ucweb.com
 * History		: 
 *			   Creation, 2012/04/25, yangcy, Create the file
 ***************************************************************************************
 **/


//#import "iStdafxMM.h"
#import "UIGlobal.h"
//#import "Bottombar.h"
//#import "IWebListManager.h"
//#import "Config.h"
//#import "MainFuncImpl.h"


UIView * g_rootView = nil;
UIView * g_mainView = nil;
UIView * g_webBackgroundView = nil;

@implementation UIGlobal

+ (UIView *)getRootView
{
	return g_rootView;
}

+ (UIView *)getMainView
{
	return nil;
	//return g_mainView;
}

+ (UIView *)getTopbarView
{
	return nil;
	//return [g_winManager.currentWebAgent topbar];
}

+ (UIView *)getBottombarView
{
	return nil;
	//return [Bottombar shareInstance].view;
}

+ (CGRect)getMainBounds
{
	return CGRectMake(0, 0, 320, 460);
	//return g_rootView.bounds;
}

+ (CGRect)getTopbarRect
{
	return CGRectMake(0, 0, 320, 40);
	//return [UIGlobal getTopbarView].frame;
}

+ (CGRect)getBottombarRect
{
	return CGRectMake(0, 0, 320, 40);
	//return [UIGlobal getBottombarView].frame;
}

+ (CGFloat)getStatusHeight
{
	if ([UIApplication sharedApplication].statusBarHidden)
	{
		return 0;
	}
	
	CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
	CGFloat height = statusBarFrame.size.height;
	if (!UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
	{
		height = statusBarFrame.size.width;
	}
	
	return height;
}

+ (BOOL)isPortraitScreen    ///< 是否竖屏
{
	UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationIsPortrait(statusBarOrientation);
	
	//CGRect bounds = [UIGlobal getMainBounds];
	//return (bounds.size.height > bounds.size.width);
}

//+ (id<MainFuncInterface>)getMainFuncInstance
//{
//	return [MainFuncImpl shareInstance];
//}


@end