
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


#import "FEShapeParameterInfo.h"


@implementation FEShapeParameterInfo

- (void)dealloc
{
	[_shapeType release];
	_shapeType = nil;
	
	[_coordinateArray release];
	_coordinateArray = nil;
	
	[super dealloc];
}

- (BOOL)isValid
{
	return ([_coordinateArray count] > 0);
}

@end

