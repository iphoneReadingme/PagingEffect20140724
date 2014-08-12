
//#include "stdafx.h"
//#import "iUCTools.h"
#import "InterfaceToolBarView.h"
//#import "ResManager.h"
//#import "NSObject_Event.h"
#import "UIViewBottomBarMacroDef.h"



@implementation InterfaceToolBarView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        createGlobalEventConnection( @selector(didThemeChange), self, @selector(didThemeChange));///<监听全局切换主题的事件
		
		[self addBgImageView];
		
		// for test
		//self.backgroundColor = [UIColor brownColor];
		//self.layer.borderWidth = 4;
		//self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
    }
    return self;
}

- (void)dealloc
{
    [self releaseImagView];
	
	[super dealloc];
}

- (void)releaseImagView
{
	[m_shadowImgView release];
	m_shadowImgView = nil;
	
	[m_bgImageView release];
	m_bgImageView = nil;
}

// =================================================================
#pragma mark-
#pragma mark 背景视图

- (void)addBgImageView
{
	m_bgImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
	m_bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	///>背景阴影效果
	m_shadowImgView = [[UIImageView alloc] initWithImage:nil];
	[m_bgImageView addSubview:m_shadowImgView];
	
	[self setBgImageView];
	[self addSubview:m_bgImageView];
}

- (void)setBgImageView
{
//    m_bgImageView.image = resGetImage(kToolBarBackgroundImage);
//	m_shadowImgView.image = resGetImage(kToolBarShadowImage);
}

// =================================================================
#pragma mark-
#pragma mark 创建按钮

- (UIButton*)createButton:(int)nTag withName:(NSString*)pStrName withTitle:(NSString*)pTitle
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
	[button addTarget:self action:@selector(onButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = nTag;
	button.accessibilityLabel = pStrName;
	[button setTitle:pTitle forState:UIControlStateNormal];
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	[self addSubview:button];
	[button retain];
	
	return button;
}

- (void)createAllButtons
{
}

// =================================================================
#pragma mark-
#pragma mark 设置按钮属性

// 切换窗口
- (void)onChangeOfView
{
	// ToDo:
	[m_bgImageView setFrame:[self bounds]];
	CGRect rect = m_bgImageView.bounds;
	rect.origin.y = 0;
	rect.size.height = m_shadowImgView.image.size.height;
	[m_shadowImgView setFrame:rect];
}

// 调整按钮位置
- (void)onChangeOfButtons
{
	
}

// 切换皮肤
- (void)didThemeChange
{
	[self setBgImageView];
	[self refreshAllButtons];
}

- (void)refreshAllButtons
{
	// ToDo:
}

- (void)setButtonProperty:(UIButton*)pBtn
{
//	UIImage * btnBkImage = resGetImage(kButtonBgImage);
//	UIColor * titleColor = resGetColor(kBtnTitleColorNormal);
//    UIColor * highlightColor = resGetColor(kBtnTitleColorHighlight);
//	UIColor * disableColor = resGetColor(kBtnTitleColorDisable);
//	titleColor = [UIColor redColor];
//	[pBtn setTitleColor:titleColor forState:UIControlStateNormal];
//    [pBtn setTitleColor:highlightColor forState:UIControlStateHighlighted];
//	[pBtn setTitleColor:disableColor forState:UIControlStateDisabled];
//	[pBtn setBackgroundImage:btnBkImage forState:UIControlStateHighlighted];	///<按钮背景图片
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	// ToDo:
}

- (void)setButtonEnable:(BOOL)bEnable withTag:(int)nTag
{
	// ToDo:
}

///< 设置按钮宽度时统一调用此接口,方便维护
- (int)getButtonWidth
{
	return kButtonWidth;
}


///< 底部工具栏按钮点击事件统计表
// 目前只发现书签界面部分按钮事件有统计
static const BottombarItem g_buttonEventCountTable[] =
{
	nil, nil, 0, 0,
//	nil, nil, Btn_Tag_BM_EditBookMark, UC_CMD_IPHONE_FAV_EDIT, // 书签编辑
//	nil, nil, Btn_Tag_BM_BookMarkSynchro, UC_CMD_IPHONE_FAV_SYNC,// 书签同步
//	nil, nil, Btn_Tag_BM_AddBookMark, UC_CMD_IPHONE_FAV_NEW, // 添加书签
//	nil, nil, Btn_Tag_BM_AddDirectory, UC_CMD_IPHONE_FAV_NEW_FOLDER, // 添加目录
};

///< 底部工具上部分按钮点击事件统计功能
- (void)buttonClickCount:(int)nTag
{
	int nCount = (sizeof(g_buttonEventCountTable) / sizeof(g_buttonEventCountTable[0]));
	int nCmdId = 0;
	for (int i = 0; i < nCount; ++i)
	{
		if (nTag == g_buttonEventCountTable[i].m_nBtnTag)
		{
			nCmdId = g_buttonEventCountTable[i].m_cmdID;
			break;
		}
	}
	//MUIOnPopMenuOperation(nCmdId, nil);		///< 统计底部工具栏的操作次数
}

@end
