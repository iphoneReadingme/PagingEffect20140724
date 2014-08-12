//
//  iUIMediaRootView.mm
//  YFS_Sim111027_i42
//
//  Created by yangfs on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//#import "iUIWebViewJavaScript.h"
#import "iUIWebView.h"
#import "iUIWebViewManager.h"
#import "iUIWebKitMacroDefine.h"
#import "UISwipeGestureSingleEx.h"
//#import "UISwipeGestureDouble.h"

// 加载一个页面过程中, 发起request的次数据, 用来查看UIWebView 在"前进"/"后退"过程中, 请求了哪些数据
int m_nRequestCount;
// =================================================================
#pragma mark -
#pragma mark 实现iUIWebView

@implementation iUIWebView


- (void)handleSwipeFromEx:(UISwipeGestureSingleEx *)recognizer
{
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Initialization code.
		[self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		//[self setAutoresizesSubviews:YES];
		//self.scalesPageToFit = YES;
		//NSUInteger n = self.dataDetectorTypes;
		//self.dataDetectorTypes = UIDataDetectorTypeLink;	//zds add 2010-01-29,不检查电话号码
		
		[self addViews];
		
		
		//---bottom to top swipe---
		UISwipeGestureSingleEx* swipeRecognizer = nil;
		// 从上向下手势识别
		swipeRecognizer = [[UISwipeGestureSingleEx alloc] initWithTarget:self action:@selector(handleSwipeFromEx:)];
		[self addGestureRecognizer:swipeRecognizer];
		[swipeRecognizer release];
//		UISwipeGestureDouble* swipeRecognizer = nil;
//		// 从上向下手势识别
//		swipeRecognizer = [[UISwipeGestureDouble alloc] initWithTarget:self action:@selector(handleSwipeFromEx:)];
//		[self addGestureRecognizer:swipeRecognizer];
//		[swipeRecognizer release];
	}
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
	[self releaseObject];
    [super dealloc];
}

//=====================================================================
-(void)releaseObject
{
	
}

-(void)addViews
{
	//CGRect selfFrame = [self frame];
	[self initData];
	
}

- (void)initData
{
	// 设置UIWebView透明
	//[self setBackgroundColor:[UIColor clearColor]];
	//self.backgroundColor = [UIColor grayColor];
	//self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
	// 缩放
	self.scalesPageToFit = YES;
	// 自动调整大小
	self.autoresizesSubviews = NO;
	self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	//self.delegate = self;
	self.opaque = YES; // opaque: 不透明的, (如果设置为NO, 有些页面可以看到背景色)
	
}

// 加载网页
- (void)startNewRequest:(NSString*)pStrURL
{
	// 发送请求
	[[iUIWebViewManager sharedInstance] setURL:pStrURL];
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pStrURL]]];
}

// =================================================================
#pragma mark -
#pragma mark

- (void)setUserAgent
{
//	NSString *userAgent =@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_1 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5F136 Safari/525.20";
//	
//	id webDocumentView;
//	id webView;
//	//webDocumentView = objc_msgSend(self, @selector(_documentView));
//	object_getInstanceVariable(webDocumentView, "_webView", (void**)&webView);
//	/object_msgSend(webView, @selector(setCustomUserAgent:), userAgent);
}

- (void)setCustomUserAgent:(NSString*)pUserAgent
{
	WKMD_LOG_NSLOG(@"===user-Agent = %@====\n", pUserAgent);

}
// =================================================================
#pragma mark -
#pragma mark 

- (NSString*)title
{
	id coreWebView = [self getCoreWebView];
	return [coreWebView valueForKey:@"mainFrameTitle"];
}

- (NSString*)url
{
	id coreWebView = [self getCoreWebView];
	return [coreWebView valueForKey:@"mainFrameURL"];
	
}

//zds add 2010-03-16,获取UIWebView中的CoreWebView，为app Store服务
- (id)getCoreWebView
{
	id _documentView = [self valueForKey:@"_documentView"];
	id coreWebView = [_documentView valueForKey:@"webView"];
	return coreWebView;
}

// =================================================================
#pragma mark -
#pragma mark UIWebViewDelegate 代理方法

// 显示页面加载状态的提示框界面
//#define SHOW_UIAlertView_UI
#ifdef SHOW_UIAlertView_UI
static UIAlertView* myAlert = nil;
#endif // #ifdef SHOW_UIAlertView_UI

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// 2012-01-08 for UIWebView test
	[UIWebView setRequestCount:0];
	
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
//#ifdef SHOW_UIAlertView_UI
//	if (myAlert==nil)
//	{         
//		myAlert = [[UIAlertView alloc] initWithTitle:nil 
//											 message:@"Loading"
//											delegate: self 
//								   cancelButtonTitle: nil 
//								   otherButtonTitles: nil]; 
//		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]; 
//		activityView.frame = CGRectMake(120.f, 48.0f, 37.0f, 37.0f); 
//		[myAlert addSubview:activityView]; 
//		[activityView startAnimating]; 
//		[myAlert show];
//	}
//#endif // #ifdef SHOW_UIAlertView_UI
}

//数据加载完 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[[iUIWebViewManager sharedInstance] updateButtonsStatus];
//#ifdef SHOW_UIAlertView_UI
//	[myAlert dismissWithClickedButtonIndex:0 animated:YES];
//#endif // #ifdef SHOW_UIAlertView_UI
	
	// 2012-01-08 for UIWebView test
	[UIWebView RequestWebPageDataDidFinishLoad:webView];
	
	if ([self respondsToSelector:@selector(addLongPressGestureRecognizer)])
	{
		[self performSelector:@selector(addLongPressGestureRecognizer)];
	}
	//[self stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
	NSString* pTitle = [self title];
	WKMD_LOG_NSLOG(@"title=%@", pTitle);
	NSString* pURL = [self url];
	WKMD_LOG_NSLOG(@"pURL=%@", pURL);
	[[iUIWebViewManager sharedInstance] setTitle:pURL];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[self loadHTMLString:errorString baseURL:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	NSLog(@"sender=%@", sender);
	return YES;
}


// =================================================================
#pragma mark -
#pragma mark UIGestureRecognizerDelegate 代理方法
//@protocol UIGestureRecognizerDelegate <NSObject>
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	return YES;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return YES;
}


@end









// =================================================================
#pragma mark -
#pragma mark 截取UIWebView的图片请求消息
//BOOL isAImageRequest (NSURLRequest *request);
//void exchangeImplementations (void);
//void investigateUIWebView (void);
//void exchangeImplementationsOnAppStore (void);


@implementation UIWebView (UIWebView_cat)

+ (void)setRequestCount:(int)nCount
{
	m_nRequestCount = 0;
}

+ (void)RequestWebPageDataDidFinishLoad:(UIWebView *)webView
{
	NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
	WKMD_LOG_NSLOG(@"=========title = [%@]===================\n\n\n\n\n", title);
}
	
- (id)customWebView:(id)sender resource:(id)identifier willSendRequest:(id)request redirectResponse:(id)redirectResponse fromDataSource:(id)dataSource
{
	//NSLog (@"- (id)customWebView:(id)sender resource:(id)identifier willSendRequest:(id)request redirectResponse:(id)redirectResponse fromDataSource:(id)dataSource");
	
	//WKMD_LOG_NSLOG (@"webView: %@", sender);
	//WKMD_LOG_NSLOG (@"resource: %@", identifier);
	WKMD_LOG_NSLOG (@"willSendRequest: %@", request);
	WKMD_LOG_NSLOG (@"redirectResponse: %@", redirectResponse);
	//WKMD_LOG_NSLOG (@"fromDataSource: %@", dataSource);
    
	//NSString *title = [sender stringByEvaluatingJavaScriptFromString: @"document.title"];
	//    NSString *html = [sender stringByEvaluatingJavaScriptFromString: @"document.documentElement.innerHTML"];
	//    
	//    NSLog (@"title:\n%@", title);
	//    NSLog (@"html:\n%@", html);
	//static int times = 0;
	//WKMD_LOG_NSLOG (@"======invoked [%d] times======\n", ++times);
	
	WKMD_LOG_NSLOG (@"======invoked [%d] times======\n", ++m_nRequestCount);
	
	// 有图与无图测试
#define SHOW_WEBVIEW_IMAGE
#ifdef SHOW_WEBVIEW_IMAGE
	// UIWebView 内核处理方式
	return request;
#else
	
	if (! isAImageRequest (request))
	{
		return request;
	}
	else
	{
		static int imageRequests = 0;
		WKMD_LOG_NSLOG (@"totaly %d image requests\n\n\n", ++imageRequests);
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"nil_image" ofType:@"png"];
		NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
		NSURLRequest *newRequest = [NSURLRequest requestWithURL: url];
		
		//        NSLog (@"%@", url);
		
		//        return nil; // 如果直接返回 nil, 将不会得到图片, 但是 UIWebView 在排版时会有警告.
		
		return newRequest;
	}
#endif
}

- (id)customWebView:(id)sender identifierForInitialRequest:(id)request fromDataSource:(id)dataSource
{
    NSLog (@"- (id)webView:(id)sender identifierForInitialRequest:(id)request fromDataSource:(id)dataSource");
    
    NSLog (@"webview: %@", sender);
    NSLog (@"identifierForInitialRequest: %@", request);
    NSLog (@"fromDataSource: %@", dataSource);
    
    static int times = 0;
    NSLog (@"invoked %d times\n\n\n", ++times);
    
    return [self customWebView:sender identifierForInitialRequest:request fromDataSource:dataSource];
}

+ (void)exchangeImplementations
{
	{
		Class cls = objc_getClass("UIWebView");
		Method origImp = class_getInstanceMethod (cls, @selector(webView:resource:willSendRequest:redirectResponse:fromDataSource:));
		Method customImp = class_getInstanceMethod (cls, @selector(customWebView:resource:willSendRequest:redirectResponse:fromDataSource:));
		method_exchangeImplementations (origImp, customImp);
	}
	{
		//        Class cls = objc_getClass("UIWebView");
		//        Method origImp = class_getInstanceMethod (cls, @selector(webView:identifierForInitialRequest:fromDataSource:));
		//        Method customImp = class_getInstanceMethod (cls, @selector(customWebView:identifierForInitialRequest:fromDataSource:));
		//        method_exchangeImplementations (origImp, customImp);
	}
}

//void exchangeImplementationsOnAppStore(void)
+ (void)exchangeImplementationsOnAppStore
{
    Class cls = objc_getClass("UIWebView");
    Method origImp = class_getInstanceMethod (cls, sel_getUid("webView:resource:willSendRequest:redirectResponse:fromDataSource:"));
    Method customImp = class_getInstanceMethod (cls, sel_getUid("customWebView:resource:willSendRequest:redirectResponse:fromDataSource:"));
    method_exchangeImplementations (origImp, customImp);
}


@end


// =================================================================
#pragma mark -
#pragma mark 文件尾

BOOL isAImageRequest (NSURLRequest *request)
{
    NSURL *url = [request URL];
    NSString *string = [url absoluteString];
    
    NSArray *imageSuffix = [NSArray arrayWithObjects: @".png", @".jpg", @".jpeg", @".gif", @".bmp", nil];
    
	for (id suffix in imageSuffix)
	{
		if ([string hasSuffix: suffix])
		{
			return YES;
		}
	}
    
	return NO;
}

//void exchangeImplementations (void)

void investigateUIWebView (void)
{
    id cls = objc_getClass ("UIWebView");
    
    if (cls == nil) {
        printf ("nil cls\n");
        return;
    }
    
    unsigned int count;
    Method *method = class_copyMethodList (cls, &count);
    
    printf ("\nmethod list:\n");
    for (int i=0; i<count; ++i) {
        printf ("%s\n", sel_getName (method_getName (method[i])));
    }
    
    free (method);
    method = NULL;
    
    Ivar *ivar = class_copyIvarList (cls, &count);
    
    printf ("\ninstance variable list:\n");
    for (int i=0; i<count; ++i) {
        printf ("%s\n", ivar_getName (ivar[i]));
    }
    
    free (ivar);
    ivar = NULL;
    
    objc_property_t *property = class_copyPropertyList (cls, &count);
    
    printf ("\nproperty list:\n");
    for (int i=0; i<count; ++i) {
        printf ("%s\n", property_getName (property[i]));
    }
    
    free (property);
    property = NULL;
    
    printf ("\n\n\n");
}

// =================================================================
#pragma mark -
#pragma mark 文件尾

