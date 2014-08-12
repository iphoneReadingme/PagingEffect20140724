
#import "iUIWebKitMacroDefine.h"
#import "iUIWebViewManager.h"
#import "iUIWebView.h"

#import "iUIWebMainView.h"
#import "WebViewController.h"

#import "iUIToolBarView.h"
#import "iUIURLTextField.h"
#import "SDURLCache.h"



// http://www.cocoachina.com/bbs/read.php?tid-6296-fpage-2.html
//关于UIWebView载入数据及图片的两种方法：
//第一种：在html中实现。
//第二种：直接用UIWebView实用。

@implementation WebViewController

//@synthesize myWebView;

+ (NSString *)displayName {
	return @"Webkit 页面";
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
	
	[m_pToolBarView removeFromSuperview];
	[m_pToolBarView release];
	m_pToolBarView = nil;
	
	[m_pWebMainView removeFromSuperview];
	[m_pWebMainView release];
	m_pWebMainView = nil;
	
	[m_pURLAddressView removeFromSuperview];
	[m_pURLAddressView release];
	m_pURLAddressView = nil;
	
	[[iUIWebViewManager sharedInstance] releaseObject];
}

- (void)testNavigationController
{
	WKMD_LOG_NSLOG(@"%@", self);
	WKMD_LOG_NSLOG(@"%@", m_pSelfView);
	WKMD_LOG_NSLOG(@"%@", [self navigationController]);
	WKMD_LOG_NSLOG(@"%@", [self navigationController].view);
	//[self navigationController].view.alpha = 0.5;
	
	
	UIView* subView = nil;
	UIView* pSubView2 = nil;
	UIView* pParentView = [self navigationController].view;
	
	int nCount = [[pParentView subviews] count];
	int i = 0;
	for(; i < nCount; ++i)
	{
		subView = [[pParentView subviews] objectAtIndex:i];
		WKMD_LOG_NSLOG(@"\n\n\n[i=%d] ==%@\n", i, subView);
		
		int nSubCount = [[subView subviews] count];
		int j = 0;
		for(; j < nSubCount; ++j)
		{
			pSubView2 = [[subView subviews] objectAtIndex:j];
			WKMD_LOG_NSLOG(@"[j=%d] ==%@", j, pSubView2);
		}
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//exchangeImplementations();
	//exchangeImplementationsOnAppStore();
	[iUIWebView exchangeImplementations];
	//[iUIWebView exchangeImplementationsOnAppStore];
	
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_5_1  ///<ios6
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	// release and set to nil
}
#endif

- (void)initObjects
{
	
	//[self testNavigationController];
	//self.title = NSLocalizedString(@"WebTitle", @"");
	m_pSelfView = self.view;
	m_pSelfView.backgroundColor = [UIColor blueColor];
	m_pSelfView.layer.borderWidth = 2;
	m_pSelfView.layer.borderColor = [UIColor colorWithRed:0.99 green:0.0 blue:1.0 alpha:0.990].CGColor;
	
	// 测试视图
	CGRect selfFrame = [[UIScreen mainScreen] applicationFrame];
	selfFrame.origin.x = 0;
	selfFrame.origin.y = 0;
	selfFrame.size.height -= kNavgationBarH;
	m_pWebMainView = [[iUIWebMainView alloc] initWithFrame:selfFrame];
	[m_pSelfView addSubview:m_pWebMainView];
	
	// =========================
	// UIWebView 视图
	CGRect webViewRect = selfFrame;
	webViewRect.origin = CGPointZero;
	webViewRect.size.height -= (kToolBarHeight + kBorderLineWidth)*1;
	webViewRect = CGRectInset(webViewRect, kBorderLineWidth, kBorderLineWidth);
	// 创建一个webview
	m_pWebView = [[iUIWebViewManager sharedInstance] addNewWebPage:webViewRect];
	[m_pWebMainView addSubview: [[iUIWebViewManager sharedInstance] getCurrentWebPage]];
	NSString* pURL = kURLDefaultString;
	[(iUIWebView*)[[iUIWebViewManager sharedInstance] getCurrentWebPage] startNewRequest:pURL];
	//[[self navigationController].view addSubview:m_pWebView];
	
	// =========================
	// 地址栏
	CGRect rectURL = webViewRect;
	rectURL.size.height = kToolBarHeight;
	rectURL.origin.y = selfFrame.size.height - rectURL.size.height - kBorderLineWidth;
	[self addURLInputBox:rectURL];
	
	// =========================
	// 底部工具栏
	CGRect rectToolBar = rectURL;
	[self addToolBar:rectToolBar];
	// =========================
}

#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	[self initObjects];
	[[[iUIWebViewManager sharedInstance] getCurrentWebPage] setDelegate:self];	// setup the delegate as the web view is shown
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

// this helps dismiss the keyboard when the "Done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	//[self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[textField text]]]];
	
	NSString *path = @"3g.sina.com.cn";
	path = @"http://uctest.ucweb.com:81/zhouwj/";
	NSURL *url = [NSURL URLWithString:path]; 
	[[[iUIWebViewManager sharedInstance] getCurrentWebPage] loadRequest:[NSURLRequest requestWithURL:url]];
	
	return YES;
}


- (void) addToolBar:(CGRect)frame
{
	CGRect toolBarFrame = CGRectInset(frame, kBorderLineWidth, kBorderLineWidth);
	toolBarFrame = frame;
	m_pToolBarView = [[iUIToolBarView alloc] initWithFrame:toolBarFrame];
	[m_pToolBarView setWebViewController:self];
	[m_pWebMainView addSubview:m_pToolBarView];
	[[iUIWebViewManager sharedInstance] setToolBarView:m_pToolBarView];
	//[m_pToolBarView updateButtonsStatus];
}

- (void)addURLInputBox:(CGRect)frame
{
	CGRect selfFrame = [m_pSelfView frame];
	//selfFrame = frame;
	
	CGRect textFieldFrame = CGRectMake(0, selfFrame.size.height - kTopBarHeight - kToolBarHeight, self.view.bounds.size.width, kTopBarHeight);
	textFieldFrame = CGRectInset(frame, kBorderLineWidth, kBorderLineWidth);
	//UITextField *urlField = [[UITextField alloc] initWithFrame:textFieldFrame];
	iUIURLTextField *urlField = [[iUIURLTextField alloc] initWithFrame:textFieldFrame];
	urlField.borderStyle = UITextBorderStyleBezel;
	urlField.textColor = [UIColor blackColor];
	urlField.delegate = self;
	urlField.placeholder = @"<enter a URL>";
	urlField.text = kURLDefaultString;
	urlField.backgroundColor = [UIColor whiteColor];
	urlField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	urlField.returnKeyType = UIReturnKeyGo;
	urlField.keyboardType = UIKeyboardTypeURL;	// this makes the keyboard more friendly for typing URLs
	urlField.autocapitalizationType = UITextAutocapitalizationTypeNone;	// don't capitalize
	urlField.autocorrectionType = UITextAutocorrectionTypeNo;	// we don't like autocompletion while typing
	urlField.clearButtonMode = UITextFieldViewModeAlways;
	[urlField setAccessibilityLabel:NSLocalizedString(@"URLTextField", @"")];
	//[m_pWebMainView addSubview:urlField];
	m_pURLAddressView = urlField;
	//[urlField release];
	
	[[iUIWebViewManager sharedInstance] setURLAddressView:m_pURLAddressView];
	
	[self addAdressBar:CGRectZero];
}

// URL输入地址视图
- (void)addAdressBar:(CGRect)frame
{
	UINavigationBar* pNavBar = [[self navigationController] navigationBar];
	CGRect frameNavBar = [pNavBar frame];
	frameNavBar.origin = CGPointZero;
	CGRect rect = CGRectInset(frameNavBar, kBorderLineWidth, kBorderLineWidth);
	
#define kBackBtnOfNavItem     (40)
	rect.origin.x += kBackBtnOfNavItem;
	rect.size.width -= kBackBtnOfNavItem;
	[m_pURLAddressView setFrame:rect];
	[pNavBar addSubview:m_pURLAddressView];
}

- (NSString*)getURLFromAddressBar
{
	NSString* pURL = nil;
	pURL = m_pURLAddressView.text;
	return pURL;
}
// =================================================================
#pragma mark -
#pragma mark UIWebViewDelegate 代理方法

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	m_pWebView = [[iUIWebViewManager sharedInstance] getCurrentWebPage];
	[(iUIWebView*)[[iUIWebViewManager sharedInstance] getCurrentWebPage] webViewDidStartLoad:webView];
}

//数据加载完 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	m_pWebView = [[iUIWebViewManager sharedInstance] getCurrentWebPage];
	[(iUIWebView*)[[iUIWebViewManager sharedInstance] getCurrentWebPage] webViewDidFinishLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[(iUIWebView*)[[iUIWebViewManager sharedInstance] getCurrentWebPage] webView:webView didFailLoadWithError:error];
}

@end

