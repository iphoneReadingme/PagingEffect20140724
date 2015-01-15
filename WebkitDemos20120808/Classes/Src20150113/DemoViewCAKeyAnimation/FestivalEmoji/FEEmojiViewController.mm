
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiViewController.mm
 *
 * Description  : 节日表情图标视图接口控制器
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/


#import "FEEmojiView.h"
#import "FEEmojiViewController.h"
#import "FEParameterDataProvider.h"


///< for test
#define _Enable_Hardcode_keyword



@interface FEEmojiViewController ()<FEEmojiViewDelegate>

@property (nonatomic, retain) FEParameterDataProvider *dataProvider;
@property (nonatomic, retain) FEEmojiParameterInfo *emojiInfo;
@property (nonatomic, retain) FEEmojiView *emojiView;

@property (nonatomic, assign) BOOL bDidHiddenEmojiView;
@property (nonatomic, assign) BOOL isAnimation;    ///< 正在执行动画

@end


@implementation FEEmojiViewController

+ (FEEmojiViewController*)sharedInstance
{
	static id sharedInstance = nil;
	static dispatch_once_t onceToken = 0;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init
{
	if (self = [super init])
	{
		[self loadData];
	}
	
	return self;
}

- (void)dealloc
{
	[self releaseEmojiView];
	[self releaseDataProvider];
	
	[self releaseEmojiInfo];
	
	[super dealloc];
}

- (void)releaseEmojiView
{
	_emojiView.delegate = nil;
	if ([_emojiView superview])
	{
		[_emojiView removeFromSuperview];
	}
	[_emojiView release];
	_emojiView = nil;
}

- (void)releaseEmojiInfo
{
	[_emojiInfo release];
	_emojiInfo = nil;
}

- (void)releaseDataProvider
{
	[_dataProvider release];
	_dataProvider = nil;
}

- (void)loadData
{
	if (_dataProvider == nil)
	{
		_dataProvider = [[FEParameterDataProvider alloc] init];
	}
}

///< 节日匹配
- (void)matchFestivalByKeyWord:(NSString*)keyWord
{
#ifdef _Enable_Hardcode_keyword
	static int nType = 0;
	
	nType++;
	if (nType >= FEEITypeMaxCount)
	{
		nType = 1;
	}
	
	if (FESCTypeOne == nType)
	{
		keyWord = @"春节";
	}
	else if (FESCTypeTwo == nType)
	{
		keyWord = @"情人节";
	}
	else if (FESCTypeThree == nType)
	{
		keyWord = @"元宵";
	}
#endif
	
	if ([keyWord length] > 0)
	{
		self.emojiInfo = [_dataProvider getFestivalEmojiParameterInfoByKeyWord:keyWord];
	}
}

- (void)showEmojiView:(UIView*)parentView
{
	if (_isAnimation)
	{
		return;
	}
	
	if ([_emojiInfo bRepeat])
	{
		[self addEmojiView:parentView With:_emojiInfo];
		
		if (_emojiView != nil)
		{
			_isAnimation = YES;
			[self showAnimation];
		}
	}
}

- (void)addEmojiView:(UIView*)parentView With:(FEEmojiParameterInfo*)emojiInfo
{
	[self releaseEmojiView];
	
	if (emojiInfo != nil)
	{
		CGRect bounds = [parentView bounds];
		_emojiView = [[FEEmojiView alloc] initWithFrame:bounds withData:_emojiInfo];
		_emojiView.delegate = self;
		[parentView addSubview:_emojiView];
		_emojiView.alpha = 0.0f;
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	[self onChangeFrame];
}

- (void)onChangeFrame
{
	CGRect bounds = [[_emojiView superview] bounds];
	[_emojiView setFrame:bounds];
	
	[_emojiView onChangeFrame];
}

- (void)didThemeChange
{
	[_emojiView didThemeChange];
}

#pragma mark - ==动画显示和隐藏
///< 显示
- (void)showAnimation
{
	[_emojiView performSelector:@selector(show3DAnimation) withObject:nil afterDelay:0.0f];
}

- (void)hiddenAnimationDidFinished
{
	_bDidHiddenEmojiView = YES;
	_isAnimation = NO;
	
	[self releaseEmojiInfo];
	
	[self performSelector:@selector(releaseEmojiView) withObject:nil afterDelay:0.0f];
}

@end

