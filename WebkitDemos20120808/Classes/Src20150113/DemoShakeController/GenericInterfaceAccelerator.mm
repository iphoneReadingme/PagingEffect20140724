//
//  GenericInterfaceAccelerator.m
//  Acceleration
//
//  Created by zhu anthony on 1/13/10.
//  Copyright 2010 ucweb. All rights reserved.
//
#define IF_PARAM_EXITS(PARAM) if((PARAM)!=nil)
#define IF_PARAM_VALID(PARAM) if((PARAM)!=0)

#import "GenericInterfaceAccelerator.h"
//#import "IPhoneBaseDef.h"
//#import "iIPhoneTools.h"

GenericInterfaceAccelerator* g_accelAccessory = NULL;

@implementation GenericInterfaceAccelerator
@synthesize ctrlTimeThreshold;


+ (instancetype)instance
{
	if (g_accelAccessory == NULL)
	{
		g_accelAccessory = [[GenericInterfaceAccelerator alloc] init];
	}
	return g_accelAccessory;
}

- (bool) createUIAccelerometer:(NSTimeInterval)controlTimeThreshold timeInterval:(NSTimeInterval)checkInterval GranularityX:(float) granuX GranularityY:(float) granuY GranularityZ:(float) granuZ UserINfo:(id)info UserSelector:(SEL)aSelector
{
	accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	IF_PARAM_VALID(controlTimeThreshold)
	{
		ctrlTimeThreshold = controlTimeThreshold;
	}
	else{
		ctrlTimeThreshold = 5.0;
	}
	
	IF_PARAM_VALID(checkInterval)
	{
		accel.updateInterval = checkInterval;
	}
	else
	{
		accel.updateInterval = 1/100;
	}
	
	IF_PARAM_VALID(granuX)
	{
		granularityX = granuX;
	}
	else
	{
		granularityX = 2.3;
	}
	
	IF_PARAM_VALID(granuY)
	{
		granularityY = granuY;
	}
	else
	{
		granularityY = 2.3;
	}
	
	IF_PARAM_VALID(granuZ)
	{
		granularityZ = granuZ;
	}
	else
	{
		granularityZ = 2.3;
	}
	
	IF_PARAM_EXITS(info)
	{
		userInfo = info;
	}
	else 
	{
		userInfo = nil;
		return NO;
	}
	
	IF_PARAM_EXITS(aSelector)
	{
		userSelector = aSelector;
	}
	else
	{
		userSelector = nil;
		return NO;
	}
	return YES;
}

- (bool) directCreateUiAccelerometer:(id)info UserSelector:(SEL)aSelector
{
	bool returnValue;
	returnValue =  [self createUIAccelerometer:1.5 timeInterval:1/60 GranularityX:1.95 GranularityY:1.95 GranularityZ:100 UserINfo:info UserSelector:aSelector];//anthzhu modifies the gap between user interaction to fit for 7.4 at 2010-09-17

	return returnValue;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	static int g_shakeCount = 0;
	if(g_shakeCount++ < 10) ///< 防止主线程阻塞导致多次响应摇晃事件的bug
	{
		return ;
	}
	
	static bool userSelectorTrigger = NO;
	static NSDate *shakeStart = nil;
	NSDate *now = [[NSDate alloc]init];
	NSDate *checkDate = nil;
	if(fabsf(acceleration.x) > granularityX
	   ||fabsf(acceleration.y) > granularityY
	   ||fabsf(acceleration.z) > granularityZ)
	{
		if(shakeStart!=nil)
		{
            // Time abnormal, shakeStart should not later than now
            // reset shakeStart
            if ([now compare:shakeStart] == NSOrderedAscending)
            {
                [shakeStart release];
                shakeStart = nil;
            }
            else
            {
                checkDate = [[NSDate alloc]initWithTimeInterval:self.ctrlTimeThreshold sinceDate:shakeStart];
            }
		}
		
		if(checkDate!=nil)
		{
			if([now compare:checkDate] == NSOrderedDescending )
			{
				[shakeStart release];
				shakeStart = [[NSDate alloc]init];
				userSelectorTrigger = NO;
			}
		}
		else
		{
			shakeStart = [[NSDate alloc]init];
			userSelectorTrigger = NO;
		}
		
		[now release];
		if(checkDate!=nil)
		{
			[checkDate release];
		}
		if(userSelectorTrigger==NO)
		{
			userSelectorTrigger = YES;
			if(userInfo!=nil)
			{
				g_shakeCount = 0;
				[userInfo performSelector:userSelector];
				//NSLog(@"anthzhu shake interface triggered");
			}
		}
	}
	else
	{
		[now release];
	}
}

- (void)dealloc 
{
	[accel release];
    [super dealloc];
}

@end
