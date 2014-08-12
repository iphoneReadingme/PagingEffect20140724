
/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: DemoViewCALayerController.h
 *
 * Description	: Core Animation基础介绍、简单使用CALayer以及多种动画效果
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on 2013-06-06.
 * History		: modify: 2013-06-06.
 *
 ******************************************************************************
 **/


@class DemoViewCALayer;

@interface DemoViewCALayerController : UIViewController
{
	DemoViewCALayer* m_pSubView;
}

- (void)releaseObject;


@end

