
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
#import "NSMutableArray+ExceptionSafe.h"



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
		NSString* message = @"月落乌啼霜[U+1版本352]满天，\n江枫渔火对[U+1F353]愁眠；\n姑苏[U+[U+1f352]城外寒山寺，\n夜半钟声到客船。\n当前版本过旧，可能会造成系统不稳定。建议立即[U+1F353]升级。\n/Users/yangfs/Library/Developer/CoreSimulator/Devices/2B9D9536-908B-46E7-9D1F-75065EF6372D/data/Containers/Bundle/Application/E6360C6C-F95F-4CD6-80A5-0ABD3702F76B/UCWEB.app";
		[self handleDecodeEmojiCharsWith:message];
		[self handleDecodeEmojiCharsWith:@"月落乌啼霜[U+1F352]满天"];
		[self handleDecodeEmojiCharsWith:@"月落乌[U+1F352]啼霜[U+1F352]满天"];
		[self handleDecodeEmojiCharsWith:@"月落乌啼霜[U+1满352]满天"];
		[self handleDecodeEmojiCharsWith:@"月落乌啼霜[U+1A352]满天"];
		[self handleDecodeEmojiCharsWith:@"江枫渔火对U+1F353愁眠"];
		[self handleDecodeEmojiCharsWith:@"下次再说[U+1F60D]"];
		[self handleDecodeEmojiCharsWith:@"立即[U+1F353]升级"];
		[self handleDecodeEmojiCharsWith:@"立即[U+U+11F353]升级"];
		//[self uicodeTest];
		_bNeedsShowEmojiView = NO;
//		connectGlobalEvent(@selector(willAnimateRotationToInterfaceOrientation:duration:), self, @selector(willAnimateRotationToInterfaceOrientation:duration:));
	}
	
	return self;
}

#define _DEBUG

#define kEmojiCoderPrefixKey                               @"[U+"
#define kSeparatorKey                                      @"$*$*"

///< 处理字符串的特殊的编码字符
- (NSString*)handleDecodeEmojiCharsWith:(NSString*)srcText
{
	NSString* dest = srcText;
	
	do
	{
		if ([srcText length] < 1)
		{
			break;
		}
		
		NSMutableArray* array = [self componentsWith:srcText separatedByString:kSeparatorKey];
		if ([array count] < 1)
		{
			break;
		}
		
		NSMutableArray* newArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		
		for (NSString* subString in array)
		{
			subString = [self handleFirstEmojiCharWith:subString];
			
			if ([subString length] < 1)
			{
				continue;
			}
			
			[newArray safe_AddObject:subString];
		}
		
		if ([newArray count] > 0)
		{
			dest = [newArray componentsJoinedByString:@""];
		}
		
	}while (0);
	
	return dest;
}

- (NSMutableArray *)componentsWith:(NSString *)srcText separatedByString:(NSString*)separator
{
	NSMutableArray* newArray = nil;
	
	do
	{
		if ([srcText length] < 1)
		{
			break;
		}
		
		NSString* target = kEmojiCoderPrefixKey;
		NSString* replacement = [NSString stringWithFormat:@"%@%@", separator, target];
		srcText = [srcText stringByReplacingOccurrencesOfString:target withString:replacement];
		
		NSArray* array = [srcText componentsSeparatedByString:separator];
		if ([array count] < 1)
		{
			break;
		}
		
		if (newArray == nil)
		{
			newArray = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
		}
		
		for (NSString* subString in array)
		{
			if ([subString length] < 1)
			{
				continue;
			}
			
			[newArray safe_AddObject:subString];
		}
		
		if ([newArray count] < 1)
		{
			newArray = nil;
		}
		
	}while (0);
	
	return newArray;
}

///< 只解释最先扫描到的表情编码字符
- (NSString*)handleFirstEmojiCharWith:(NSString*)srcText
{
	NSString* dest = srcText;
	
	do
	{
		if ([dest length] < 1)
		{
			break;
		}
		
		NSString* key = kEmojiCoderPrefixKey;
		NSRange rangeStart = [srcText rangeOfString:key options:NSCaseInsensitiveSearch];
		if (rangeStart.location == NSNotFound)
		{
			break;
		}
		
		NSRange rangeEnd = [srcText rangeOfString:@"]" options:NSCaseInsensitiveSearch];
		if (rangeEnd.location == NSNotFound)
		{
			break;
		}
		
		if (rangeStart.location >= rangeEnd.location)
		{
			break;
		}
		
		NSString* emojiChar = nil;
		
		NSInteger length = (int)(rangeEnd.location - rangeStart.location - [key length]);
		
		if (length == 4 || length == 5) ///< 编码字符长度只能为4或者5，其余都认为不是表情字符编码
		{
			NSRange range = NSMakeRange(rangeStart.location + [key length], length);
			NSString* encodeText = [srcText substringWithRange:range];
			emojiChar = [self convertUnicodeToEmoji:encodeText];
		}
		
		if ([emojiChar length] > 0)
		{
			NSRange range = NSMakeRange(rangeStart.location, rangeEnd.location - rangeStart.location + 1);
			dest = [srcText stringByReplacingCharactersInRange:range withString:emojiChar];
		}
		else
		{
			break;
		}
		
	}while (0);
	
	return dest;
}

/*
 * 函数作用是将 带有[U+1F60D]格式的表情编码 转换为ios平台的表情字符
 * 如：U+1F60D 转换为 😍
 **/

- (NSString *)convertUnicodeToEmoji:(NSString *)inputStr
{
	NSString* emojiChar = nil;
	if ([self isValidUnicodeText:inputStr])
	{
		unsigned long unicodeIntValue= strtoul([inputStr UTF8String],0,16);
		UTF32Char inputChar = unicodeIntValue; // 变成utf32
		inputChar = NSSwapHostIntToLittle(inputChar); // 转换成Little 如果需要
		
		emojiChar = [[NSString alloc] initWithBytes:&inputChar length:sizeof(inputChar) encoding:NSUTF32LittleEndianStringEncoding];
		[emojiChar autorelease];
	}
	
	return emojiChar;
}

///< 编码字符的合法性测试
- (BOOL)isValidUnicodeText:(NSString*)inputStr
{
	BOOL isValid = YES;
	
	for(int i = 0; i < [inputStr length]; i++)
	{
		unichar c = [inputStr characterAtIndex:i];
		
		if( !(('0' <= c && c <= '9') || ('A' <= c &&  c <= 'F') || ('a' <= c &&  c <= 'f')))
		{
			isValid = NO;
			break;
		}
	}
	
	return isValid;
}

- (void)uicodeTest
{
#ifdef _DEBUG
	NSString *smiley = @"😄";
	NSData *data = [smiley dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
	uint32_t unicode;
	[data getBytes:&unicode length:sizeof(unicode)];
	NSLog(@"%x", unicode);
	// Output: 1f604
	
	unicode = 0x1f604;
	unicode = 0x2702;
	
	smiley = [[NSString alloc] initWithBytes:&unicode length:sizeof(unicode) encoding:NSUTF32LittleEndianStringEncoding];
	NSLog(@"%@", smiley);
	// Output: 😄
	
	NSString *uniText = @"💘🏮😘🌟😍😄";
	NSDictionary* jsonDict = @{@"title":uniText};
	NSLog(@"jsonDict: %@", jsonDict);
	
	uint32_t buffer[10] = {0};
	data = [uniText dataUsingEncoding:NSUTF32LittleEndianStringEncoding];
	[data getBytes:buffer length:sizeof(buffer)];
	
	NSString* test = [self convertSimpleUnicodeStr:@"U+1F591"];
	test = nil;
#endif
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

