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



@interface DemoViewCATransform3D : UIView
{
	int m_nAngle;    // 旋转角度360度
	UILabel* m_pLabelTitle;
	UIView* m_pContainerView;
	
	UIImageView* m_p3DAnimationView;
}


@end


#define MWMD_LOG_DEBUG_ENABLE

#ifdef MWMD_LOG_DEBUG_ENABLE
#define MWMD_LOG_NSLOG(...)      NSLog(__VA_ARGS__)
#else
#define MWMD_LOG_NSLOG(...)      do{}while(0)
#endif

