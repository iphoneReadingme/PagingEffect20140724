/*
 *****************************************************************************
 * Copyright (C) 2005-2011 UC Mobile Limited. All Rights Reserved
 * File			: UIViewBottomBarMacroDef.h
 *
 * Description	: UI界面工具栏相关宏定义
 *
 * Author		: yangfs@ucweb.com
 * History		: 
 *			   Creation, 2012/4/27, yangfs, Create the file
 ******************************************************************************
 **/

#ifndef _UIViewBottomBarMacroDef_h_
#define _UIViewBottomBarMacroDef_h_


#define SAFE_DELETE_NSOBJECT(obj) {[obj release]; obj = nil;}


enum BottomBarButtonTagDefine
{
	Btn_Tag_Btn_UNKOWN=0,            ///< 
	// 历史界面按钮tag
	Btn_Tag_His_Clear,               ///< 清空
	Btn_Tag_His_Back,                ///< 返回按钮
	// 书签界面
	Btn_Tag_BM_EditBookMark,         ///< 编辑
	Btn_Tag_BM_BookMarkSynchro,      ///< 同步
	Btn_Tag_BM_Back,                 ///< 返回按钮
	Btn_Tag_BM_Finish,               ///< 完成
	Btn_Tag_BM_AddBookMark,          ///< 添加书签
	Btn_Tag_BM_AddDirectory,         ///< 添加目录
	
	// 文件管理界面 File Browser Tool Bar View Button tag
	BTN_TAG_FBTBV_EDIT,              ///< 编辑
	BTN_TAG_FBTBV_RETURN,            ///< 返回
	BTN_TAG_FBTBV_FINISH,            ///< 完成
	BTN_TAG_FBTBV_NEWDIR,            ///< 新建目录
	
	// 下载管理界面 Download Tool Bar view Button Tag
	BTN_TAG_DTBV_EDIT,              ///< 编辑
	BTN_TAG_DTBV_RETURN,            ///< 返回
	BTN_TAG_DTBV_FINISH,            ///< 完成
	BTN_TAG_DTBV_CLEAR_ALL,         ///< 清空
	
	// Flash播放界面 Flash play
	BTN_TAG_FLASH_PLAY_RETURN,      ///< 返回
	
	// 应用全屏底部工具栏
	BTN_TAG_APPFSBB_OPEN_WINDOW,    ///< 窗口
	BTN_TAG_APPFSBB_EXIT,           ///< 退出应用
	
	// 全屏
	BTN_TAG_ENTER_FULLSCREEN,          ///< 进入全屏
	BTN_TAG_EXIT_FULLSCREEN,           ///< 退出全屏
	BTN_TAG_EXIT_RETURN,           ///< 返回上一层
};


///< 按钮的宽度("新建目录"4个汉字的按钮占用64的宽度)
#define kButtonWidth                  64
///< 书签/历史, 下载管理/文件管理table标签栏高度
#define kTableBarHeight               40
///< 按钮的左右边距
#define kButtonMarginLeftAndRight     15

// =================================================================
#pragma mark-
#pragma mark 背景和按钮文字颜色
// 图片资源
#define kToolBarBackgroundImage       @"ToolBar/BottombarBgImage.png"
#define kToolBarShadowImage           @"ToolBar/shadow.png"

// 图片资源
#define kButtonBgImage                @"ToolBar/BottombarTouchDown.png"
// 文字颜色
#define kBtnTitleColorNormal          @"Bottombar/DefaultButtonTextColor"
#define kBtnTitleColorDisable         @"Bottombar/DisableButtonTextColor"
#define kBtnTitleColorHighlight       @"Bottombar/HighlightButtonTextColor"

// =================================================================
#pragma mark-
#pragma mark 书签
// { 书签
// 书签正常状态
// 按钮名字
#define kNameEditBookMark              @"ButtonEditBookMark"
#define kNameBackBtn                   @"ButtonBack"
#define kNameBookMarkSynchro           @"ButtonBookMarkSynchro"

// 获取按钮文字
#define kTitleEditBookMark             @"UIToolBarButtons/EditBookMark"
#define kTitleBackBtn                  @"UIToolBarButtons/Back"
#define kTitleBookMarkSynchro          @"UIToolBarButtons/BookMarkSynchro"

// 书签编辑状态
// 按钮名字
#define kNameAddBookMark               @"ButtonAddBookMark"
#define kNameFinishBtn                 @"ButtonFinish"
#define kNameBookMarkSynchro           @"ButtonBookMarkSynchro"
// 获取按钮文字
#define kTitleAddBookMark              @"UIToolBarButtons/AddBookMark"
#define kTitleFinishBtn                @"UIToolBarButtons/Finish"
#define kTitleAddDirectory             @"UIToolBarButtons/AddDirectory"
// 书签}

// =================================================================
#pragma mark-
#pragma mark 历史
// { 历史
// 按钮名字
#define kNameClearBtn            @"ClearButton"
//#define kNameBackBtn             @"BackButton"
// 获取按钮文字
#define kTitleClearBtn           @"UIToolBarButtons/ClearHistory"
//#define kTitleBackBtn            @"UIToolBarButtons/Back"
// 历史}


#endif // #ifndef _UIViewBottomBarMacroDef_h_


// =======================测试日志宏定义=======================
// 上传代码时关闭测试宏
//#define BBM_LOG_DEBUG_ENABLE

#ifdef BBM_LOG_DEBUG_ENABLE

// 显示视图边线,查看视图大小和位置
#define BBM_SHOW_VIEW_BORDER

#endif // #ifdef BBM_LOG_DEBUG_ENABLE

