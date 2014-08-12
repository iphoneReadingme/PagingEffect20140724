/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: FullScreenController.h
 *
 * Description	: 全屏控制器
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/06/01, yangfs, Create the file
 ***************************************************************************************
 **/

#import <UIKit/UIKit.h>

// 屏幕模式定义
enum SCREEN_MODE
{
	SM_Normal,				///< 正常模式
	SM_FullScreen,			///< 全屏模式: 隐藏系统状态栏(Statusbar)、Topbar与Bottombar
	SM_HalfFullScreen,		///< 半全屏模式: 全屏模式下，暂时显示出系统状态栏、Topbar与Bottombar，点击页面将回到全屏模式
	SM_AppFullScreen,		///< 应用全屏模式: 由特殊页面触发，隐藏全屏菜单按钮，退出应用全屏后恢复之前的屏幕模式
};

@protocol FullScreenControllerEvents

- (void)beginFullScreenAnimation;					///< 开始做动画，不区分进入全屏和退出全屏
- (void)endFullScreenAnimation;						///< 动画结束
//- (void)screenModeChanged:(SCREEN_MODE)lastScreenMode;	///< 屏幕模式发生改变

@end


@class PointInsideView;

@interface FullScreenController : NSObject

+ (FullScreenController *)shareInstance;	///< 共享单例

+ (BOOL)isFullScreenLayout;			///< 检测当前主视图是否按全屏布局，全屏模式或应用全屏模式下都将返回YES

- (BOOL)isNormalScreen;				///< 是否正常模式
- (BOOL)isHalfFullScreen;			///< 是否处于半全屏模式，当处于半全屏模式时，isFullScreen将返回NO
- (BOOL)isFullScreen;				///< 是否全屏模式
- (BOOL)isFullScreenInSettings;		///< 设置项是否全屏，用于横竖屏切换和再次启动恢复上次屏幕模式，横竖屏分别记忆各自的屏幕模式
- (BOOL)isAppFullScreen;			///< 是否应用全屏模式

- (void)enterFullScreenAnimated:(BOOL)animated;			///< 进入全屏
- (void)exitFullScreenAnimated:(BOOL)animated;			///< 退出全屏

- (void)switchScreenModeAnimated:(BOOL)animated;		///< 切换全屏状态，点击全屏按钮可直接调用该方法

- (void)restoreLastScreenModeAnimated:(BOOL)animated;	///< 恢复上次的屏幕模式 
- (void)adgustMainFrameViewsAnimated:(BOOL)animated includeRootView:(BOOL)isIncludeRoot;	///< 重新调整主视图位置

- (void)enterHalfFullScreenAnimated:(BOOL)animated;		///< 进入半全屏模式，在全屏模式下显示标准工具栏视图
- (void)exitHalfFullScreenAnimated:(BOOL)animated;		///< 退出半全屏模式，在全屏模式下隐藏标准工具栏视图

- (void)enterAppFullScreenAnimated:(BOOL)animated;		///< 进入应用全屏模式，进入全屏模式下隐藏全屏菜单按钮
- (void)exitAppFullScreenAnimated:(BOOL)animated;		///< 退出应用全屏模式，恢复之前的屏幕模式

- (void)willAnimateRotation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration; ///< 屏幕旋转处理

- (BOOL)isDoingAnimation;			///< 正在做全屏动画

- (void)cancelPointInsideEvent;		///< 取消拦截触摸事件处理


@end

//extern UIView * g_rootView;
//extern UIView * g_mainView;
//extern UIView * g_webBackgroundView;



