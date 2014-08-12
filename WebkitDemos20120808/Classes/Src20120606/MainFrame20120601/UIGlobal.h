/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: UIGlobal.h
 *
 * Description	: UI全局参数接口
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/06/01, yangfs, Create the file
 ***************************************************************************************
 **/


#import <UIKit/UIKit.h>
//#import "MainFuncInterface.h"


@interface UIGlobal : NSObject
{
}


+ (UIView *)getRootView;

+ (UIView *)getMainView;
+ (UIView *)getTopbarView;
+ (UIView *)getBottombarView;

+ (CGRect)getMainBounds;
+ (CGRect)getTopbarRect;
+ (CGRect)getBottombarRect;

+ (CGFloat)getStatusHeight;

+ (BOOL)isPortraitScreen;    ///< 是否竖屏


//+ (id<MainFuncInterface>)getMainFuncInstance;

@end


extern UIView * g_rootView;
extern UIView * g_mainView;
extern UIView * g_webBackgroundView;

// 解决Category编译问题，XCode 3.x在编译Category时，Category放在静态库中无法链接，只能放在App工程中编译，
// 使用USES_CATEGORY(XXX)可解决该问题
#define USES_CATEGORY(name) \
	@interface Category_##name \
	@end \
	@implementation Category_##name \
	@end 



