
/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: UITestView.h
 *
 * Description	: 用于显示测试视图的title, 用于测试时确定当前View对象是哪个
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/08/08, yangfs, Create the file
 ******************************************************************************
 **/

//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>


@interface UIView (UIVIEW_Private_ForTest)

- (void)addTitleView:(NSString*)title;
//- (void)addTitleView:(UIView*)parentView title:(NSString*)title;

@end

