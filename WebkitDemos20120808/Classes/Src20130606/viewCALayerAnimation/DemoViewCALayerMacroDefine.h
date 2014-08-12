/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: DemoViewCALayerController.h
 *
 * Description	: Core Animation基础介绍、简单使用CALayer以及多种动画效果
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on 2013-06-06.
 * History		: modify: 2013-06-06.
 *
 ******************************************************************************
 **/




// =======================测试日志宏定义=======================
// 上传代码时关闭测试宏  CALayer macro define


// for test, should comment before committed
#define CALMD_LOG_DEBUG_ENABLE

#ifdef CALMD_LOG_DEBUG_ENABLE

#define CALMD_LOG_NSLOG(...)                       NSLog(__VA_ARGS__)
#else
#define CALMD_LOG_NSLOG(...)                       do{}while(0)
#endif
// =======================测试日志宏定义=======================
