
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: FEEmojiViewController.h
 *
 * Description  : 节日表情图标视图接口控制器
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-01-10.
 * History		: modify: 2015-01-10.
 *
 ******************************************************************************
 **/



#import "FEEmojiViewMacroDefine.h"


@interface FEEmojiViewController : NSObject


//@property (nonatomic, assign) id<NBSourceAdditionalPageViewControllerDelegate> delegate;
+ (void)showFEEmojiView:(UIView*)parentView;

//- (id)initWithParentView:(UIView*)parentView WithType:(FEServerCmdType)type;


- (void)didThemeChange;

- (void)onChangeFrame;


///< 节日匹配
- (void)matchFestivalByKeyWord:(NSString*)keyWord;

@end



