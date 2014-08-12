

#import <UIKit/UIKit.h>
#import "UIViewBottomBarMacroDef.h"
//#import "NSObject_Event.h"
#import "InterfaceToolBarView.h"
#import "CommonToolBarView.h"
#import "BottomBarViewController.h"
#import "FullScreenController.h"



@interface  BottomBarViewController(BottomBarViewController_private)

- (void)releaseObject;
// 处理按钮点击事件
-(void)onButtonClickEvent:(UIButton*)sender;

@end

// =================================================================
#pragma mark-
#pragma mark BottomBarViewController实现

@implementation BottomBarViewController

+ (BottomBarViewController*)shareInstance
{
	static BottomBarViewController* _instance = NULL;
	if(!_instance)
	{
		_instance = [[BottomBarViewController alloc] init];
	}
	return _instance;
}

- (id)init
{
    if (self = [super init])
	{
		m_lastToolBarType = TB_UNKNOWN;
	}
	return self;
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	SAFE_DELETE_NSOBJECT(m_pCurToolBar);
}

// =================================================================
#pragma mark-
#pragma mark --

- (int)getCmdBarHeight
{
	return 40;
}

- (void)updateToolBar:(UIView*)pParentView withType:(ToolBarType)curType
{
	CGRect bounds = [pParentView bounds];
	if (m_lastToolBarType == curType)
	{
		return;
	}
	else
	{
		[m_pCurToolBar removeFromSuperview];
		SAFE_DELETE_NSOBJECT(m_pCurToolBar);
	}
	
	switch (curType)
	{
		case TB_COMMOM:
		{
			m_pCurToolBar = [[CommonToolBarView alloc] initWithFrame:bounds];
			[pParentView addSubview:m_pCurToolBar];
			break;
		}
		
		default:
		{
			break;
		}
	}
	
//	createEventConnection(m_pCurToolBar, @selector(onButtonClickEvent:), self, @selector(onButtonClickEvent:));
	
}

// 切换窗口
- (void)onChangeOfView
{
	CGRect bounds = [[m_pCurToolBar superview] bounds];
	[m_pCurToolBar setFrame:bounds];
	[m_pCurToolBar onChangeOfView];
}

// 处理按钮点击事件
-(void)onButtonClickEvent:(UIButton*)sender
{
	int nTag = sender.tag;
	switch(nTag)
	{
		case BTN_TAG_ENTER_FULLSCREEN:
		{
			// 进入全屏
			if ([[FullScreenController shareInstance] isFullScreen])
			{
				[[FullScreenController shareInstance] exitFullScreenAnimated:YES];
			}
			else
			{
				[[FullScreenController shareInstance] enterFullScreenAnimated:YES];
			}
			break;
		}
		case BTN_TAG_EXIT_FULLSCREEN:
		{
			// 退出全屏
			[[FullScreenController shareInstance] exitFullScreenAnimated:YES];
			break;
		}
		case BTN_TAG_APPFSBB_EXIT:
		{
			NSLog(@"\n\n====== Demo Exist ======");
			exit(1);
		}
		case BTN_TAG_FLASH_PLAY_RETURN:
		{
//			emitEvent(nil, @selector(popViewController));
			break;
		}
			
		default:
			break;
	}
}

@end
