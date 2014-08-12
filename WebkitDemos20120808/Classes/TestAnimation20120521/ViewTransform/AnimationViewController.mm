

#import "AnimationViewController.h"
#import "AnimationDemoView.h"
#import "AnimationMacroDefine.h"


///< 私有方法
@interface AnimationViewController(AnimationViewController_Private)

- (void)releaseObject;
- (void)addSubViewObject;

@end

@implementation AnimationViewController

// 2013-06-05
// http://www.cocoachina.com/newbie/tutorial/2013/0522/6258_2.html
// Core Animation基础介绍、简单使用CALayer以及多种动画效果

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
	
	// for test
	self.view.backgroundColor = [UIColor blueColor];
	self.view.layer.borderWidth = 2;
	self.view.layer.borderColor = [UIColor colorWithRed:0.0 green:1 blue:0.0 alpha:1.0].CGColor;
	CGRect rect = [self.view frame];
	rect = CGRectInset(rect, 20, 20);
	[self.view setFrame:rect];
	
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
	
	m_textText = [[NSString alloc] initWithFormat:@"capture crash log"];
	
#if !TARGET_IPHONE_SIMULATOR
	[m_textText autorelease];
#endif
	//m_textText = @"capture crash log";
}

- (void)viewDidAppear:(BOOL)animated
{
	CGRect rect = [self.view frame];
	rect = CGRectInset(rect, 20, 20);
	[self.view setFrame:rect];
	
	
	rect = CGRectInset(rect, 20, 20);
	[m_pSubView setFrame:rect];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[m_pSubView removeFromSuperview];
	[self releaseObject];
	
	[m_textText retainCount];
	[m_textText release];
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	
}

- (void)viewWillLayoutSubviews
{
	
}

// =================================================================
#pragma mark -
#pragma mark 屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// we support rotation in this view controller
	return YES;
}

// 屏幕即将旋转 layoutSubviews执行之前发生
// Notifies when rotation begins, reaches halfway point and ends.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	
}

// 屏幕即将旋转 layoutSubviews执行之后发生
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
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

