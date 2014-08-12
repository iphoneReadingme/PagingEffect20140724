
//#import "ResManager.h"
//#import "NSObject_Event.h"
#import "UIViewBottomBarMacroDef.h"
#import "CommonToolBarView.h"



///< 默认状态的按钮数据
static const BottombarItem g_defStatebuttons[] =
{
    @"ButtonFullScreen", @"SystemMenu/FullScreenMode", BTN_TAG_ENTER_FULLSCREEN, 0,
	// 退出按钮
    @"ButtonExitApp", @"SystemMenu/QuitUC", BTN_TAG_APPFSBB_EXIT, 0,
	
	// "返回"按钮
    @"ButtonReturn", @"Common/Back", BTN_TAG_FLASH_PLAY_RETURN, 0,
};

static const BottombarItem g_FullScreenStatebuttons[] =
{
    @"ButtonQuitFullScreen", @"SystemMenu/QuitFullScreen", BTN_TAG_EXIT_FULLSCREEN, 0,
	// "返回"按钮
    @"ButtonReturn", @"Common/Back", BTN_TAG_FLASH_PLAY_RETURN, 0,
};


@interface  CommonToolBarView(CommonToolBarView_private)

- (void)releaseObject;

@end


@implementation CommonToolBarView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
		[self createAllButtons];
		
		// for test
		//self.backgroundColor = [UIColor brownColor];
		//self.layer.borderWidth = 4;
		//self.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0].CGColor;
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
	SAFE_DELETE_NSOBJECT(m_fullScreenBtn);
	SAFE_DELETE_NSOBJECT(m_ExitAppBtn);
	SAFE_DELETE_NSOBJECT(m_returnButton);
    
}

// =================================================================
#pragma mark-
#pragma mark 创建按钮

// 文件管理界面底部工具栏都只有两个按钮, 目前以这种方式创建比较简单
- (void)createAllButtons
{
	BottombarItem* barItem = nil;
	UIButton* pBtn = nil;
	
	//CGRect btnRect = CGRectMake(0, 0, 40, 64);
	int nIndex = 0;
	// "全屏"按钮
	barItem = (BottombarItem*)&g_defStatebuttons[nIndex++];
	pBtn = [self createButton:barItem->m_nBtnTag withName:barItem->m_btnName withTitle:@"全屏"];
	m_fullScreenBtn = pBtn;
	[m_fullScreenBtn retain];
	[pBtn release];
	
	// "退出"按钮
	barItem = (BottombarItem*)&g_defStatebuttons[nIndex++];
	pBtn = [self createButton:barItem->m_nBtnTag withName:barItem->m_btnName withTitle:@"退出"];
	m_ExitAppBtn = pBtn;
	[m_ExitAppBtn retain];
	[pBtn release];
	
	
	// "返回"按钮
	barItem = (BottombarItem*)&g_defStatebuttons[nIndex++];
	pBtn = [self createButton:barItem->m_nBtnTag withName:barItem->m_btnName withTitle:@"返回"];
	m_returnButton = pBtn;
	[m_returnButton retain];
	[pBtn release];
	
	[self onChangeOfButtons];
	[self refreshAllButtons];
}

// =================================================================
#pragma mark-
#pragma mark 设置按钮属性

// 切换皮肤
- (void)didThemeChange
{
	[self setBgImageView];
	[self refreshAllButtons];
}

- (void)refreshAllButtons
{
	[self setButtonProperty:m_fullScreenBtn];
	[self setButtonProperty:m_ExitAppBtn];
	[self setButtonProperty:m_returnButton];
}

// 切换窗口
- (void)onChangeOfView
{
	[super onChangeOfView];
	[self onChangeOfButtons];
}

// 调整按钮位置
- (void)onChangeOfButtons
{
	CGRect selfFrame = self.bounds;
    //int btnWidth = selfFrame.size.width / 5;
	int btnWidth = [self getButtonWidth];
	CGRect btnRect = CGRectMake(kButtonMarginLeftAndRight, 0, btnWidth, selfFrame.size.height);
	
	
	// "全屏"按钮
	btnRect.origin.x = kButtonMarginLeftAndRight;
	[m_fullScreenBtn setFrame:btnRect];
	
	// "退出"按钮
	btnRect.origin.x = btnRect.size.width + kButtonMarginLeftAndRight;
	[m_ExitAppBtn setFrame:btnRect];
	
	// "返回"按钮
	btnRect.origin.x = selfFrame.size.width - btnWidth - kButtonMarginLeftAndRight;
	[m_returnButton setFrame:btnRect];
}

// =================================================================
#pragma mark-
#pragma mark 按钮事件处理

- (void)onButtonClickEvent:(UIButton*)sender
{
//    emitEvent(self, @selector(onButtonClickEvent:), sender);
}


@end
