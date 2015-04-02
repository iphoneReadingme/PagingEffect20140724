
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: MCPromptBoxTestController.mm
 *
 * Description	: MCPromptBoxTestController (测试)
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-03-31.
 * History		: modify: 2015-03-31.
 ******************************************************************************
 **/

#import "MCPromptBoxTestHead.h"

#ifdef Enable_Test_Prompt_Box_MCPromptBoxTestController

#import "MCPromptBoxTestView.h"
#import "MCPromptBoxTestController.h"


///< 私有方法
@interface MCPromptBoxTestController()

@property (nonatomic, retain) MCPromptBoxTestView* testViewObj;

- (void)releaseObject;

@end

static MCPromptBoxTestController* testController = nil;

@implementation MCPromptBoxTestController


+ (void)showTestView
{
	if (testController == nil)
	{
		testController = [[MCPromptBoxTestController alloc] init];
	}
}

+ (void)releaseSelf
{
	if (testController)
	{
		[testController release];
		testController = nil;
	}
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	[_testViewObj release];
	_testViewObj = nil;
}

- (instancetype)init
{
	if (self = [super init])
	{
		[self addSubViewObject];
	}
	
	return self;
}

#pragma mark -
#pragma mark 子视图对象

- (UIView*)getRootView
{
	extern UIView* g_rootView;
	return g_rootView;
}

- (void)addSubViewObject
{
	CGRect rect = [[self getRootView] bounds];
	rect = CGRectMake(100, 100, kTestViewWidth, kTestViewHeight);
	
	_testViewObj = [[MCPromptBoxTestView alloc] initWithFrame:rect];
	[[self getRootView] addSubview:_testViewObj];
}


@end

#endif
