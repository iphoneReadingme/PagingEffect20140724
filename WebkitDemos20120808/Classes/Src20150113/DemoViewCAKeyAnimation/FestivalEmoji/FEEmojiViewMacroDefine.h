
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



///< 章节标题文字
#define kFontSizeOfTitle                              (32/2.0f)
#define kFontSizeOfLastChapterLabelText               (28/2.0f)

#define kFontSizeOfBtnTitle                           (32/2.0f)
#define kWidthOfBtn                                   (352/2.0f)
#define kHeightOfBtn                                  (82/2.0f)
#define kCornerRadius                                 (10/2.0f)


#define kLeftMarginOfChapterLabel                     (32/2.0f)
///< 各个控件之间的间距（Y方向）
#define kYSpaceOfViews1                               (30/2.0f)
#define kYSpaceOfViews2                               (130/2.0f)
#define kYSpaceOfViews3                               (40/2.0f)


