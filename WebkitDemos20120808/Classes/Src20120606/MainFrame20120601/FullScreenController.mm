/*
 **************************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: FullScreenController.mm
 *
 * Description	: 全屏控制器
 *
 * Author		: yangcy@ucweb.com
 * History		: 
 *			   Creation, 2012/04/28, yangcy, Create the file
 ***************************************************************************************
 **/


#import "FullScreenController.h"
#import "UIGlobal.h"
//#import "UIAppFullScreenController.h"
#import <objc/runtime.h>

#define UC_DEF_BTNBAR_VERT_HEIGHT		40.0f
#define UC_DEF_BTNBAR_HORIZ_HEIGHT		32.0f  //anthzhu modifies for bottom height stretched at horizontal level at 2011-05-04

//USES_CATEGORY(Hook_presentModalViewController)

//UIView * g_rootView = nil;
//UIView * g_mainView = nil;
//UIView * g_webBackgroundView = nil;

#define DURATION	0.35


#pragma mark -
#pragma mark UIViewController (Hook_presentModalViewController) 

// 解决短信等界面弹出后，系统状态栏不正确的问题
@interface UIViewController (Hook_presentModalViewController) 

+ (void)hookPresentModalViewController;

@end

@implementation UIViewController (Hook_presentModalViewController) 

static IMP g_imp_presentModalViewController_original = nil;

+ (void)hookPresentModalViewController
{
	Class klass = objc_getClass("UIViewController");
	
    g_imp_presentModalViewController_original = class_getMethodImplementation(klass, @selector(presentModalViewController:animated:));
	
	method_exchangeImplementations(class_getInstanceMethod(klass, @selector(presentModalViewController:animated:)),
								   class_getInstanceMethod(klass, @selector(presentModalViewController_custom:animated:)));
}

- (void)presentModalViewController_custom:(UIViewController *)modalViewController animated:(BOOL)animated
{
    if (g_imp_presentModalViewController_original)
    {
        g_imp_presentModalViewController_original(self, @selector(presentModalViewController:animated:), modalViewController, animated);
    
		[[FullScreenController shareInstance] cancelPointInsideEvent];
	}
}

@end



#pragma mark -
#pragma mark PointInsideView

// PointInsideView，半全屏模式下，用于拦截触摸事件，在页面部分触摸则退出半全屏模式

@protocol PointInsideViewEvents

- (void)onPageRegionTouchesBegin;

@end

@interface PointInsideView : UIView 
{
}

@end

@implementation PointInsideView


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	CGRect rcTop = [UIGlobal getTopbarRect];
	CGRect rcBottom = [UIGlobal getBottombarRect];
	CGRect rcFrame = g_mainView.bounds;
	rcFrame.origin.y += rcTop.size.height + rcTop.origin.y;
	rcFrame.size.height -= rcTop.size.height + rcTop.origin.y + rcBottom.size.height;
	
	CGPoint pt = [g_mainView convertPoint:point fromView:self];
	if (CGRectContainsPoint(rcFrame, pt))
	{
		// 当点击页面链接的时候，点击焦点会跳到下面一行，使用延时0.2秒可解决大多数问题
		// 由于现在半全屏动画过程中对页面做了特殊处理，让页面保持不动，从而避开了该问题，不用再延时0.2秒
		//[self performSelector:@selector(delayPostTouchesEvent) withObject:self afterDelay:0.2];
//		emitEventLater(self, @selector(onPageRegionTouchesBegin));
	}
	
	return NO;
}

- (void)delayPostTouchesEvent
{
//	emitEvent(self, @selector(onPageRegionTouchesBegin));
}

@end


#pragma mark -
#pragma mark FullScreenController

@interface FullScreenController ()

@property (nonatomic, assign) PointInsideView *	pointInsideView;		///< 用于半全屏模式下拦截用户输入，退出半全屏状态
@property (nonatomic, assign) SCREEN_MODE		screenMode;				///< 屏幕模式
@property (nonatomic, assign) SCREEN_MODE		lastScreenMode;			///< 先前的屏幕模式
@property (nonatomic, assign) BOOL				isWebViewsHasShifted;	///< 页面已经向上偏移，用于半全屏模式，目的是让页面相对屏幕保持不变，以致在退出全屏的时候可以看见页面发生移动
@property (nonatomic, assign) BOOL				isDoingAnimation;		///< 正在做全屏动画

- (void)_enterFullScreenAnimated:(BOOL)animated;		///< 进入全屏
- (void)_exitFullScreenAnimated:(BOOL)animated;			///< 退出全屏

- (void)showBottombarAnimated:(BOOL)animated;
- (void)hideBottombarAnimated:(BOOL)animated;

- (void)showTopbarAnimated:(BOOL)animated;
- (void)hideTopbarAnimated:(BOOL)animated;

- (void)showStatusbarAnimated:(BOOL)animated;
- (void)hideStatusbarAnimated:(BOOL)animated;

- (void)showFullScreenMenuAnimated:(BOOL)animated;	///< 显示全屏菜单按钮
- (void)hideFullScreenMenuAnimated:(BOOL)animated;	///< 隐藏示全屏菜单按钮

- (void)removePointInsideView;
- (void)delayPrepare;

@end

@implementation FullScreenController

@synthesize pointInsideView = m_pointInsideView;
@synthesize screenMode = m_screenMode;
@synthesize lastScreenMode = m_lastScreenMode;
@synthesize isWebViewsHasShifted = m_isWebViewsHasShifted;
@synthesize isDoingAnimation = m_isDoingAnimation;


+ (FullScreenController *)shareInstance
{
	static FullScreenController * g_fullScreen = nil; 
	if (nil == g_fullScreen)
	{
		g_fullScreen = [[FullScreenController alloc] init];
		
		[UIViewController hookPresentModalViewController];
	}
	
	return g_fullScreen;
}

+ (BOOL)isFullScreenLayout		///< 检测当前主视图是否按全屏布局，全屏模式或应用全屏模式下都将返回YES
{
	return ([[FullScreenController shareInstance] isFullScreen] || [[FullScreenController shareInstance] isAppFullScreen]);
}

- (id)init
{
	self = [super init];
	if (self)
	{
		[self performSelector:@selector(delayPrepare) withObject:self afterDelay:0.0];
	}
	
	return self;
}

- (void)dealloc
{
	[m_pointInsideView release];
	m_pointInsideView = nil;
	
	[super dealloc];
}

- (void)delayPrepare
{
	// 为保证FullScreenController最先得到旋转事件，因此将自注册修改为外部直接调用
	//connectEvent(nil, @selector(willAnimateRotationToInterfaceOrientation:duration:), self, @selector(willAnimateRotation:duration:));
	//connectEvent([iUIFullScreenMenu defaultFullScreenMenu], @selector(onMenuClicked), self, @selector(onMenuClicked));

	if ([self isFullScreenInSettings])
	{
		[self restoreLastScreenModeAnimated:YES];
	}
}


#pragma mark -
#pragma mark 获取屏幕模式

- (BOOL)isNormalScreen				///< 是否正常模式
{
	return (SM_Normal == m_screenMode);
}

- (BOOL)isHalfFullScreen			///< 是否处于半全屏模式，当处于半全屏模式时，isFullScreen将返回NO
{
	return (SM_HalfFullScreen == m_screenMode);
}

- (BOOL)isFullScreen				///< 是否全屏
{
	return (SM_FullScreen == m_screenMode);
}

- (BOOL)isFullScreenInSettings		///< 设置项是否全屏
{
	return NO;
	//return [[SettingAgent standardSettingAgent] isFullScreen];	
}

- (BOOL)isAppFullScreen				///< 是否应用全屏模式O
{
	return (SM_AppFullScreen == m_screenMode);
}


#pragma mark -
#pragma mark 主逻辑处理

- (int)getBottomBarHeight
{
	int height = UC_DEF_BTNBAR_VERT_HEIGHT;
    CGRect bounds = [UIGlobal getMainBounds];
	if(bounds.size.width > bounds.size.height)
	{
		height = UC_DEF_BTNBAR_HORIZ_HEIGHT;
	}
	
	return height;
}

- (void)shiftAllWebViews
{
	return; ///< 不使用页面偏移功能
	
//	CGFloat statusHeight = [UIGlobal getStatusHeight];
//	int winCount = g_winManager.windowCount;
//	for (int i = 0; i < winCount; ++i)
//	{
//		WebAgent* agent = [g_winManager getWebAgent:i];
//		WebViewWrapper* webView = agent.webView;
//		CGRect rect = webView.frame;
//		rect.origin.y = -statusHeight;
//		webView.frame = rect;
//	}
//	
//	m_isWebViewsHasShifted = YES;
}

- (void)restoreAllWebViews
{
	return; ///< 不使用页面偏移功能
	
//	int winCount = g_winManager.windowCount;
//	for (int i = 0; i < winCount; ++i)
//	{
//		WebAgent* agent = [g_winManager getWebAgent:i];
//		WebViewWrapper* webView = agent.webView;
//		CGRect rect = webView.frame;
//		rect.origin.y = 0;
//		webView.frame = rect;
//	}
//	
//	m_isWebViewsHasShifted = NO;
}

- (void)adgustMainFrameViews:(BOOL)isIncludeRoot		///< 重新调整主视图位置
{
	if (isIncludeRoot)
	{
		CGRect appFrame = [UIScreen mainScreen].applicationFrame;
		g_rootView.frame = appFrame;	///< 会导致adgustMainFrameViewsAnimated重入，因此使用g_isThisStack来检测
	}
	g_mainView.frame = g_rootView.bounds;
	
    // 旋屏后，底部工具栏的高度需改变
	UIView* bottomBar = [UIGlobal getBottombarView];
	int ht = [self getBottomBarHeight]; 
	CGRect rcBottom = bottomBar.frame;
	rcBottom.origin.y = g_mainView.bounds.size.height - ht;
	rcBottom.size.height = ht;
	rcBottom.size.width = g_mainView.frame.size.width;
	if ([self isFullScreen] || [self isAppFullScreen])
	{
		rcBottom.origin.y = g_mainView.bounds.size.height;
		if (!m_isDoingAnimation)
		{
			[UIGlobal getBottombarView].hidden = YES;
		}
	}
	else
	{
		[UIGlobal getBottombarView].hidden = NO;
	}
	bottomBar.frame = rcBottom;
	
	if ([self isHalfFullScreen])
	{
		[self shiftAllWebViews]; ///< 移动页面内容，让页面相对屏幕保持不变，以致在退出全屏的时候可以看见页面发生移动
	}
	else if (m_isWebViewsHasShifted)
	{
		[self restoreAllWebViews]; 
	}
	else
	{
		// 页面窗口的大小将随底部工具栏而变化
		CGRect rcPage = g_mainView.bounds;
		if ((![self isFullScreen]) && (![self isAppFullScreen]))
		{
			rcPage.size.height -= [UIGlobal getBottombarRect].size.height;
		}

		g_webBackgroundView.frame = rcPage;
	}
	
	if (m_lastScreenMode != m_screenMode)
	{
//		emitEvent(self, @selector(screenModeChanged:), m_lastScreenMode);
		m_lastScreenMode = m_screenMode;
	}
}

- (void)adgustMainFrameViewsAnimated:(BOOL)animated includeRootView:(BOOL)isIncludeRoot		///< 重新调整主视图位置
{
	static BOOL g_isThisStack = NO; ///< g_rootView.frame的调整会导致adgustMainFrameViewsAnimated重入，因此使用g_isThisStack来检测
	if (g_isThisStack)
	{
		return;
	}
	
	g_isThisStack = YES;
	
	if (animated)
	{
		[UIView beginAnimations:@"adgustMainFrameViews" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:DURATION];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		
		m_isDoingAnimation = YES;

		[self adgustMainFrameViews:isIncludeRoot];
	
//		emitEvent(self, @selector(beginFullScreenAnimation));
		[UIView commitAnimations];
	}
	else
	{
		m_isDoingAnimation = NO;
		[self adgustMainFrameViews:isIncludeRoot];
	}
	
	g_isThisStack = NO;
}

- (void)willAnimateRotation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	[self removePointInsideView];
	
	if (m_isWebViewsHasShifted)
	{
		[self restoreAllWebViews]; 
	}
	
	
	if ([self isAppFullScreen])
	{
		[self adgustMainFrameViewsAnimated:NO includeRootView:YES];
	}
	else
	{
		if ([self isFullScreenInSettings])
		{
			m_screenMode = SM_Normal;
			[self _enterFullScreenAnimated:NO];
		}
		else
		{
			m_screenMode = SM_FullScreen;
			[self _exitFullScreenAnimated:NO];
		}
	}
}

- (void)restoreLastScreenModeAnimated:(BOOL)animated	///< 恢复上次的屏幕模式 
{
	if (m_isWebViewsHasShifted)
	{
		[self restoreAllWebViews]; 
	}
	
	if ([self isAppFullScreen])
	{
		//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_ENABLE_ADDRESSBAR object:nil];
		//printf(" !!!Warning(102) restoreLastScreenModeAnimated isAppFullScreen.\r\n");
	}
	
	if ([self isFullScreenInSettings])
	{
		m_screenMode = SM_Normal;
		[self _enterFullScreenAnimated:animated];
	}
	else
	{
		m_screenMode = SM_FullScreen;
		[self _exitFullScreenAnimated:animated];
	}
}

- (void)switchScreenModeAnimated:(BOOL)animated	///< 切换全屏状态
{
	if (![self isNormalScreen])
	{
		[self exitFullScreenAnimated:YES];
	}
	else
	{
		[self enterFullScreenAnimated:YES];
	}
}

- (void)_exitFullScreenAnimated:(BOOL)animated		///< 退出全屏
{
	if ([self isNormalScreen])
	{
		return;
	}
	
	if ([self isHalfFullScreen]) 
	{
		[self removePointInsideView];	
	}

	m_screenMode = SM_Normal;

	[self showStatusbarAnimated:animated];
	[self adgustMainFrameViewsAnimated:animated includeRootView:YES];
	[self showTopbarAnimated:animated];
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:NO];
}

- (void)_enterFullScreenAnimated:(BOOL)animated		///< 进入全屏
{
	assert(![self isHalfFullScreen]);
	if ([self isFullScreen])
	{
		return;
	}
	
	m_screenMode = SM_FullScreen;
	
	[self hideStatusbarAnimated:animated];
	[self adgustMainFrameViewsAnimated:animated includeRootView:YES];
	[self hideTopbarAnimated:animated];
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:YES];
	
}

- (void)enterFullScreenAnimated:(BOOL)animated		///< 进入全屏
{
	assert(![self isHalfFullScreen]);
	if ([self isFullScreen])
	{
		return;
	}
	
	//[[SettingAgent standardSettingAgent] setFullScreen:YES];
	
	[self _enterFullScreenAnimated:animated];
}

- (void)exitFullScreenAnimated:(BOOL)animated		///< 退出全屏
{
	if ([self isNormalScreen])
	{
		return;
	}
	
	if ([self isAppFullScreen])
	{
		//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_ENABLE_ADDRESSBAR object:nil];
		printf(" !!!Warning(101) exitFullScreenAnimated isAppFullScreen.\r\n");
	}
	
	//[[SettingAgent standardSettingAgent] setFullScreen:NO];
	
	[self _exitFullScreenAnimated:animated];
}


#pragma mark -
#pragma mark 半全屏模式处理

- (void)enterHalfFullScreenAnimated:(BOOL)animated		///< 进入半全屏模式，在全屏状态下显示标准工具栏视图
{
	assert(![self isNormalScreen]);
	if ([self isHalfFullScreen])
	{
		return;
	}
	
	if (nil == m_pointInsideView)
	{
		m_pointInsideView = [[PointInsideView alloc] init];
		[g_mainView addSubview:m_pointInsideView];
//		createEventConnection(m_pointInsideView, @selector(onPageRegionTouchesBegin), self, @selector(onPageRegionTouchesBegin));
	}
	
	m_screenMode = SM_HalfFullScreen;
	
	[self showStatusbarAnimated:animated];
	[self adgustMainFrameViewsAnimated:animated includeRootView:YES];
	[self showTopbarAnimated:animated];
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:NO];
}

- (void)exitHalfFullScreenAnimated:(BOOL)animated			///< 退出半全屏模式，在全屏状态下隐藏标准工具栏视图
{
	if (![self isHalfFullScreen])
	{
		return;
	}
	
	[self cancelPointInsideEvent];
	
	[self removePointInsideView];	
	m_screenMode = SM_FullScreen;
	
	[self hideStatusbarAnimated:animated];
	[self adgustMainFrameViewsAnimated:animated includeRootView:YES];
	[self hideTopbarAnimated:animated];
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:YES];
}

- (void)onMenuClicked
{
	//[self performSelector:@selector(delay_enterHalfFullScreen) withObject:self afterDelay:0.0];
	[self performSelector:@selector(delay_enterHalfFullScreen)];
}

- (void)delay_enterHalfFullScreen
{
	[self enterHalfFullScreenAnimated:YES];
	//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_SHOW_ADDRESS_BAR object:self userInfo:nil];
}

- (void)onPageRegionTouchesBegin
{
	[self exitHalfFullScreenAnimated:YES];
}

- (void)removePointInsideView
{
	if (m_pointInsideView)
	{
		[m_pointInsideView removeFromSuperview];
		[m_pointInsideView release];
		m_pointInsideView = nil;
	}
}

- (void)cancelPointInsideEvent		///< 取消拦截触摸事件处理
{
	[NSObject cancelPreviousPerformRequestsWithTarget:m_pointInsideView];
}

#pragma mark -
#pragma mark 应用全屏模式

- (void)enterAppFullScreenAnimated:(BOOL)animated			///< 进入应用全屏模式，进入全屏模式下隐藏全屏菜单按钮
{
	if ([self isHalfFullScreen])
	{
		[self removePointInsideView];
		[self restoreAllWebViews]; 
	}
	
	m_screenMode = SM_AppFullScreen;
	
    // 
    //[g_winManager.currentWebView willEnterAppFullScreenMode];
	[self hideStatusbarAnimated:animated];
	[self adgustMainFrameViewsAnimated:animated includeRootView:YES];
	[self hideTopbarAnimated:animated];
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:NO];
	
//	[[UIAppFullScreenController getInstance] enterAppFullScreen];
	//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_DISABLE_ADDRESSBAR object:nil];
}

- (void)exitAppFullScreenAnimated:(BOOL)animated			///< 退出应用全屏模式，恢复之前的屏幕模式
{
	if (![self isAppFullScreen])
	{
		return;
	}
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_ENABLE_ADDRESSBAR object:nil];
	[self restoreLastScreenModeAnimated:animated];
	
//	[[UIAppFullScreenController getInstance] exitAppFullScreen];
}


#pragma mark -
#pragma mark 工具栏状态处理

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
	if ([animationID isEqualToString:@"hideBottombar"])
	{
		[UIGlobal getBottombarView].hidden = YES;
	}
	else if ([animationID isEqualToString:@"adgustMainFrameViews"])
	{
		if ([self isFullScreen] || [self isAppFullScreen])
		{
			[UIGlobal getBottombarView].hidden = YES;
		}
		
		m_isDoingAnimation = NO;
//		emitEvent(self, @selector(endFullScreenAnimation));
		
		// 从半全屏直接退出全屏，由于执行restoreAllWebViews而未修正g_webBackgroundView的frame
		if (!m_isWebViewsHasShifted)
		{
			// 页面窗口的大小将随底部工具栏而变化
			CGRect rcPage = g_mainView.bounds;
			if ((![self isFullScreen]) && (![self isAppFullScreen]))
			{
				rcPage.size.height -= [UIGlobal getBottombarRect].size.height;
			}
			
			g_webBackgroundView.frame = rcPage;		
		}
	}
}

- (void)hideBottombarAnimated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:@"hideBottombar" context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:DURATION];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	}
	
	CGRect bottom_rect = [UIGlobal getBottombarRect];
	bottom_rect.origin.y = g_mainView.bounds.size.height;
	
	[UIGlobal getBottombarView].frame = bottom_rect;
	
	if (animated)
	{
		[UIView commitAnimations];
	}
}

- (void)showBottombarAnimated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:@"showBottombar" context:nil];
		[UIView setAnimationDuration:DURATION];
	}
	
	CGRect main_rect = g_mainView.bounds;
	CGRect bottom_rect = [UIGlobal getBottombarRect];
	bottom_rect.origin.y = main_rect.origin.y + main_rect.size.height - bottom_rect.size.height;
	
	[UIGlobal getBottombarView].frame = bottom_rect;
	[UIGlobal getBottombarView].hidden = NO;
	
	if (animated)
	{
		[UIView commitAnimations];
	}
}

- (void)hideTopbarAnimated:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_ENTER_FULLSCREEN object:self userInfo:nil];
}

- (void)showTopbarAnimated:(BOOL)animated
{
	//[[NSNotificationCenter defaultCenter] postNotificationName:UCWEB_EXIT_FULLSCREEN object:self userInfo:nil];
}

- (void)hideStatusbarAnimated:(BOOL)animated
{
	if ([UIApplication sharedApplication].statusBarHidden == NO)
	{
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
		{
			[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
		}
		else
		{
			[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
		}
		
//		emitEvent(nil, @selector(hiddenNavigationBar));
	}
}

- (void)showStatusbarAnimated:(BOOL)animated
{
	if ([UIApplication sharedApplication].statusBarHidden == YES)
	{
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
		{
			[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
		}
		else
		{
			[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
		}
//		emitEvent(nil, @selector(showNavigationBar));
	}
}

- (void)showFullScreenMenuAnimated:(BOOL)animated	///< 显示全屏菜单按钮
{
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:YES];
}

- (void)hideFullScreenMenuAnimated:(BOOL)animated	///< 隐藏示全屏菜单按钮
{
	//[[iUIFullScreenMenu defaultFullScreenMenu] showBtn:NO];
}

- (BOOL)isDoingAnimation			///< 正在做全屏动画
{
	return m_isDoingAnimation;
}


@end
