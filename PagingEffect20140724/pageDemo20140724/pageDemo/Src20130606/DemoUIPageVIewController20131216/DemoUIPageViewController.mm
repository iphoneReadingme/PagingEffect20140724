

#import "DemoPageView.h"
#import "DemoUIPageViewController.h"
#import "PageAppViewController.h"
#import "DemoViewCoreTextDrawMacroDefine.h"


///< 私有方法
@interface DemoUIPageViewController(/*DemoUIPageViewController_Private*/)
{
	
}

@property (nonatomic, retain) DemoPageView * subDemoView;

- (void)releaseObject;
- (void)addSubViewObject;

@end

@implementation DemoUIPageViewController


+ (NSString *)displayName {
	return @"书籍翻页动画";
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
	
	PageAppViewController* controller = [[PageAppViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
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
	self.subDemoView = [[[DemoPageView alloc] initWithFrame:frame] autorelease];
	[self.view addSubview:_subDemoView];
}


@end

