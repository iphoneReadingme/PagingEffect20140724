/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: DeviceDiskConsumeStatusView.h
 *
 * Description	: 文本绘制属性配置
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on 2014-01-07.
 * History		: modify: 2014-01-07.
 *
 ******************************************************************************
 **/



@interface DeviceDiskConsumeStatusView : UIView//UIScrollView
{
	CGRect m_frame;
	float m_totalSpace;
	float m_freeSpace;
	float m_directorySpace;
	float m_otherSpace;
	NSArray * m_deviceData;
	NSArray * m_titles;
}


@end

