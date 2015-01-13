
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiIconDataFactory.h
 *
 * Description  : 节日表情数据对象构造工厂
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/


#import <UIKit/UIKit.h>
#import "FEEmojiIconDataFactory.h"
#import "FEEmojiParameterInfo.h"
//#import "NSMutableArray+ExceptionSafe.h"
#import "JSONKit.h"



#define kHardcodeFestivalEmojiDataPath      @"res/LocalFiles/FestivalEmoji/FestivalEmojiData"


@interface FEEmojiIconDataFactory ()

+ (NSMutableArray*)getCoordinatesInfo:(NSArray*)coordinateArray;

@end

@implementation FEEmojiIconDataFactory


+ (FEEmojiView*)buildEmojiViewWithType:(FEServerCmdType)type withFrame:(CGRect)rect
{
	FEEmojiView* viewObj = nil;
	do
	{
		NSDictionary* paramDict = [self readJSONDataFromFile];
		if ([paramDict count] < 1)
		{
			break;
		}
		
		NSArray*  sourceList= [self getNSArrayFromDiction:paramDict withKey:@"parameter"];
		if ([sourceList count] < 1)
		{
			break;
		}
		
		NSString* shapeType = [NSString stringWithFormat:@"%d", type];
		
		FEEmojiParameterInfo* parameterInfo = nil;
		parameterInfo = [self getEmojiParameterInfo:sourceList with:shapeType];
		
		if (parameterInfo != nil && [parameterInfo.coordinateArray count] > 0)
		{
			viewObj = [[FEEmojiView alloc] initWithFrame:rect withData:parameterInfo];
			[viewObj autorelease];
		}
		
	}while (0);
	
	
	/*
    switch(type)
    {
        case FESCTypeOne:
        {
			parameterInfo.emojiChar = @"😘";
			parameterInfo.viewSize = CGSizeMake(64, 64);
			parameterInfo.fontSize = 15;
            break;
        }
        case FESCTypeTwo:
		{
			parameterInfo.emojiChar = @"💘";
			parameterInfo.viewSize = CGSizeMake(60, 58);
			parameterInfo.fontSize = 20;
            break;
        }
        case FESCTypeThree:
		{
			parameterInfo.emojiChar = @"👘";
			parameterInfo.viewSize = CGSizeMake(64, 64);
			parameterInfo.fontSize = 25;
            break;
        }
        case FESCTypeFourth:
		{
			parameterInfo.emojiChar = @"💓";
			parameterInfo.viewSize = CGSizeMake(64, 64);
			parameterInfo.fontSize = 30;
            break;
        }
		case FESCTypeFifth:
		{
			parameterInfo.emojiChar = @"😍";
			parameterInfo.viewSize = CGSizeMake(64, 64);
			parameterInfo.fontSize = 35;
			break;
		}
        default:
		{
            assert(0);
            break;
		}
	}
	 */
//	parameterInfo.emojiChar = @"😍";
//	NSMutableArray* coordinateInfoArray = nil;
//	coordinateInfoArray = [self getCoordinateInfo:parameterInfo.viewSize];
//	if ([coordinateInfoArray count] > 0)
//	{
//		parameterInfo.coordinateArray = coordinateInfoArray;
//		viewObj = [[FEEmojiView alloc] initWithFrame:rect withData:parameterInfo];
//	}
//	
//	[viewObj autorelease];
	
    return viewObj;
}

+ (CGRect)getRectWith:(CGRect&)rect with:(CGFloat)scale
{
	rect.origin.x *= scale;
	rect.origin.y *= scale;
	rect.size.width *= scale;
	rect.size.height *= scale;
	
	return rect;
}

+ (NSMutableArray*)getCoordinateInfo:(CGSize)iconSize
{
	CGRect g_coordinateList[12] =
	{
		CGRectMake(288, 160, 64, 64),
		CGRectMake(384, 112, 64, 64),
		CGRectMake(480, 144, 64, 64),
		
		CGRectMake(512, 240, 64, 64),
		CGRectMake(464, 336, 64, 64),
		CGRectMake(384, 416, 64, 64),
		
		CGRectMake(288, 480, 64, 64),
		CGRectMake(192, 416, 64, 64),
		CGRectMake(112, 336, 64, 64),
		
		CGRectMake(64, 240, 64, 64),
		CGRectMake(96, 114, 64, 64),
		CGRectMake(192, 112, 64, 64),
	};

	NSMutableArray* coordinateInfoArray = nil;
	do
	{
		NSString* temp = nil;
		coordinateInfoArray = [NSMutableArray array];
		for (int i=0; i < sizeof(g_coordinateList)/sizeof(g_coordinateList[0]); i++)
		{
			CGRect rect = g_coordinateList[i];
			rect.size = iconSize;
			rect = [self getRectWith:rect with:0.5f];
			temp = NSStringFromCGRect(rect);
//			[coordinateInfoArray safe_AddObject:temp];
			[coordinateInfoArray addObject:temp];
		}
		
		
	}while (0);
	
	return coordinateInfoArray;
}

+ (FEEmojiParameterInfo*)getEmojiParameterInfo:(NSArray*)paramArray with:(NSString*)shapeType
{
	if ([shapeType length] < 1)
	{
		return nil;
	}
	
	FEEmojiParameterInfo* parameterInfo = nil;
	
	for (NSDictionary* shapeDataDict in paramArray)
	{
		if (![shapeDataDict isKindOfClass:[NSDictionary class]])
		{
			continue;
		}
		if ([shapeDataDict count] < 1)
		{
			continue;
		}
		
		NSString* shape = [FEEmojiIconDataFactory getNSStringFromDiction:shapeDataDict withKey:@"shape"];
		if (![shapeType isEqualToString:shape])
		{
			continue;
		}
		
		///< 找到节日动画图形后，提取相关参数，数据异常时终止
		NSString* emojiChar = [FEEmojiIconDataFactory getNSStringFromDiction:shapeDataDict withKey:@"emojiChar"];
		if ([emojiChar length] < 1)
		{
			break;
		}
		
		NSString* value = [FEEmojiIconDataFactory getNSStringFromDiction:shapeDataDict withKey:@"fontSize"];
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
		
		NSMutableArray* coordinateArray = [FEEmojiIconDataFactory getCoordinatesInfo:
										   [self getNSArrayFromDiction:shapeDataDict withKey:@"coordinates"]];
		if ([coordinateArray count] < 1)
		{
			break;
		}
		
		parameterInfo = [[[FEEmojiParameterInfo alloc] init] autorelease];
		parameterInfo.emojiChar = emojiChar;
		parameterInfo.fontSize = fontSize;
		parameterInfo.coordinateArray = coordinateArray;
		
		break;
	}
	
	
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
		
//		[coordinateInfoArray safe_AddObject:pointStr];
		[coordinateInfoArray addObject:pointStr];
	}
	
	if ([coordinateInfoArray count] < 1)
	{
		coordinateInfoArray = nil;
	}
	
	return coordinateInfoArray;
}

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

+ (NSString *)filePath
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

+ (NSDictionary*)readJSONDataFromFile
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

