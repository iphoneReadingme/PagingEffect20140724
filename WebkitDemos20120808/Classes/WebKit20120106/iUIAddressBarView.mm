//
//  iUIMediaRootView.mm
//  YFS_Sim111027_i42
//
//  Created by yangfs on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iUIWebKitMacroDefine.h"
#import "iUIAddressBarView.h"
#import "iUIWebViewManager.h"



// 工具栏按钮tag
enum
{
	TB_BTN_BACK,
	TB_BTN_GOFORWARD,
	TB_BTN_GO, ///< 打开网页
	TB_BTN_REFRESH, ///< 刷新当前页面
	TB_BTN_END,
};

// =================================================================
#pragma mark -
#pragma mark 实现iUIAddressBarView

@implementation iUIAddressBarView


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Initialization code.
		[self addViews];
	}
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
	[self releaseObject];
    [super dealloc];
}

//=====================================================================
-(void)releaseObject
{
}

-(void)addViews
{
	//CGRect selfFrame = [self frame];
	self.backgroundColor = [UIColor blueColor];
	self.layer.borderWidth = 2;
	self.layer.borderColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.0 alpha:1.0].CGColor;
	//[self createButtons];
}

// =================================================================
#pragma mark -
#pragma mark URL输入框
- (void)addURLTextField:(CGRect)frame
{
}

// =================================================================
#pragma mark -
#pragma mark 按钮及事件处理
-(UIButton*)createButton:(NSString*)title withTag:(int)tag
{
	UIButton* pBtn = nil;
	// 创建一个按钮
	//pBtn = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
	pBtn = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[pBtn setTitle:title forState:UIControlStateNormal];
	[pBtn setImage:nil forState:UIControlStateNormal];
	pBtn.tag = tag;
	[pBtn addTarget:self action:@selector(buttonsClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	
	return pBtn;
}

-(void)createButtons
{
	CGRect selfFrame = [self frame];
	CGRect btnRect = CGRectMake(kToolBarSpace, 0, kToolBarButtonWidth, kToolBarButtonHeight);
	btnRect.origin.y = (selfFrame.size.height - kToolBarButtonHeight)*0.5;
	
//	UIButton* pBtn = nil;
	
	// 添加"后退"按钮
//	pBtn = [self createButton:@"后退" withTag: TB_BTN_BACK];
//	[pBtn setFrame:btnRect];
//	[self addSubview:pBtn];
//	m_pBtnBack = pBtn;
//	[self setButtonStatus:m_pBtnBack with:NO];
	
//	btnRect.origin.x += btnRect.size.width + kToolBarSpace;
	// 添加"前进"按钮
//	pBtn = [self createButton:@"前进" withTag: TB_BTN_GOFORWARD];
//	[pBtn setFrame:btnRect];
//	[self addSubview:pBtn];
//	m_pBtnForward = pBtn;
//	[self setButtonStatus:m_pBtnForward with:NO];
	
//	btnRect.origin.x += btnRect.size.width + kToolBarSpace;
//	// 添加"前进"按钮
//	pBtn = [self createButton:@"Go" withTag: TB_BTN_GO];
//	[pBtn setFrame:btnRect];
//	[self addSubview:pBtn];
	
}

// 设置按钮状态
- (void)setButtonStatus:(UIButton*)pBtn with:(BOOL)bEnabled;
{
	pBtn.backgroundColor = bEnabled ? [UIColor redColor] : [UIColor grayColor];
	pBtn.enabled = bEnabled;
	
	BOOL bFlag = pBtn.enabled;
	bFlag = NO;
	NSString* pTitle = pBtn.titleLabel.text;
	pTitle = nil;
}

- (void)updateButtonsStatus
{
	BOOL bStatus = [[iUIWebViewManager sharedInstance] canGoBack];
	//[self setButtonStatus:m_pBtnBack with:bStatus];
	bStatus = [[iUIWebViewManager sharedInstance] canGoForward];
	//[self setButtonStatus:m_pBtnForward with:bStatus];
}

// 统一按钮的点击事件
-(void)buttonsClickEvent:(UIButton*)sender
{
	if (sender == nil)
	{
		return;
	}
	//BOOL bStatus = NO;
	int nTag = sender.tag;
	switch (nTag)
	{
		case TB_BTN_BACK:
		{
			[[iUIWebViewManager sharedInstance] goBack];
			[self updateButtonsStatus];
			
			break;
		}
		case TB_BTN_GOFORWARD:
		{
			[[iUIWebViewManager sharedInstance] goForward];
			//sender.enabled = [[iUIWebViewManager sharedInstance] canGoForward];
			[self updateButtonsStatus];
			break;
		}
		case TB_BTN_GO:
		{
			[[iUIWebViewManager sharedInstance] startNewRequest:@"http://3g.sina.com.cn"];
			break;
		}
		case TB_BTN_END:
		{
			break;
		}
		default:
		{
			WKMD_LOG_NSAssert(false, @"==事件出错==");
			break;
		}
	}
}


// =================================================================
#pragma mark -
#pragma mark 

// =================================================================
#pragma mark -
#pragma mark 手势相关




// =================================================================
#pragma mark -
#pragma mark 


// =================================================================
#pragma mark -
#pragma mark 


@end

// =================================================================
#pragma mark -
#pragma mark 文件尾

