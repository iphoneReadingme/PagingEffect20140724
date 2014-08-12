

#import "TextPageViewController.h"
#import "PageAppViewController.h"
#import "DemoViewCoreTextDrawMacroDefine.h"


///< 私有方法
@interface PageAppViewController(/*PageAppViewController_Private*/)
<UIPageViewControllerDataSource>
{
	
}

@property (strong, nonatomic) UIPageViewController *pageController;

- (void)releaseObject;

@end

@implementation PageAppViewController


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
	self.pageController = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    // 设置UIPageViewController的配置项
	[self addUIPageViewController];
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
//	[self releaseObject];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// we support rotation in this view controller
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreaviewControllerAtIndexed.
}

// =================================================================
#pragma mark -
#pragma mark 子视图对象

- (CGRect)getViewRect
{
	CGRect frame = [self.view bounds];
	frame.origin.y += 20;
	frame.size.height -= 20;
	frame.size.height -= 40;
	
	return frame;
}

//2.初始化时，显示适当内容
- (void)addUIPageViewController
{
	// 设置UIPageViewController的配置项
	// 构建数据模型之后，我们创建了一个NSDictionary对象。
	// 这个NSDictionary中包含了一个options，用于page controrller对象的初始化选项。
	// 在这里，该选项指定了spine位于屏幕左侧（spine即书脊，书页装订的位置，书从另一侧翻阅）:
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    // 定义“这本书”的尺寸
//    [[_pageController view] setFrame:[[self view] bounds]];
    [[_pageController view] setFrame:[self getViewRect]];
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    TextPageViewController *initialViewController =[self getPageViewControllerForPageIndex:0];// 得到第一页
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward // 将导航方向设置为向前模式：
                               animated:NO
                             completion:nil];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
}

// 得到相应的VC对象
- (TextPageViewController *)getPageViewControllerForPageIndex:(NSUInteger)index
{
    // 创建一个新的控制器类，并且分配给相应的数据
    TextPageViewController *dataViewController = [TextPageViewController getPageViewControllerForPageIndex:index];
    return dataViewController;
}

#pragma mark- ==UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(TextPageViewController *)vc
{
    NSUInteger index = vc.pageIndex;
	NSLog(@"==index=%d, viewControllerBeforeViewController==", index);
    return [self getPageViewControllerForPageIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(TextPageViewController *)vc
{
    NSUInteger index = vc.pageIndex;
	NSLog(@"==index=%d, viewControllerAfterViewController==", index);
    return [self getPageViewControllerForPageIndex:(index + 1)];
}


@end

