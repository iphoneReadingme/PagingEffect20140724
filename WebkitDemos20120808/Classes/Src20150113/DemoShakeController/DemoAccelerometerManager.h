
/*
 *****************************************************************************
 * Copyright (C) 2005-2014 UC Mobile Limited. All Rights Reserved
 * File			: DemoAccelerometerManager.h
 *
 * Description	: 设备摇一摇功能触发事件视图 demo 【ios 6.x 以上】
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-03-27.
 * History		: modify: 2015-03-27.
 *
 ******************************************************************************
 **/


///< 测试开关
#define Enable_Test_Accelerometer_Manager
#ifdef Enable_Test_Accelerometer_Manager

@interface DemoAccelerometerManager : NSObject
{
}

+ (instancetype)sharedInstance;

- (void)initMotionManager;

- (void)setUserSelector:(SEL)aSelector withObj:(id)obj;

@end

#endif
