
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEShapeParameterInfo.h
 *
 * Description  : 图形参数信息
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-14.
 * History		: modify: 2015-01-14.
 *
 ******************************************************************************
 **/



#import <Foundation/Foundation.h>


@interface FEShapeParameterInfo : NSObject

@property (nonatomic, copy) NSString*          shapeType;             ///< 类型
@property (nonatomic, retain) NSMutableArray*    coordinateArray;       ///< 表情图标显示坐标和大小（CGRect String)

///< 对象是否有效
- (BOOL)isValid;

@end

