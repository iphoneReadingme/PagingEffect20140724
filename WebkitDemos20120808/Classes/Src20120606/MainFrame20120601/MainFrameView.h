/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: MainFrameView.h
 *
 * Description	: 用于显示底部工具条或其它弹出操作界面()
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/06/01, yangfs, Create the file
 ******************************************************************************
 **/




@interface MainFrameView : UIView
{
	// 工具栏
	UIView* m_pBottomBarView;
	// 背景视图
	UIView* m_pBackgroundView;
}

+ (MainFrameView*)shareInstance;

- (void)showMainFrame:(UIView*)parentView;

@end

