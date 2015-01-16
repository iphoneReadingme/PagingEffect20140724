
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiParameterInfo.mm
 *
 * Description  : 节日表情参数信息
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/


#import "FEEmojiParameterInfo.h"


@implementation FEEmojiParameterInfo

- (void)dealloc
{
	[_searchKeyWord release];
	_searchKeyWord = nil;
	
	[_emojiChar release];
	_emojiChar = nil;
	
	[_coordinateArray release];
	_coordinateArray = nil;
	
	[super dealloc];
}

@end

