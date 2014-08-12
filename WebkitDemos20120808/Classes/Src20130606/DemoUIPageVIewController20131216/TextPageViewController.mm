

#import "TextPageViewController.h"
#import "DemoViewCoreTextDrawMacroDefine.h"


#define kKeyMaxCountOfPage    10

@interface TextPageViewController ()
{
    NSUInteger _pageIndex;
}

@property (nonatomic, retain) UITextView* pageView;

@end

@implementation TextPageViewController

+ (TextPageViewController*)getPageViewControllerForPageIndex:(NSUInteger)pageIndex
{
    if (pageIndex < kKeyMaxCountOfPage)
    {
        return [[self alloc] initWithPageIndex:pageIndex];
    }
    return nil;
}

+ (NSString *)displayName
{
	return @"书籍翻页动画";
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	self.pageView = nil;
}

- (id)initWithPageIndex:(NSInteger)pageIndex
{
    self = [super init];
    if (self)
    {
        _pageIndex = pageIndex;
    }
    return self;
}

- (NSInteger)pageIndex
{
    return _pageIndex;
}

// (this can also be defined in Info.plist via UISupportedInterfaceOrientations)
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self addSubViewObject];
}

#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
//	[self releaseObject];
}

// =================================================================
#pragma mark -
#pragma mark 子视图对象

- (NSString*)getPageContentText:(int)pageIndex
{
	NSMutableString *pageContent = [NSMutableString stringWithFormat:@"   当前页面\n 第[%d]页\n\n是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)", pageIndex+1];
    for(int i=0;i<100;i++)
    {
        [pageContent appendFormat:@"%d", pageIndex+1];
    }
	
	return pageContent;
}

- (void)addSubViewObject
{
	CGRect frame = [self.view bounds];
	frame.origin.y += 40;
	frame.size.height -= frame.origin.y;
	self.pageView = [[[UITextView alloc] initWithFrame:frame] autorelease];
	
	_pageView.editable = NO;
	_pageView.text = [self getPageContentText:_pageIndex];
	_pageView.layer.borderColor = [UIColor redColor].CGColor;
	_pageView.layer.borderWidth = 2;
	[self.view addSubview:_pageView];
}


@end

