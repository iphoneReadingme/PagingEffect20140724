

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
	NSString* message = @"月落乌啼霜[U+1版本352]满天，\n江枫渔火对[U+1F353]🍒愁眠；\n姑苏[U+[U+1f352]🍒城外寒山寺，\n夜半钟声到客船。\n当前版本过旧，可能会造成系统不稳定。建议立即[U+1F353]🍓升级。\n/Users/yangfs/Library/Developer/CoreSimulator/Devices/2B9D9536-908B-46E7-9D1F-75065EF6372D/data/Containers/Bundle/Application/E6360C6C-F95F-4CD6-80A5-0ABD3702F76B/UCWEB.app";
	
	NSMutableString *pageContent = [NSMutableString stringWithFormat:@"   当前页面\n 第[%d]页\n\n是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)是否触发手势(上下拉事件控制)%@", pageIndex+1, message];
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

