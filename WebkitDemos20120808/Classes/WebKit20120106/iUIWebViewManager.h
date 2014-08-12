/*
 
 File             =  iUIMediaRootView.h
 Description  =  多媒体功能实现(MultiMedia).
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-02
 
 */

//#import <UIKit/UIKit.h>

@class iUIWebView;
@class iUIToolBarView;
@class iUIURLTextField;

@interface iUIWebViewManager : NSObject
{
	NSMutableArray* m_pWebViewPageArray; // Webkit 页面对象数组
	
	// 当前页面
	UIWebView *m_pCurWebView;
	iUIToolBarView* m_pToolBarView;
	iUIURLTextField* m_pURLAddressView;
}

+ (iUIWebViewManager*)sharedInstance;

- (void)releaseObject;
// 清除标签视图对象数组
- (void)clearWebViewPageArray;

- (UIWebView*)getCurrentWebPage;

// 添加新的页面
- (UIWebView*)addNewWebPage:(CGRect)frame;
- (UIWebView*)addNewWebPage2:(CGRect)frame;

- (void)setToolBarView:(iUIToolBarView*)pToolBarView;
- (void)setURLAddressView:(iUIURLTextField*)pURLAddressView;
- (void)updateButtonsStatus;

// 加载网页
- (void)startNewRequest:(NSString*)pStrURL;

- (void)goBack;
- (void)goForward;
- (BOOL)canGoBack;
- (BOOL)canGoForward;
- (void)refresh;

// 页面截图
- (void)pageSnapshot;

- (void)setTitle:(NSString*)pTitle;
- (void)setURL:(NSString*)pURL;


@end
