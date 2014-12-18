/*
 *****************************************************************************
 * Copyright (C) 2005-2013 UC Mobile Limited. All Rights Reserved
 * File			: NBPageItem.h
 *
 * Description	: NBPageItem (NSCoding)
 *
 * Author		: daijb@ucweb.com
 * History		:
 *			   Creation, 14-6-17, daijb@ucweb.com, Create the file
 ******************************************************************************
 **/

#import <UIKit/UIKit.h>
//#import "NBDataProviderDefine.h"

@interface NBPageItem : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger chapterIndex;     ///< 该页所在的章节编号
@property (nonatomic, assign) NSInteger pageIndex;        ///< 页码顺序号
@property (nonatomic, assign) NSUInteger startInChapter;  ///< 相对于当前章节的位置（字符位置）
@property (nonatomic, assign) NSUInteger length;          ///<（字符长度）
@property (nonatomic, assign) CGFloat lastPageViewHeight; ///< 最后一页面的显示高度

@end
