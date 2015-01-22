
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
//#import "NSObject_Event.h"



@interface FEEmojiViewController ()<FEEmojiViewDelegate>

@property (nonatomic, retain) FEParameterDataProvider *dataProvider;
@property (nonatomic, retain) FEEmojiParameterInfo *emojiInfo;
@property (nonatomic, retain) FEEmojiView *emojiView;

@property (nonatomic, assign) BOOL isAnimation;    ///< 正在执行动画
@property (nonatomic, assign) BOOL bNeedsShowEmojiView;    ///< 只有通过搜索词触发，才可以显示

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
//#define _DEBUG
#ifdef _DEBUG
		NSString *smiley = @"😄";
		NSData *data = [smiley dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
		uint32_t unicode;
		[data getBytes:&unicode length:sizeof(unicode)];
		NSLog(@"%x", unicode);
		// Output: 1f604
		
		unicode = 0x1f604;
		
		smiley = [[NSString alloc] initWithBytes:&unicode length:sizeof(unicode) encoding:NSUTF32LittleEndianStringEncoding];
		NSLog(@"%@", smiley);
		// Output: 😄
		
		NSString *uniText = @"💘🏮😘🌟😍😄";
		NSDictionary* jsonDict = @{@"title":uniText};
		NSLog(@"jsonDict: %@", jsonDict);
		
		uint32_t buffer[10] = {0};
		data = [uniText dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
		[data getBytes:buffer length:sizeof(buffer)];
#endif
		
		_bNeedsShowEmojiView = NO;
//		connectGlobalEvent(@selector(willAnimateRotationToInterfaceOrientation:duration:), self, @selector(willAnimateRotationToInterfaceOrientation:duration:));
	}
	
	return self;
}

- (void)dealloc
{
//	disconnectAllEvent(self);
	
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

///< 节日匹配
- (void)matchFestivalByKeyWord:(NSString*)keyWord
{
#ifdef _Enable_Hardcode_keyword
	keyWord = [self getTestKewWord];
#endif
	
	if ([keyWord length] > 0)
	{
		BOOL bFind = NO;
		if (_emojiInfo != nil)
		{
			NSRange rang = [keyWord rangeOfString:[_emojiInfo searchKeyWord]];
			
			bFind = (rang.location != NSNotFound);
		}
		
		if (!bFind)
		{
			[self releaseEmojiInfo];
			[self loadData];
			
			self.emojiInfo = [_dataProvider getFestivalEmojiParameterInfoByKeyWord:keyWord];
			self.emojiInfo.searchKeyWord = keyWord;
		}
		_bNeedsShowEmojiView = YES;
	}
}

- (void)showEmojiView:(UIView*)parentView
{
	if (_isAnimation || !_bNeedsShowEmojiView)
	{
		return;
	}
	
	_bNeedsShowEmojiView = NO;
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
	}
}

#pragma mark - Rotation Support

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	[self onChangeFrame];
}

- (void)onChangeFrame
{
	CGRect bounds = [[_emojiView superview] bounds];
	[_emojiView setFrame:bounds];
	
	[_emojiView onChangeFrame];
}

#pragma mark - ==动画显示和隐藏
///< 显示
- (void)showAnimation
{
	[_emojiView performSelector:@selector(show3DAnimation) withObject:nil afterDelay:0.0f];
}

- (void)hiddenAnimationDidFinished
{
	[self performSelector:@selector(releaseEmojiView) withObject:nil afterDelay:0.0f];
	
	_isAnimation = NO;
}

- (void)loadData
{
	if (_dataProvider == nil)
	{
		_dataProvider = [[FEParameterDataProvider alloc] init];
	}
	else
	{
		///< 判断时间，如果已经是隔天
		[_dataProvider loadDataWith:YES];
	}
}

#ifdef _Enable_Hardcode_keyword
- (NSString*)getTestKewWord
{
	NSString* keyWord = nil;
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
	return keyWord;
}
#endif

@end

