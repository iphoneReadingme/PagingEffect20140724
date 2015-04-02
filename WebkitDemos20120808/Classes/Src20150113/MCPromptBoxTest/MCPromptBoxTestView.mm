
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: MCPromptBoxTestView.mm
 *
 * Description	: MCPromptBoxTestView (测试)
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-03-31.
 * History		: modify: 2015-03-31.
 ******************************************************************************
 **/


#import "MCPromptBoxTestHead.h"

#ifdef Enable_Test_Prompt_Box_MCPromptBoxTestController


//#import "MessageCenterModel.h"
//#import "MCPromptMockDataProvider.h"
//#import "ThemeManager.h"
//#import "MCController+PromptBox.h"
//#import "HonorMedalController.h"

#import "MCPromptBoxPanView.h"
#import "MCPromptBoxTestView.h"


@interface MCPromptBoxTestView()

@property (nonatomic, retain) MCPromptBoxPanView*   panView;

@end


@implementation MCPromptBoxTestView

+ (UIView*)getMainView
{
	extern UIView* g_rootView;
	return g_rootView;
}


- (void)forTest
{
	// for test
	self.backgroundColor = [UIColor grayColor];
	self.layer.borderWidth = 2;
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		self.backgroundColor = [UIColor clearColor];
		[self forTest];
		[self addSubViews:frame];
		
		[self addPanViewObj];
		self.alpha = 0.5f;
	}
	return self;
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

-(void)releaseObject
{
	[_panView release];
	_panView = nil;
}

- (void)addSubViews:(CGRect)frame
{
	CGSize size = frame.size;
	size.height = size.height*2;
	self.contentSize = size;
	
	[self addButtons];
}

- (void)addPanViewObj
{
	CGRect rect = [self bounds];
	rect.origin.x += rect.size.width - 20;
	rect.size.width = 20;
	MCPromptBoxPanView* pView = [[MCPromptBoxPanView alloc] initWithFrame: rect];
	
	[self addSubview:pView];
	_panView = pView;
}

- (void)addBgView:(CGRect)frame
{
	UIView* pView = [[[UIView alloc] initWithFrame:frame] autorelease];
	pView.backgroundColor = [UIColor whiteColor];
	[self addSubview:pView];
}

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
	
	UIColor* color = [UIColor whiteColor];
	[button setTitleColor:color forState:UIControlStateNormal];
	color = [UIColor blueColor];
	[button setTitleColor:color forState:UIControlStateHighlighted];
	
	button.layer.borderWidth = 2;
	button.layer.borderColor = [UIColor redColor].CGColor;
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	[self addSubview:button];
	
	return button;
}

- (void)addButtons
{
#define kYSpace     10
	CGRect frame = [self bounds];
	frame.origin = CGPointZero;
	CGRect btnRect = CGRectMake(0, 0, 80, 44);
	int nIndex = 1;
	UIButton* pBtn = nil;
	
	// "添加联系人"按钮
	//btnRect.origin.y += kYSpace + btnRect.size.height;
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"显示勋章"];
	[pBtn setFrame:btnRect];
	
	nIndex = 2;
	// "显示联系人"按钮
	btnRect.origin.y += kYSpace + btnRect.size.height;
	pBtn = [self createButton:nIndex withName:@"UIButtonTest2" withTitle:@"消息提示框"];
	[pBtn setFrame:btnRect];
	
	
	nIndex = 3;
	// "清空联系人"按钮
	btnRect.origin.y += kYSpace + btnRect.size.height;
	pBtn = [self createButton:nIndex withName:@"UIButtonTest2" withTitle:@"日夜间切换"];
	[pBtn setFrame:btnRect];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	NSInteger nTag = sender.tag;
	if (nTag == 1)
	{
		[self showGetBookMedalGuide];
		[self addPersons];
	}
	else if (nTag == 2)
	{
		[self showPromptBox];
		[self showPersons];
	}
	else if (nTag == 3)
	{
		[self switchDayNightMode];
		[self clearAllPersons];
	}
}

- (void)clearAllPersons
{
}

- (void)addPersons
{
}

- (void)showPersons
{
}

- (void)showGetBookMedalGuide
{
//	[[HonorMedalController sharedInstance] showGetBookMedalGuide];
}

- (void)showPromptBox
{
	///< for test
//	MessageCenterItem* dataItem = [MCPromptMockDataProvider getMCPushDataItem];
//	[[MCController sharedInstance] showPromptBox:dataItem];
}

- (void)switchDayNightMode
{
//	[[ThemeManager sharedInstance] switchDayNightMode:NO];
}

@end


#endif
