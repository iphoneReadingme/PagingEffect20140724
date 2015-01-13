
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiView.mm
 *
 * Description  : 节日表情图标视图
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/


//#import "UCUIKit/UCUIKit.h"
#import "FEEmojiView.h"
#import "FEEmojiViewMacroDefine.h"



@interface FEEmojiView ()

@property (nonatomic, retain) FEEmojiParameterInfo* parameterInfo;   ///< 表情图标参数信息

@end


@implementation FEEmojiView

- (void)forTest
{
	// for test
	self.backgroundColor = [UIColor brownColor];
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame withData:(FEEmojiParameterInfo*)parameterInfo
{
	frame.origin.x = 0;
	frame.origin.y = frame.size.width*0.25;
	frame.size.width *= 0.5;
	frame.size.height *= 0.5;
	frame.size.width = 320;
	frame.size.height = 320;
	
    if (self = [super initWithFrame:frame])
	{
		[self forTest];
//		self.backgroundColor = [UIColor grayColor];
		self.parameterInfo = parameterInfo;
		
		[self addLabels:parameterInfo];
    }
	
    return self;
}

- (void)dealloc
{
	[_parameterInfo release];
	_parameterInfo = nil;
	
	[super dealloc];
}

- (void)addLabels:(FEEmojiParameterInfo*)parameterInfo
{
	for (NSString* temp in parameterInfo.coordinateArray)
	{
		CGPoint pt = CGPointFromString(temp);
		pt = [self getPointWith:pt with:0.5f];
		CGRect rect = CGRectMake(pt.x, pt.y, 32, 32);
		[self addLabelView:parameterInfo with:rect];
	}
}

- (void)addLabelView:(FEEmojiParameterInfo*)parameterInfo with:(CGRect)frame
{
	UILabel* titleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
	titleLabel.font = [UIFont systemFontOfSize:parameterInfo.fontSize*[self getUIScale]];
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.backgroundColor = [UIColor clearColor];
//	titleLabel.backgroundColor = [UIColor whiteColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = parameterInfo.emojiChar;
	
	frame.size = [FEEmojiView getConstrainedToSize:titleLabel with:[self frame].size.width];
	[titleLabel setFrame:frame];
	
	[self addSubview:titleLabel];
}

- (CGFloat)getUIScale
{
	return [self getUISizeScale];
}

- (CGFloat)getUISizeScale
{
	static CGFloat fUIScale = 1.0f;
	
	///< 如果是iphone6 plus, 比例为1.15
//	if ([UCUIGlobal is55inchDisplay])
	{
//		fUIScale = 1.15;
	}
	
	return fUIScale;
}

- (CGPoint)getPointWith:(CGPoint&)pt with:(CGFloat)scale
{
	pt.x *= scale*[self getUIScale];
	pt.y *= scale*[self getUIScale];
	
	return pt;
}

- (CGRect)getRectWith:(CGRect&)rect with:(CGFloat)scale
{
	rect.origin.x *= scale;
	rect.origin.y *= scale;
	rect.size.width *= scale;
	rect.size.height *= scale;
	
	return rect;
}

+ (CGSize)getConstrainedToSize:(UILabel*)pLabel with:(int)nMaxWidth
{
	static CGSize textSize = CGSizeZero;
	if (textSize.width == 0 || textSize.height == 0)
	{
		textSize.width = nMaxWidth;
		textSize.height = nMaxWidth;
		
		if ([pLabel.text length] > 0)
		{
			textSize = [pLabel.text sizeWithFont:pLabel.font constrainedToSize:textSize lineBreakMode:pLabel.lineBreakMode];
		}
		
		textSize.width = (int)(textSize.width + 0.99f);
		textSize.height = (int)(textSize.height + 0.99f);
	}
	
	return textSize;
}

- (void)onChangeFrame
{
	
}

- (UIColor*)resGetColor:(NSString*)shortName
{
//	return resGetColor(shortName);
}

- (void)didThemeChange
{
//	UIColor* color = nil;
	
//	color = [self resGetColor:@"NovelBox/NovelReaderBackground"];
//	self.backgroundColor = color;
}

@end
