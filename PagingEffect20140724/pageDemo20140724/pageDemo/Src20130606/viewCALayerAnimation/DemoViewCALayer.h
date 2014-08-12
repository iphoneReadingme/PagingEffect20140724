/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: DemoViewCALayer.h
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



@interface DemoViewCALayer : UIScrollView
{
	UIImageView* m_pImgView;
	
	int m_nCornerRadius;
	UILabel* m_pLabelRadius;
	
	UIImageView* m_imageView;  // 测试图片视图
	
	UIView* m_pViewCATransform3D;
}


@end

