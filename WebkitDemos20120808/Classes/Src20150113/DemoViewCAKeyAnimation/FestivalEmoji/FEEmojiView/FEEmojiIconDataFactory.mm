
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

#import "FEShapeParameterInfo.h"
#import "FEFestivalParameterInfo.h"
#import "FEParameterDataProvider.h"
#import "FEEmojiIconDataFactory.h"



#define kHardcodeFestivalEmojiDataPath      @"res/LocalFiles/FestivalEmoji/FestivalEmojiData"


@interface FEEmojiIconDataFactory ()


@end

@implementation FEEmojiIconDataFactory

+ (FEEmojiView*)buildEmojiViewWithType:(FEServerCmdType)type  withFrame:(CGRect)rect withData:(FEParameterDataProvider*)dataProvider;
//+ (FEEmojiView*)buildEmojiViewWithType:(FEServerCmdType)type withFrame:(CGRect)rect
{
	FEEmojiView* viewObj = nil;
	do
	{
//		NSString* shapeType = [NSString stringWithFormat:@"%d", type];
		
//		FEFestivalParameterInfo* parameterInfo = nil;
//		parameterInfo = [dataProvider getFestivalParameterInfo:shapeType];
//		
//		if (parameterInfo != nil && [parameterInfo.searchHotWords count] > 0)
//		{
//			viewObj = [[FEEmojiView alloc] initWithFrame:rect withData:parameterInfo];
//			[viewObj autorelease];
//		}
		
	}while (0);
	
	return viewObj;
}


#if 0
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
			[coordinateInfoArray safe_AddObject:temp];
		}
		
		
	}while (0);
	
	return coordinateInfoArray;
}

#endif

@end

