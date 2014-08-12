/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: DemoSettingView.h
 *
 * Description	: 文本绘制属性配置
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on 2013-12-03.
 * History		: modify: 2013-12-03.
 *
 ******************************************************************************
 **/


#define kKeyNotificationSaveTextAttributes  @"SaveTextAttributes"

@interface DemoSettingView : UIScrollView
{
	UITextField* m_pFontName;         // 字体
	UITextField* m_pFontSize;         // 文字大小
	UITextField* m_pLineSpace;        // 行间距
	UITextField* m_pParagraphSpacing; // 段间距
	
	UIPickerView* m_pTextAlignment;
//	UIView* m_pViewCATransform3D;
}


@end

