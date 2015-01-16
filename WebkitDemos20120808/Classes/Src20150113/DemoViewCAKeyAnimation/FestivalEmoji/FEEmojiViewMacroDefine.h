
/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiViewMacroDefine.h
 *
 * Description	: 节日表情图标视图宏定义
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/




///< for test
#define _Enable_Hardcode_keyword

#ifdef _Enable_Hardcode_keyword
///< 服务器下发的节日命令动画类型

typedef NS_ENUM(NSInteger, FEServerCmdType)
{
	FESCTypeUnknown = 0,                  ///< 未定义
	
	FESCTypeOne,                          ///< 类型 1
	FESCTypeTwo,                          ///< 类型 2
	FESCTypeThree,                        ///< 类型 3
//	FESCTypeFourth,                       ///< 类型 4
//	FESCTypeFifth,                        ///< 类型 5
	
	FEEITypeMaxCount
};
#endif

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

#define kKeyJSONYear                             @"year"
#define kKeyJSONMonth                            @"month"
#define kKeyJSONDay                              @"day"
#define kKeyJSONDays                             @"days"

#define kKeyJSONEmojiChar                        @"emojiChar"
#define kKeyJSONFontSize                         @"fontSize"
#define kKeyJSONRepeat                           @"repeat"


