//
//  GenericInterfaceAccelerator.h
//  Acceleration
//
//  Created by zhu anthony on 1/13/10.
//  Copyright 2010 ucweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GenericInterfaceAccelerator : NSObject <UIAccelerometerDelegate> {
	
	UIAccelerometer *accel;
	NSTimeInterval ctrlTimeThreshold;
	float granularityX;
	float granularityY;
	float granularityZ;
	id    userInfo;
	SEL   userSelector;
	
}

+ (GenericInterfaceAccelerator*)instance;

@property (nonatomic) NSTimeInterval ctrlTimeThreshold;
- (bool) createUIAccelerometer:(NSTimeInterval)controlTimeThreshold timeInterval:(NSTimeInterval)checkInterval GranularityX:(float) granuX GranularityY:(float) granuY GranularityZ:(float) granuZ UserINfo:(id)info UserSelector:(SEL)aSelector; 
- (bool) directCreateUiAccelerometer:(id)info UserSelector:(SEL)aSelector;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
@end
