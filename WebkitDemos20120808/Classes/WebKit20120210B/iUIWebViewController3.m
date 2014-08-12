
#import "iUIWebKitMacroDefine.h"
#import "iUIWebViewController3.h"


#import "SDURLCache.h"



// http://www.cocoachina.com/bbs/read.php?tid-6296-fpage-2.html
//关于UIWebView载入数据及图片的两种方法：
//第一种：在html中实现。
//第二种：直接用UIWebView实用。

@implementation iUIWebViewController3

//@synthesize myWebView;

+ (NSString *)displayName {
	return @"Webkit 简单测试页面3";
}

- (void)dealloc
{
	[self releaseObject];
	
	[super dealloc];
}

- (void)releaseObject
{
	[m_pWebView stopLoading];
	m_pWebView.delegate = nil;
	[m_pWebView release];
	m_pWebView = nil;
	
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (![[NSURLCache sharedURLCache] isKindOfClass:[SDURLCache class]])
	{
		[NSURLCache setSharedURLCache:[[[SDURLCache alloc] initWithMemoryCapacity:0 
																	 diskCapacity:1024*1024*50 
																		 diskPath:[SDURLCache defaultCachePath]] autorelease]];
	}
	
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

- (void)initObjects
{
	
	//[self testNavigationController];
	//self.title = NSLocalizedString(@"WebTitle", @"");
	m_pSelfView = self.view;
	m_pSelfView.backgroundColor = [UIColor blueColor];
	m_pSelfView.layer.borderWidth = 2;
	m_pSelfView.layer.borderColor = [UIColor colorWithRed:0.99 green:0.0 blue:1.0 alpha:0.990].CGColor;
	
	// =========================
	CGRect selfFrame = [m_pSelfView frame];
	// UIWebView 视图
	CGRect webViewRect = selfFrame;
	webViewRect.origin = CGPointZero;
	webViewRect.size.height -= (kToolBarHeight + kBorderLineWidth)*1;
	webViewRect = CGRectInset(webViewRect, kBorderLineWidth, kBorderLineWidth);
	// 创建一个webview
	//m_pWebView = [[iUIWebViewManager sharedInstance] addNewWebPage2:webViewRect];
	// 创建一个层用来放 webview
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	//webFrame.origin.y = 0;	// leave from the URL input field and its label
	//webFrame.size.height = frame.size.height;
	//webFrame.size.height = 250;
	webFrame = selfFrame;
	m_pWebView = [[UIWebView alloc] initWithFrame:webFrame];
	
	NSString* pURL = kURLDefaultString;
	
	[m_pWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pURL]]];
	[m_pSelfView addSubview:m_pWebView];
}

#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	[self initObjects];
	//m_pWebView.delegate = self;	// setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self releaseObject];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// we support rotation in this view controller
	return YES;
}

// =================================================================
#pragma mark -
#pragma mark UIWebViewDelegate 代理方法

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

//数据加载完 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

@end

