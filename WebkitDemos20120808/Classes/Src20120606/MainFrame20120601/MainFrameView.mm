
#import <UIKit/UIKit.h>
#import "UITestView.h"
#import "MainFrameView.h"
#import "iUIAppFrame.h"
#import "BottomBarViewController.h"
//#import "ResManager.h"
//#import "NSObject_Event.h"
#import "UIGlobal.h"


///< 私有方法
@interface MainFrameView (MainFrameView_Private)

- (void)setViewColor:(UIView*)pView;
- (void)releaseObject;

- (void)addViews;
- (void)addBgView:(CGRect)frame;
- (void)addBottomBarView;

-(void)onChangeViewFrame:(CGRect)superViewFrame;

@end

// =================================================================
#pragma mark-
#pragma mark MainFrameView实现

@implementation MainFrameView

+ (MainFrameView*)shareInstance
{
	static MainFrameView* _instance = NULL;
	if(!_instance)
	{
		_instance = [[MainFrameView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	}
	return _instance;
}

- (void)setViewColor:(UIView*)pView
{
	pView.backgroundColor = [UIColor clearColor];
	
	// for test
//	pView.backgroundColor = [UIColor brownColor];
	pView.layer.borderWidth = 4;
	pView.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
//	pView.alpha = 0.5;
}

- (id)initWithFrame:(CGRect)frame
{
	// 加载资源
//	initResource();
	
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		[self addViews];
		
		//[self setViewColor:self];
		[self addTitleView:@"MainFrame View"];
		
		//createGlobalEventConnection( @selector(didThemeChange), self, @selector(didThemeChange));///<监听全局切换主题的事件
		createGlobalEventConnection( @selector(willAnimateRotationToInterfaceOrientation:duration:), self, @selector(willAnimateRotationToInterfaceOrientation));
    }
    return self;
}

- (void)dealloc
{
	// 释放资源
	delResource();
	
	[self releaseObject];
    
    [super dealloc];
}

-(void)releaseObject
{
    [m_pBottomBarView release];
	m_pBottomBarView = nil;
    [m_pBackgroundView release];
	m_pBackgroundView = nil;
	
}

- (void)addViews
{
	[self addBottomBarView];
}

- (void)addBgView:(CGRect)frame
{
	
}

- (void)addBottomBarView
{
	CGRect rect = CGRectMake(0, 0, 320, 40);
	m_pBottomBarView = [[UIView alloc] initWithFrame:rect];
	m_pBottomBarView.backgroundColor = [UIColor blueColor];
	[self addSubview:m_pBottomBarView];
}

// =================================================================
#pragma mark-
#pragma mark 动画结束

// =================================================================
#pragma mark-
#pragma mark 
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	BOOL bTemp = NO;
	CGRect rect = [m_pBottomBarView bounds];
	CGPoint aPoint = [self convertPoint:point toView:m_pBottomBarView];
	bTemp = CGRectContainsPoint(rect, aPoint);
	
	return bTemp;
}

// =================================================================
#pragma mark-
#pragma mark 显示

- (void)showMainFrame:(UIView*)parentView
{
	[parentView addSubview:self];
	//CGRect frame = [parentView
	[self onChangeViewFrame: [[UIGlobal getRootView] frame]];
	
	// 更新工具栏
	[[BottomBarViewController shareInstance] updateToolBar:m_pBottomBarView withType:TB_COMMOM];
}

// =================================================================
#pragma mark-
#pragma mark 横/竖屏切换
- (void)willAnimateRotationToInterfaceOrientation
{
    [self onChangeViewFrame:[[UIGlobal getRootView] frame]];
}

-(void)onChangeViewFrame:(CGRect)superViewFrame
{
	CGRect selfFrame = superViewFrame;
	selfFrame.origin = CGPointZero;
	[self setFrame:selfFrame];
	
	int nBottomBarHeight = [[iUIAppFrame shareInstance] getCmdBarHeight];
	CGRect bounds = [self bounds];
	CGRect rect = CGRectMake(bounds.origin.x, bounds.size.height - bounds.origin.y - nBottomBarHeight, bounds.size.width, nBottomBarHeight);
	[m_pBottomBarView setFrame:rect];
	[[BottomBarViewController shareInstance] onChangeOfView];
}

@end


