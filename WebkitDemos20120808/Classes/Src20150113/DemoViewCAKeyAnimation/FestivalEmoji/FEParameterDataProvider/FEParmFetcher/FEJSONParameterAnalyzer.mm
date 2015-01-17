
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEJSONParameterAnalyzer.mm
 *
 * Description  : JSON数据参数解释器
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import "FEShapeParameterInfo.h"
#import "FEFestivalParameterInfo.h"
#import "NSMutableArray+ExceptionSafe.h"
#import "JSONKit.h"
#import "FEFestivalAdaptor.h"
#import "FEJSONParameterAnalyzer.h"
#import "FEEmojiViewMacroDefine.h"



@implementation FEJSONParameterAnalyzer


#pragma mark - == 读取文件数据

+ (NSString*)getFilePath
{
	return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kHardcodeFestivalEmojiDataPath];
}

+ (NSDictionary*)readJSONDataFromFile
{
	NSDictionary* jsonDict = nil;
	
	do
	{
		NSString *filePath = [self getFilePath];
		NSData* fileData = [NSData dataWithContentsOfFile:filePath];
		if ([fileData length] < 1)
		{
			break;
		}
		
		NSString* result = [[[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding] autorelease];
		if ([result length] < 1)
		{
			break;
		}
		
		jsonDict = (NSDictionary*)[result objectFromJSONString];
	}while (0);
	
	return jsonDict;
}

#pragma mark - ==解释图形坐标数据信息
+ (NSMutableArray*)parseShapeJSONData:(NSDictionary*)paramDict
{
	NSMutableArray* shapeInfoArray = nil;
	do
	{
		if (![paramDict isKindOfClass:[NSDictionary class]] || [paramDict count] < 1)
		{
			break;
		}
		
		NSMutableArray* pArray = [NSMutableArray arrayWithCapacity:[paramDict count]];
		FEShapeParameterInfo* parameterInfo = nil;
		
		NSArray*  sourceList= [self getNSArrayFromDiction:paramDict withKey:kKeyJSONShapeData];
		
		for (NSDictionary* itemDict in sourceList)
		{
			parameterInfo = [self getShapeParameterInfo:itemDict];
			
			if (parameterInfo)
			{
				[pArray safe_AddObject:parameterInfo];
			}
		}
		
		if ([pArray count])
		{
			shapeInfoArray = pArray;
		}
		
	}while (0);
	
	return shapeInfoArray;
}

///< 提取单条记录信息
+ (FEShapeParameterInfo*)getShapeParameterInfo:(NSDictionary*)recordDict
{
	FEShapeParameterInfo* parameterInfo = nil;
	
	do
	{
		if (![recordDict isKindOfClass:[NSDictionary class]] || [recordDict count] < 1)
		{
			break;
		}
		
		NSString* shape = [self getNSStringFromDiction:recordDict withKey:kKeyJSONShapeType];
		if ([shape length] < 1)
		{
			break;
		}
		
		NSMutableArray* coordinateArray = [self getCoordinatesInfo:
										   [self getNSArrayFromDiction:recordDict withKey:kKeyJSONCoordinates]];
		if ([coordinateArray count] < 1)
		{
			break;
		}
		
		parameterInfo = [[[FEShapeParameterInfo alloc] init] autorelease];
		parameterInfo.shapeType = shape;
		parameterInfo.coordinateArray = coordinateArray;
		
	}while (0);
	
	return parameterInfo;
}

+ (NSMutableArray*)getCoordinatesInfo:(NSArray*)coordinateArray
{
	if ([coordinateArray count] < 1)
	{
		return nil;
	}
	
	NSMutableArray* coordinateInfoArray = [NSMutableArray array];
	
	for (NSDictionary* itemDict in coordinateArray)
	{
		if (![itemDict isKindOfClass:[NSDictionary class]])
		{
			continue;
		}
		if ([itemDict count] < 1)
		{
			continue;
		}
		
		NSString* pointStr = [self getNSStringFromDiction:itemDict withKey:@"point"];
		if ([pointStr length] < 5)
		{
			continue;
		}
		
		if (pointStr)
		{
			[coordinateInfoArray safe_AddObject:pointStr];
		}
	}
	
	if ([coordinateInfoArray count] < 1)
	{
		coordinateInfoArray = nil;
	}
	
	return coordinateInfoArray;
}

#pragma mark - ==解释节日数据信息
+ (NSMutableArray*)parseFestivalJSONData:(NSDictionary*)paramDict with:(NSDateFormatter*)dateFormator
{
	NSMutableArray* festivalInfoArray = nil;
	do
	{
		if (![paramDict isKindOfClass:[NSDictionary class]] || [paramDict count] < 1)
		{
			break;
		}
		
		NSMutableArray* pArray = [NSMutableArray arrayWithCapacity:[paramDict count]];
		
		FEFestivalParameterInfo* parameterInfo = nil;
		
		NSArray*  sourceList= [self getNSArrayFromDiction:paramDict withKey:kKeyJSONSestivalData];
		
		for (NSDictionary* itemDict in sourceList)
		{
			parameterInfo = [self parseFestivalParameter:itemDict with:dateFormator];
			if (parameterInfo)
			{
				[pArray safe_AddObject:parameterInfo];
			}
		}
		
		if ([pArray count])
		{
			festivalInfoArray = pArray;
		}
		
	}while (0);
	
	return festivalInfoArray;
}

+ (NSDate*)buildDate:(NSString*)year m:(NSString*)month d:(NSString*)day with:(NSDateFormatter*)dateFormator
{
	NSDate *date = nil;
	if ([year length] > 0 && [month length] > 0 && [day length] > 0)
	{
		NSString* dateText = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
		date = [dateFormator dateFromString:dateText];
	}
	
	return date;
}

///< 提取单条记录信息
+ (FEFestivalParameterInfo*)parseFestivalParameter:(NSDictionary*)recordDict with:(NSDateFormatter*)dateFormator
{
	FEFestivalParameterInfo* parameterInfo = nil;
	
	do
	{
		if (![recordDict isKindOfClass:[NSDictionary class]] || [recordDict count] < 1)
		{
			break;
		}
		
		NSString* festival = [self getNSStringFromDiction:recordDict withKey:kKeyJSONFestivalType];
		if ([festival length] < 1)
		{
			break;
		}
		
		NSString* shapeType = [self getNSStringFromDiction:recordDict withKey:kKeyJSONShapeType];
		if ([shapeType length] < 1)
		{
			break;
		}
		
		NSString* year = [self getNSStringFromDiction:recordDict withKey:kKeyJSONYear];
		NSString* month = [self getNSStringFromDiction:recordDict withKey:kKeyJSONMonth];
		NSString* day = [self getNSStringFromDiction:recordDict withKey:kKeyJSONDay];
		
		NSString* value = [self getNSStringFromDiction:recordDict withKey:kKeyJSONDays];
		
		int days = [value intValue];
		if (days < 1)
		{
			break;
		}
		
		NSDate *festivalDate = [self buildDate:year m:month d:day with:dateFormator];
		if (![FEFestivalAdaptor isValidFestivalDate:festivalDate days:days])
		{
			break;
		}
		
		///< 找到节日动画图形后，提取相关参数，数据异常时终止
		NSString* emojiChar = [self getNSStringFromDiction:recordDict withKey:kKeyJSONEmojiChar];
		if ([emojiChar length] < 1)
		{
			break;
		}
		
		value = [self getNSStringFromDiction:recordDict withKey:kKeyJSONFontSize];
		if ([value length] < 1)
		{
			break;
		}
		
		int fontSize = [value intValue];
		if (fontSize < 5)
		{
			///< 表情图标太小
			break;
		}
		
		NSMutableArray* searchHotWordsArray = [self getSearchHotWordsInfo:
											   [self getNSArrayFromDiction:recordDict withKey:kKeyJSONSearchHotWords]];
		if ([searchHotWordsArray count] < 1)
		{
			break;
		}
		
		value = [self getNSStringFromDiction:recordDict withKey:kKeyJSONRepeat];
		if ([value length] < 1)
		{
			break;
		}
		
		BOOL bRepeat = [value boolValue];
		
		parameterInfo = [[[FEFestivalParameterInfo alloc] init] autorelease];
		parameterInfo.festivalType = festival;
		parameterInfo.shapeType = shapeType;
		parameterInfo.bRepeat = bRepeat;
		parameterInfo.emojiChar = emojiChar;
		parameterInfo.searchHotWords = [NSMutableArray arrayWithArray:searchHotWordsArray];
		parameterInfo.year = year;
		parameterInfo.month = month;
		parameterInfo.day = day;
		parameterInfo.days = days;
		parameterInfo.fontSize = fontSize;
		
	}while (0);
	
	return parameterInfo;
}

+ (NSMutableArray*)getSearchHotWordsInfo:(NSArray*)searchHotWordArray
{
	if ([searchHotWordArray count] < 1)
	{
		return nil;
	}
	
	NSMutableArray* searchHotWordInfoArray = [NSMutableArray array];
	
	for (NSDictionary* itemDict in searchHotWordArray)
	{
		if (![itemDict isKindOfClass:[NSDictionary class]])
		{
			continue;
		}
		if ([itemDict count] < 1)
		{
			continue;
		}
		
		NSString* word = [self getNSStringFromDiction:itemDict withKey:kKeyJSONWord];
		if ([word length] < 1)
		{
			continue;
		}
		
		if (word)
		{
			[searchHotWordInfoArray safe_AddObject:word];
		}
	}
	
	if ([searchHotWordInfoArray count] < 1)
	{
		searchHotWordInfoArray = nil;
	}
	
	return searchHotWordInfoArray;
}

#pragma mark - ==JSON数据相关
+ (id)getValueFromDiction:(NSDictionary*)dict withKey:(id)key
{
	id value = nil;
	if ([dict isKindOfClass:[NSDictionary class]])
	{
		value = [dict objectForKey:key];
		
		if (value == [NSNull null])
		{
			value = nil;
			
			NSLog(@"== NBDataAnalyze [key] = [%@]; value = NSNull; \n\n\n", key);
		}
	}
	
	return value;
}

///< 通过key关键字，从dict对象中获取JSON数据NSString对象
+ (NSString*)getNSStringFromDiction:(NSDictionary*)dict withKey:(id)key
{
	NSString* obj = nil;
	
	id value = [self getValueFromDiction:dict withKey:key];
	if ([value isKindOfClass:[NSString class]] && [value length] > 0)
	{
		obj = value;
	}
	
	return obj;
}

///< 通过key关键字，从dict对象中获取JSON数据NSArray对象
+ (NSArray*)getNSArrayFromDiction:(NSDictionary*)dict withKey:(id)key
{
	NSArray* obj = nil;
	
	id value = [self getValueFromDiction:dict withKey:key];
	if ([value isKindOfClass:[NSArray class]])
	{
		obj = value;
	}
	
	return obj;
}

///< 通过key关键字，从dict对象中获取JSON数据NSDictionary对象
+ (NSDictionary*)getNSDictionaryFromDiction:(NSDictionary*)dict withKey:(id)key
{
	NSDictionary* obj = nil;
	
	id value = [self getValueFromDiction:dict withKey:key];
	if ([value isKindOfClass:[NSDictionary class]])
	{
		obj = value;
	}
	
	return obj;
}

@end

