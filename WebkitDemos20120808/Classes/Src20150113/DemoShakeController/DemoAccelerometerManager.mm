
#import <UIKit/UIKit.h>
#import "DemoAccelerometerManager.h"
#import <CoreMotion/CoreMotion.h>


///< 私有方法
@interface DemoAccelerometerManager()

@property (nonatomic, retain) CMMotionManager* motionManager;

@property (nonatomic, assign) id userObj;
@property (nonatomic, assign) SEL userSelector;

@end


@implementation DemoAccelerometerManager

+ (instancetype)sharedInstance
{
	static DemoAccelerometerManager *g_instance = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		if (!g_instance)
		{
			g_instance = [[DemoAccelerometerManager alloc] init];
		}
	});
	
	return g_instance;
}

- (void)dealloc
{
	[self removeObserver];
	
	[_motionManager release];
	_motionManager = nil;
	
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self)
	{
//		[self initMotionManager];
		
		[self addObserver];
	}
	
	return self;
}

- (void)setUserSelector:(SEL)aSelector withObj:(id)obj
{
	self.userSelector = aSelector;
	_userObj = obj;
}

- (void)initMotionManager
{
	if (_motionManager == nil)
	{
		_motionManager = [[CMMotionManager alloc] init];
	}
	
	if (!_motionManager.accelerometerAvailable)
	{
		// fail code // 检查传感器到底在设备上是否可用
		NSLog(@" fail shake....");
	}
	else
	{
		//设置频率值，适合游戏和大部分app的检测
		///< //加速仪更新频率，以秒为单位
		_motionManager.accelerometerUpdateInterval = 0.1;
		[self startAccelerometer];
	}
}

- (void)addObserver
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didEnterBackgroundNotification:)
												 name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willEnterForegroundNotification:)
												 name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)removeObserver
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationWillEnterForegroundNotification object:nil];
}

///< 开始接收加速仪数据
-(void)startAccelerometer
{
	//以push的方式更新并在block中接收加速度
	[_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init]
											 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
												 [self outputAccelertionData:accelerometerData.acceleration];
												 if (error) {
													 NSLog(@"motion error:%@",error);
												 }
											 }];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
	//综合3个方向的加速度
	double accelerameter =sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z ,2));
	//当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
	if (accelerameter>2.3f)
	{
		//立即停止更新加速仪（很重要！）
		[self.motionManager stopAccelerometerUpdates];
		dispatch_async(dispatch_get_main_queue(), ^{
			//UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
			
			[self performSelector:@selector(onShakeChangeTheme)];
		});
	}
}

- (void)onShakeChangeTheme
{
	[_userObj performSelector:_userSelector];
}

#pragma mark - == notifications

//对应上面的通知中心回调的消息接收
-(void)didEnterBackgroundNotification:(NSNotification *)notification
{
	[_motionManager stopAccelerometerUpdates];
}

-(void)willEnterForegroundNotification:(NSNotification *)notification
{
	[self startAccelerometer];
}

@end


