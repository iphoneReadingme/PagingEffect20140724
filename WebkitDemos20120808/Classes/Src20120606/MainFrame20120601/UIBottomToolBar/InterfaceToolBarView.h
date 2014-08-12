/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: InterfaceToolBarView.h
 *
 * Description	: UI界面底部工具栏视图接口类
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/4/27, yangfs, Create the file
 ******************************************************************************
 **/


typedef struct 
{
    NSString*       m_btnName;             ///< 按钮名字(自动化测试时使用)
	NSString*       m_btnTitle;            ///< 按钮显示文字(title)
    int             m_nBtnTag;             ///< 按钮tag,与事件对应
	int             m_cmdID;               ///< 按钮点击事件统计时对应的命令参数
}BottombarItem;


@interface InterfaceToolBarView : UIView
{
	UIImageView* m_bgImageView;      ///< 背景图片视图
	UIImageView* m_shadowImgView;
}

- (id)initWithFrame:(CGRect)frame;
- (void)releaseImagView;

// 切换皮肤
- (void)didThemeChange;
// 切换窗口
- (void)onChangeOfView;
// 调整按钮位置
- (void)onChangeOfButtons;

- (void)addBgImageView;
- (void)setBgImageView;

- (UIButton*)createButton:(int)nTag withName:(NSString*)pStrName withTitle:(NSString*)pTitle;
- (void)createAllButtons;
- (void)refreshAllButtons;
- (void)setButtonProperty:(UIButton*)pBtn;
- (void)onButtonClickEvent:(UIButton*)sender;

- (void)setButtonEnable:(BOOL)bEnable withTag:(int)nTag;

///< 设置按钮宽度时统一调用此接口,方便维护
- (int)getButtonWidth;

///< 底部工具上部分按钮点击事件统计功能
- (void)buttonClickCount:(int)nTag;

@end


