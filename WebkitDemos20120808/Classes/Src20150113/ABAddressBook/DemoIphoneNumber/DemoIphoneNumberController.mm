
#import "DemoIphoneNumberView.h"
#import "DemoIphoneNumberController.h"


///< 私有方法
@interface DemoIphoneNumberController()

@property (nonatomic, retain) DemoIphoneNumberView* demoSubView;

- (void)releaseObject;
- (void)addSubViewObject;

@end

@implementation DemoIphoneNumberController


+ (NSString *)displayName {
	return @"2015-03-11读写电话号码 demo";
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	[_demoSubView release];
	_demoSubView = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
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
	[self addSubViewObject];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[_demoSubView removeFromSuperview];
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
	_demoSubView = [[DemoIphoneNumberView alloc] initWithFrame:[self.view bounds]];
	[self.view addSubview:_demoSubView];
}


@end

