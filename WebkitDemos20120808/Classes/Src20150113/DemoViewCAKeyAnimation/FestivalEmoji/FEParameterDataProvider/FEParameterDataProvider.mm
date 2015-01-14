
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
#import "FEParameterDataProvider.h"
#import "NSMutableArray+ExceptionSafe.h"
#import "JSONKit.h"


///< 数据文件路径
#define kHardcodeFestivalEmojiDataPath           @"res/LocalFiles/FestivalEmoji/FestivalEmojiData"


///< 图形和坐标
#define kKeyJSONShapeData                        @"shapeData"
#define kKeyJSONShapeType                        @"shapetype"
#define kKeyJSONCoordinates                      @"coordinates"
#define kKeyJSONPoint                            @"point"

///< 节日
#define kKeyJSONSestivalData                     @"festivalData"
#define kKeyJSONFestivalType                     @"festivalType"
#define kKeyJSONSearchHotWords                   @"searchHotWords"
#define kKeyJSONWord                             @"word"


@interface FEParameterDataProvider()

@property (nonatomic, retain) NSMutableArray*    shapeInfoArray;        ///< 图形列表 list<FEShapeParameterInfo*>
@property (nonatomic, retain) NSMutableArray*    festivalInfoArray;        ///< 图形列表 list<FEShapeParameterInfo*>


@end


@implementation FEParameterDataProvider

- (void)dealloc
{
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
		
		NSDictionary* paramDict = [self readJSONDataFromFile];
		[self parseShapeJSONData:paramDict];
		[self parseFestivalJSONData:paramDict];
	}
	
	return self;
}

- (FEEmojiParameterInfo*)getFestivalParameterInfo:(NSString*)festivalType with:(NSString*)shapeType
{
	FEFestivalParameterInfo* festivalInfo = nil;
	
	for (FEFestivalParameterInfo* item in _festivalInfoArray)
	{
		if (![item isKindOfClass:[FEFestivalParameterInfo class]])
		{
			assert(0);
			continue;
		}
		
		if ([item.festivalType isEqualToString:festivalType])
		{
			festivalInfo = item;
			break;
		}
	}
	
	FEShapeParameterInfo* shapeInfo = nil;
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
	
	
	FEEmojiParameterInfo* emojiInfo = nil;
	
	if ([festivalInfo isValid] && [shapeInfo isValid])
	{
		emojiInfo = [[FEEmojiParameterInfo alloc] init];
		emojiInfo.emojiChar = festivalInfo.emojiChar;
		emojiInfo.fontSize = festivalInfo.fontSize;
		emojiInfo.coordinateArray = shapeInfo.coordinateArray;
	}
	
	return emojiInfo;
}


#pragma mark - ==解释图形坐标数据信息
- (void)parseShapeJSONData:(NSDictionary*)paramDict
{
	do
	{
		if (![paramDict isKindOfClass:[NSDictionary class]] || [paramDict count] < 1)
		{
			break;
		}
		
		NSMutableArray* pArray = [NSMutableArray arrayWithCapacity:[paramDict count]];
		FEShapeParameterInfo* parameterInfo = nil;
		
		NSArray*  sourceList= [FEParameterDataProvider getNSArrayFromDiction:paramDict withKey:kKeyJSONShapeData];
		
		for (NSDictionary* itemDict in sourceList)
		{
			parameterInfo = [FEParameterDataProvider getShapeParameterInfo:itemDict];
			
			[pArray safe_AddObject:parameterInfo];
		}
		
		if ([pArray count])
		{
			_shapeInfoArray = [pArray retain];
		}
		
	}while (0);
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
		
		[coordinateInfoArray safe_AddObject:pointStr];
	}
	
	if ([coordinateInfoArray count] < 1)
	{
		coordinateInfoArray = nil;
	}
	
	return coordinateInfoArray;
}

#pragma mark - ==解释节日数据信息
- (void)parseFestivalJSONData:(NSDictionary*)paramDict
{
	do
	{
		if (![paramDict isKindOfClass:[NSDictionary class]] || [paramDict count] < 1)
		{
			break;
		}
		
		NSMutableArray* pArray = [NSMutableArray arrayWithCapacity:[paramDict count]];
		FEFestivalParameterInfo* parameterInfo = nil;
		
		NSArray*  sourceList= [FEParameterDataProvider getNSArrayFromDiction:paramDict withKey:kKeyJSONSestivalData];
		
		for (NSDictionary* itemDict in sourceList)
		{
			parameterInfo = [FEParameterDataProvider parseFestivalParameter:itemDict];
			
			[pArray safe_AddObject:parameterInfo];
		}
		
		if ([pArray count])
		{
			_festivalInfoArray = [pArray retain];
		}
		
	}while (0);
}

///< 提取单条记录信息
+ (FEFestivalParameterInfo*)parseFestivalParameter:(NSDictionary*)recordDict
{
	FEFestivalParameterInfo* parameterInfo = nil;
	
	do
	{
		if (![recordDict isKindOfClass:[NSDictionary class]] || [recordDict count] < 1)
		{
			break;
		}
		
		NSString* type = [self getNSStringFromDiction:recordDict withKey:kKeyJSONFestivalType];
		if ([type length] < 1)
		{
			break;
		}
		
		NSMutableArray* searchHotWordsArray = [self getSearchHotWordsInfo:
										   [self getNSArrayFromDiction:recordDict withKey:kKeyJSONSearchHotWords]];
		if ([searchHotWordsArray count] < 1)
		{
			break;
		}
		
		///< 找到节日动画图形后，提取相关参数，数据异常时终止
		NSString* emojiChar = [FEParameterDataProvider getNSStringFromDiction:recordDict withKey:@"emojiChar"];
		if ([emojiChar length] < 1)
		{
			break;
		}
		
		NSString* value = [FEParameterDataProvider getNSStringFromDiction:recordDict withKey:@"fontSize"];
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
		
		value = [FEParameterDataProvider getNSStringFromDiction:recordDict withKey:@"days"];
		
		int days = [value intValue];
		if (days < 1)
		{
			break;
		}
		
		parameterInfo.festivalType = type;
		parameterInfo.searchHotWords = [NSMutableArray arrayWithCapacity:5];
		[parameterInfo.searchHotWords addObjectsFromArray:searchHotWordsArray];
		parameterInfo = [[[FEFestivalParameterInfo alloc] init] autorelease];
		parameterInfo.year = [FEParameterDataProvider getNSStringFromDiction:recordDict withKey:@"year"];
		parameterInfo.month = [FEParameterDataProvider getNSStringFromDiction:recordDict withKey:@"month"];
		parameterInfo.day = [FEParameterDataProvider getNSStringFromDiction:recordDict withKey:@"day"];
		
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
		
		NSString* word = [self getNSStringFromDiction:itemDict withKey:@"word"];
		if ([word length] < 1)
		{
			continue;
		}
		
		[searchHotWordInfoArray safe_AddObject:word];
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

#pragma mark - == 读取文件数据

- (NSString *)filePath
{
#ifdef _DEBUG
	NSString* filename = @"FestivalEmojiData";
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *pathSub = [path stringByAppendingPathComponent:@"Profile"];
	BOOL bRet = [[NSFileManager defaultManager] createDirectoryAtPath:pathSub withIntermediateDirectories:YES attributes:nil error:nil];
	if (bRet)
	{
		path = pathSub;
	}
	
	NSString* fileNameTxt = [NSString stringWithFormat:@"%@.txt", fileName];
	path = [path stringByAppendingPathComponent:fileNameTxt];
#else
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kHardcodeFestivalEmojiDataPath];
#endif
	return path;
}

- (NSDictionary*)readJSONDataFromFile
{
	NSDictionary* jsonDict = nil;
	
	do
	{
		NSString *filePath = [self filePath];
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

@end

