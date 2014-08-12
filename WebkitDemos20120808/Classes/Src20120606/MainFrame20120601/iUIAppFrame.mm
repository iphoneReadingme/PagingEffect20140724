

#import <UIKit/UIKit.h>
#import "iUIAppFrame.h"


@implementation iUIAppFrame

+ (iUIAppFrame*)shareInstance
{
	static iUIAppFrame* _instance = NULL;
	if(!_instance)
	{
		_instance = [[iUIAppFrame alloc] init];
	}
	return _instance;
}

- (id)init
{
    if (self = [super init])
	{
		
	}
	return self;
}

- (void)dealloc 
{
	
	[super dealloc];
}

- (int)getCmdBarHeight
{
	return 40;
}

- (UIInterfaceOrientation)getCurInterfaceOrientation
{
	return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)hiddenSystemStatusBarOnFullScreen:(BOOL)bHidden
{
	[UIApplication sharedApplication].statusBarHidden = bHidden;
}

@end
