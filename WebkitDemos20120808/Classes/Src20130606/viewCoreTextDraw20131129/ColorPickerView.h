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


#define kKeyNotificationSaveTextColorAttributes         @"SaveTextColorAttributes"
#define kKeyNotificationSaveChapterNameColorAttributes  @"SaveChapterNameColorAttributes"

@interface ColorPickerView : UIView
{
}

- (id)initWithFrame:(CGRect)frame with:(NSString*)kKeyNotify;

@end

