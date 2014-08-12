

#import "DemoViewCALayerController.h"
#import "DemoViewCALayer.h"
#import "DemoViewCALayerMacroDefine.h"


///< 私有方法
@interface DemoViewCALayerController(DemoViewCALayerController_Private)

- (void)releaseObject;
- (void)addSubViewObject;

@end

@implementation DemoViewCALayerController


+ (NSString *)displayName {
	return @"简单使用CALayer";
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	[m_pSubView release];
	m_pSubView = nil;
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
	[m_pSubView removeFromSuperview];
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
	m_pSubView = [[DemoViewCALayer alloc] initWithFrame:[self.view bounds]];
	[self.view addSubview:m_pSubView];
}


@end

