
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEFestivalParameterInfo.h
 *
 * Description  : 节日表情参数信息
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import "FEFestivalParameterInfo.h"


///< 是否使用默认数据
//#define  _Enable_Default_Data


@implementation FEFestivalParameterInfo

- (void)dealloc
{
	[_festivalType release];
	_festivalType = nil;
	
	[_shapeType release];
	_shapeType = nil;
	
	[_emojiChar release];
	_emojiChar = nil;
	
	[_year release];
	_year = nil;
	
	[_month release];
	_month = nil;
	
	[_day release];
	_day = nil;
	
	[_searchHotWords release];
	_searchHotWords = nil;
	
	[super dealloc];
}

- (id)init
{
	if (self = [super init])
	{
#ifdef _Enable_Default_Data
		[self setDefaultParameter];
#endif
	}
	
	return self;
}

- (BOOL)isValid
{
	BOOL bValid = NO;
	
	bValid = [_searchHotWords count] > 0;
	
	if (bValid)
	{
		bValid = _days > 0;
	}
	
	if (bValid)
	{
		bValid = _fontSize > 10;
	}
	
	if (bValid)
	{
		bValid = [_emojiChar length] > 0;
	}
	
	return bValid;
}


#ifdef _Enable_Default_Data

- (void)setDefaultParameter
{
	_festivalType = @"1"; ///< 情人节
	_festivalType = @"2"; ///< 春节
	_festivalType = @"3"; ///< 元宵节
	
	_shapeType = @"2";
	_emojiChar = @"💘";
	_fontSize = 32;
	
	_year = @"2015";
	_month = @"1";
	_day = @"14";
	_days = 1;
	
	_bRepeat = NO;
	
	self.searchHotWords = [NSMutableArray arrayWithArray:@[@"情人节", @"爱心", @"情人", @"节日"]];
}

#endif


@end

