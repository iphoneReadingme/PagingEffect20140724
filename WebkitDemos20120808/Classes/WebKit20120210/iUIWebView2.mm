//
//  iUIMediaRootView.mm
//  YFS_Sim111027_i42
//
//  Created by yangfs on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "iUIWebViewJavaScript.h"
#import "iUIWebView2.h"
#import "iUIWebViewManager.h"
#import "iUIWebKitMacroDefine.h"

// 加载一个页面过程中, 发起request的次数据, 用来查看UIWebView 在"前进"/"后退"过程中, 请求了哪些数据
//int m_nRequestCount;
// =================================================================
#pragma mark -
#pragma mark 实现iUIWebView2

@implementation iUIWebView2


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
	CGRect selfFrame = [self frame];
	[self initData];
	
}

- (void)initData
{
	// 设置UIWebView透明
	//[self setBackgroundColor:[UIColor clearColor]];
	//self.backgroundColor = [UIColor grayColor];
	//self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
	// 缩放
	//self.scalesPageToFit = YES;
	// 自动调整大小
	//self.autoresizesSubviews = NO;
	//self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	//self.delegate = self;
	//self.opaque = YES; // opaque: 不透明的, (如果设置为NO, 有些页面可以看到背景色)
	
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

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// 2012-01-08 for UIWebView test
	[UIWebView setRequestCount:0];
	
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}

//数据加载完 
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[UIWebView RequestWebPageDataDidFinishLoad:webView];
	
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

@implementation UIWebView (UIWebView_cat)

+ (void)setRequestCount:(int)nCount
{
	//m_nRequestCount = 0;
}

+ (void)RequestWebPageDataDidFinishLoad:(UIWebView *)webView
{
	NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
	WKMD_LOG_NSLOG(@"=========title = [%@]===================\n\n\n\n\n", title);
}

@end

// =================================================================
#pragma mark -
#pragma mark 文件尾

