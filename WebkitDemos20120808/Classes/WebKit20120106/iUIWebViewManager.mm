//
//  iUIMediaRootView.mm
//  YFS_Sim111027_i42
//
//  Created by yangfs on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iUIWebKitMacroDefine.h"
#import "iUIWebView.h"
//#import "iUIWebView2.h"
#import "iUIToolBarView.h"
#import "iUIWebViewManager.h"
#import "iUIWebViewJavaScript.h"
#import "iUIURLTextField.h"

// =================================================================
#pragma mark -
#pragma mark 实现iUIWebViewManager

// 局部全局对象
static iUIWebViewManager* g_pWebManager = nil;

//methods that are not meant to be called outside
// private methods
@interface iUIWebViewManager(Private_methods)
- (void)createObject;

- (void)initManager;

@end

@implementation iUIWebViewManager

+ (iUIWebViewManager*)sharedInstance
{
	@synchronized(self)
	{
		if (g_pWebManager == nil) 
		{
			// 加锁
			if (g_pWebManager == nil) 
			{
				g_pWebManager = [[self alloc] init];
				[g_pWebManager initManager];
			}
		}
	}
	return g_pWebManager;
}

// =================================================================

- (void)releaseObject
{
	[self clearWebViewPageArray];
	m_pCurWebView = nil;
	m_pToolBarView = nil;
	m_pURLAddressView = nil;
}

- (void)initManager
{
	[self createObject];
}

#pragma mark -
#pragma mark 数组对象
// 清除标签视图对象数组
- (void)clearWebViewPageArray
{
	[m_pWebViewPageArray removeAllObjects];
	[m_pWebViewPageArray release];
	m_pWebViewPageArray = nil;
}

- (void)createObject
{
	m_pWebViewPageArray = [[NSMutableArray alloc] initWithCapacity:5];
}

- (UIWebView*)getCurrentWebPage
{
	return m_pCurWebView;
}

- (UIWebView*)addNewWebPage:(CGRect)frame
{
	// 创建一个层用来放 webview
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	//webFrame.origin.y = 0;	// leave from the URL input field and its label
	//webFrame.size.height = frame.size.height;
	//webFrame.size.height = 250;
	webFrame = frame;
	m_pCurWebView = [[iUIWebView alloc] initWithFrame:webFrame];
	
	NSLog(@"m_pCurWebView = %@", m_pCurWebView);
	
	[m_pWebViewPageArray addObject:m_pCurWebView];
	
	return m_pCurWebView;
}

- (UIWebView*)addNewWebPage2:(CGRect)frame
{
	// 创建一个层用来放 webview
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	//webFrame.origin.y = 0;	// leave from the URL input field and its label
	//webFrame.size.height = frame.size.height;
	//webFrame.size.height = 250;
	webFrame = frame;
	//m_pCurWebView = [[iUIWebView2 alloc] initWithFrame:webFrame];
	
	NSLog(@"m_pCurWebView = %@", m_pCurWebView);
	
	[m_pWebViewPageArray addObject:m_pCurWebView];
	
	return m_pCurWebView;
}

- (void)setToolBarView:(iUIToolBarView*)pToolBarView
{
	m_pToolBarView = pToolBarView;
}

- (void)setURLAddressView:(iUIURLTextField*)pURLAddressView
{
	m_pURLAddressView = pURLAddressView;
}

- (void)updateButtonsStatus
{
	[m_pToolBarView updateButtonsStatus];
}

// 加载网页
- (void)startNewRequest:(NSString*)pStrURL
{
	[(iUIWebView*)m_pCurWebView startNewRequest:pStrURL];
}

// =================================================================
#pragma mark -
#pragma mark 页面前进/后退
- (void)goBack
{
	[m_pCurWebView goBack];
}
- (void)goForward
{
	[m_pCurWebView goForward];
}

- (BOOL)canGoBack
{
	BOOL bCanGoBack = [m_pCurWebView canGoBack];
	return bCanGoBack;
}

- (BOOL)canGoForward
{
	BOOL bCanGoForward = [m_pCurWebView canGoForward];
	return bCanGoForward;
}

- (void)refresh
{
	//if([self isLoading])
	{
		[m_pCurWebView stopLoading];
	}
	[m_pCurWebView reload];
}

// =================================================================
#pragma mark -
#pragma mark 


- (void)setTitle:(NSString*)pTitle
{
	m_pURLAddressView.text = pTitle;
}

- (void)setURL:(NSString*)pURL
{
	m_pURLAddressView.text = pURL;
}

// 页面截图
- (void)pageSnapshot
{
	[m_pCurWebView pageSnapshot];
}

@end

// =================================================================
#pragma mark -
#pragma mark 文件尾

