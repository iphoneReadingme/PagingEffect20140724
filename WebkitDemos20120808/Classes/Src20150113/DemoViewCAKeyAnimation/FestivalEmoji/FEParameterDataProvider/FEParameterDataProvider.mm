
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEParameterDataProvider.h
 *
 * Description  : 参数信息数据解释
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/


#import "FEEmojiParameterInfo.h"
#import "FEShapeParameterInfo.h"
#import "FEFestivalParameterInfo.h"
#import "FEJSONParameterAnalyzer.h"
#import "FEFestivalAdaptor.h"
#import "FEParameterDataProvider.h"



@interface FEParameterDataProvider()

@property (nonatomic, retain) NSDateFormatter*    dateFormator;
@property (nonatomic, retain) NSMutableArray*    shapeInfoArray;        ///< 图形列表 list<FEShapeParameterInfo*>
@property (nonatomic, retain) NSMutableArray*    festivalInfoArray;        ///< 图形列表 list<FEShapeParameterInfo*>


@end


@implementation FEParameterDataProvider

- (void)dealloc
{
	[_dateFormator release];
	_dateFormator = nil;
	
	[_shapeInfoArray release];
	_shapeInfoArray = nil;
	
	[_festivalInfoArray release];
	_festivalInfoArray = nil;
	
	[super dealloc];
}

- (id)init
{
	if (self = [super init])
	{
		[self loadDataWith:NO];
	}
	
	return self;
}

- (void)loadDataWith:(BOOL)bForce
{
	BOOL bLoadData = NO;
	
	bLoadData = (bForce && [FEFestivalAdaptor isNeedReloadFestivalData]);
	
	if (!bLoadData && _festivalInfoArray == nil)
	{
		bLoadData = YES;
	}
	
	if (bLoadData)
	{
		///< 更新本次数据加载时的日期
		[FEFestivalAdaptor setLoadDataDate];
		
		NSDictionary* paramDict = [self readJSONDataFromFile];
		self.festivalInfoArray = [FEJSONParameterAnalyzer parseFestivalJSONData:paramDict with:[self getNSDateFormatter]];
		if ([_festivalInfoArray count] > 0)
		{
			self.shapeInfoArray = [FEJSONParameterAnalyzer parseShapeJSONData:paramDict];
		}
	}
}

- (NSDateFormatter*)getNSDateFormatter
{
	if (_dateFormator == nil)
	{
		_dateFormator = [[NSDateFormatter alloc] init];
		[_dateFormator setTimeZone:[NSTimeZone systemTimeZone]];
		[_dateFormator setLocale:[NSLocale systemLocale]];
		[_dateFormator setDateFormat:@"yyyy-MM-dd"];
		[_dateFormator setFormatterBehavior:NSDateFormatterBehaviorDefault];
	}
	
	return _dateFormator;
}

#pragma mark - == 读取文件数据

- (NSDictionary*)readJSONDataFromFile
{
	return [FEJSONParameterAnalyzer readJSONDataFromFile];
}

///< 通过搜索关键获取节日信息
- (FEEmojiParameterInfo*)getFestivalEmojiParameterInfoByKeyWord:(NSString*)keyWord
{
	FEFestivalParameterInfo* festivalObj = [self getFestivalParameterInfoByKeyWord:keyWord];
	
	FEShapeParameterInfo* shapeInfo = nil;
	if (festivalObj != nil && [festivalObj isValid])
	{
		shapeInfo = [self getShapeParameterInfoBy:festivalObj.shapeType];
	}
	
	FEEmojiParameterInfo* emojiInfo = nil;
	
	if ([shapeInfo isValid])
	{
		emojiInfo = [[[FEEmojiParameterInfo alloc] init] autorelease];
		emojiInfo.emojiChar = [festivalObj emojiChar];
		emojiInfo.fontSize = festivalObj.fontSize;
		emojiInfo.bRepeat = festivalObj.bRepeat;
		emojiInfo.coordinateArray = shapeInfo.coordinateArray;
	}
	
	return emojiInfo;
}

- (FEFestivalParameterInfo*)getFestivalParameterInfoByKeyWord:(NSString*)keyWord
{
	FEFestivalParameterInfo* festivalObj = nil;
	
	do
	{
		if ([keyWord length] < 1)
		{
			break;
		}
		
		for (FEFestivalParameterInfo* item in _festivalInfoArray)
		{
			if (![item isKindOfClass:[FEFestivalParameterInfo class]])
			{
				assert(0);
				continue;
			}
			
			BOOL bRet = [self findKeyWordFrom:item withKeyWord:keyWord];
			if (bRet)
			{
				festivalObj = item;
				break;
			}
		}
		
	}while (0);
	
	return festivalObj;
}

- (BOOL)findKeyWordFrom:(FEFestivalParameterInfo*)item withKeyWord:(NSString*)keyWord
{
	BOOL bRet = NO;
	
	for (NSString* word in [item searchHotWords])
	{
		NSRange rang = [keyWord rangeOfString:word];
		
		if (rang.location != NSNotFound)
		{
			bRet = YES;
			break;
		}
	}
	
	return bRet;
}

- (FEShapeParameterInfo*)getShapeParameterInfoBy:(NSString*)shapeType
{
	FEShapeParameterInfo* shapeInfo = nil;
	
	do
	{
		if ([shapeType length] < 1)
		{
			break;
		}
		
		for (FEShapeParameterInfo* item in _shapeInfoArray)
		{
			if (![item isKindOfClass:[FEShapeParameterInfo class]])
			{
				assert(0);
				continue;
			}
			
			if ([item.shapeType isEqualToString:shapeType])
			{
				shapeInfo = item;
				break;
			}
		}
		
	}while (0);
	
	return shapeInfo;
}

@end

