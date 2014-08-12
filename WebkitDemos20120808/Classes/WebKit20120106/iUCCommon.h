
/*
 
 Copyright (C) 2010 _your name_. All Rights Reserved.
 
 File             =  iUCCommon.h
 Description  =  实现一些通用方法
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2011-11-08
 
 // 实现一些通用方法, 减少代码重复
 // add by yangfs 2011-11-08 UC8.1 正式版本
 */

#ifndef _IUCWEB_iUCCommon_H_
#define _IUCWEB_iUCCommon_H_


#define SAFERELEASE_VIEWOBJECT(pView)     {[pView release]; pView = nil;}



class iUCCommon
{
	
public:
	
	enum PLATFORM_TYPE
	{
		PLATFORM_UNKNOW,
		PLATFORM_PPC2003,
		PLATFORM_PPC2005,
		PLATFORM_SP2003,
		PLATFORM_SP2005,
		PLATFORM_WINCE,
		PLATFORM_WIN32,
		PLATFORM_IPOHNE1,
		PLATFORM_IPOHNE2,
		PLATFORM_IPOHNE3,
		PLATFORM_IPOHNE4,
		PLATFORM_IPOHNE5,
		PLATFORM_LINUX_QT,
	};
	
	static PLATFORM_TYPE GetPlatform();
	
	static float iGetSystemVersion();
	// 获取当前年月日
	static void  getCurDate(int& year,int& month, int& day);
	// 判断是否为闰年
	static int isLeap(int year);
	// 从指定年月日到当前的秒数
	//static unsigned long getSecondsFromYMD(int year=0, int month=0, int day=0);
	// 获取从1970年1月1日0点到现在的秒数
	static unsigned long getSecondsFrom19700101();
	// 从指定年月日到当前的天数
	static unsigned int getDaysFromYMD(int year=0, int month=0, int day=0);
	
	static void setColor(float pColol[4], unsigned int nRGB, float fAlpha);
	
	static void testMCDAD(void *adlist, unsigned long nSeconds);
	
#define UIIMAGEREF    void*
	// 由buffer提供图片数据创建UIImage图片
	static UIIMAGEREF CreadNewImage(const void *bytes, unsigned int length);
};



// =======================测试日志宏定义=======================
// 上传代码时关闭测试宏
//#define COM_LOG_DEBUG_ENABLE

// URL: 输入及自定义书签 URL 相关
//#define COM_FAV_URL_ENABLE

// =====================================================================
// URL: 输入及自定义书签 URL 相关
#ifdef COM_FAV_URL_ENABLE
// 添加自定义书签
#define _ENABLE_TEST_ADD_FAV_CUSTOM_
// 自定义URL(输入框历史URL)
#define _ENABLE_TEST_URL_INPUT_EDIT
#endif // #ifdef COM_FAV_URL_ENABLE

// =====================================================================
// 测试相关
#ifdef COM_LOG_DEBUG_ENABLE
//#import <UIKit/UIKit.h>

// 测试查看CDparam参数内容
#define _ENABLE_CDparam_TEST

// 打印搜索分类测试信息
//#define COM_USER_TEST_Search_Type_log

// 打印统计数据发送时的服务器URL
#define UC_TEST_SHOW_SYNSERVERURL

// 使用测试环境 dispatcher服务器
#define COM_USER_TEST_DISPATCHER_URL

// 更新首页导航数据和广告的测试
//#define COM_UPDATE_NAV_AD_DATA
// 广告测试
//#define COM_AD_TEST_MACRO

// 互动消息显示测试
//#define COM_POP_MSG_TEST_MACRO

#define COM_LOG_NSLOG(...)                       NSLog(__VA_ARGS__)
#define COM_LOG_LOGW(...)                        LOGW(__VA_ARGS__)
#else
#define COM_LOG_NSLOG(...)                      do{}while(0)
#define COM_LOG_LOGW(...)                       do{}while(0)
#endif
// =======================测试日志宏定义=======================

#endif // #ifndef _IUCWEB_iUCCommon_H_
