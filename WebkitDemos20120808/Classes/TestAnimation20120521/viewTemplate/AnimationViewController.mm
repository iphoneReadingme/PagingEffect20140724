

#import "AnimationViewController.h"
#import "AnimationDemoView.h"
#import "AnimationMacroDefine.h"


///< 私有方法
@interface AnimationViewController(AnimationViewController_Private)

- (void)releaseObject;
- (void)addSubViewObject;

@end

@implementation AnimationViewController


+ (NSString *)displayName {
	return @"动画测试";
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
- (void)viewDidUnload
{
	[super viewDidUnload];
	
	// release and set to nil
	
}

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
	m_pSubView = [[AnimationDemoView alloc] initWithFrame:[self.view bounds]];
	[self.view addSubview:m_pSubView];
}


@end

