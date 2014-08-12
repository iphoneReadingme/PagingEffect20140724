
/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: BottomBarViewController.h
 *
 * Description	: 底部工具栏视图控制器
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/6/4, yangfs, Create the file
 ******************************************************************************
 **/

typedef enum
{
	TB_UNKNOWN = 0,
	TB_COMMOM,          ///< 通用工具栏
}ToolBarType;


@class InterfaceToolBarView;

@interface BottomBarViewController : NSObject
{
	ToolBarType m_lastToolBarType;        // 旧工具栏类型
	InterfaceToolBarView* m_pCurToolBar; // 当前工具栏视图
}

+ (BottomBarViewController*)shareInstance;

- (void)updateToolBar:(UIView*)pParentView withType:(ToolBarType)curType;
// 切换窗口
- (void)onChangeOfView;

@end

