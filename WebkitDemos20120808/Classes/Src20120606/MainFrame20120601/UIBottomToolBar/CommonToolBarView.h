/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: CommonToolBarView.h
 *
 * Description	: 通用底部工具栏
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/5/4, yangfs, Create the file
 ******************************************************************************
 **/


#import "UIViewBottomBarMacroDef.h"
#import "InterfaceToolBarView.h"



@interface CommonToolBarView : InterfaceToolBarView
{
	UIButton* m_fullScreenBtn;           ///< 全屏按钮
	UIButton* m_ExitAppBtn;              ///< 退出按钮

    UIButton* m_returnButton;            ///< 返回按钮
}


///< 影响按钮点击
- (void)onButtonClickEvent:(UIButton*)sender;

///< 皮肤更改事件
- (void)didThemeChange;


@end
