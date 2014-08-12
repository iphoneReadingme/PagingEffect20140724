
//  Created by yangfs on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

/*
 
 File             =  iUIWebKitMacroDefine.h
 Description  =  宏定义.
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-06
 
 */


#ifndef _iUIWebKitMacroDefine_H_
#define _iUIWebKitMacroDefine_H_



// =======================测试日志宏定义=======================
// 上传代码时关闭测试宏
#define WKMD_LOG_DEBUG_ENABLE

#ifdef WKMD_LOG_DEBUG_ENABLE



#define WKMD_PRINT_TEST_LOG
#define WKMD_PRINT_TEST_LOG_FOR_SUBVIEW

#define WKMD_LOG_NSLOG(...)                       NSLog(__VA_ARGS__)
#define WKMD_LOG_NSAssert(...)                       NSAssert(__VA_ARGS__)
#define WKMD_LOG_NSAssert1(...)                      NSAssert1(__VA_ARGS__)
#else
#define WKMD_LOG_NSLOG(...)                      do{}while(0)
#define WKMD_LOG_NSAssert(...)                     do{}while(0)
#define WKMD_LOG_NSAssert1(...)                     do{}while(0)
#endif
// =======================测试日志宏定义=======================



#define kURLAboutBlank            @"about:blank"
#define kURLDefaultString          @"http://www.sina.com"
//#define kURLDefaultString          @"http://app.3g.cn/?fr=webbottom"
#define kURL3gsinaString            @"http://3g.sina.com.cn"

#define   kBorderLineWidth                    4
#define   kNavgationBarH                       44

// 顶部工具栏
#define    kTopBarHeight                        40

// 底部地址栏
#define    kToolBarHeight                        44
#define    kToolBarButtonHeight              40
#define    kToolBarButtonWidth               44
#define    kToolBarSpace                         10





#endif // #ifndef _iUIWebKitMacroDefine_H_
