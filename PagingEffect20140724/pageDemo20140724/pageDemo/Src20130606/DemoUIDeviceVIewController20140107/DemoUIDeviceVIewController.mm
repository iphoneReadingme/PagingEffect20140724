

#import "DeviceDiskConsumeStatusView.h"
#import "DemoUIDeviceVIewController.h"
//#import "PageAppViewController.h"
#import "DemoViewCoreTextDrawMacroDefine.h"


///< 私有方法
@interface DemoUIDeviceVIewController(/*DemoUIPageViewController_Private*/)
{
	
}

@property (nonatomic, retain) DeviceDiskConsumeStatusView * subDemoView;

- (void)releaseObject;
- (void)addSubViewObject;

@end

@implementation DemoUIDeviceVIewController


+ (NSString *)displayName {
	return @"获取iOS设备的硬盘大小";
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	self.subDemoView = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self addSubViewObject];
	
//	PageAppViewController* controller = [[PageAppViewController alloc] init];
//	[self.navigationController pushViewController:controller animated:YES];
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1  ///<ios6
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	// release and set to nil
}
#endif

#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
	[_subDemoView removeFromSuperview];
	[self releaseObject];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// we support rotation in this view controller
	return YES;
}

// =================================================================
#pragma mark -
#pragma mark 子视图对象

- (void)addSubViewObject
{
	CGRect frame = [self.view bounds];
	frame.origin.y += 20;
	frame.size.height -= 20;
	frame.size.height -= 40;
	self.subDemoView = [[[DeviceDiskConsumeStatusView alloc] initWithFrame:frame] autorelease];
	[self.view addSubview:_subDemoView];
}


@end

