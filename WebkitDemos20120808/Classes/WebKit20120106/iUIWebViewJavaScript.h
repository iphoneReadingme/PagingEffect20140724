/*
 
 File             =  iUIMediaRootView.h
 Description  =  多媒体功能实现(MultiMedia).
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-02
 
 */

//#import <UIKit/UIKit.h>



@interface UIWebView (UIWebView_JavaScript)


// 页面截图
- (void)pageSnapshot;

//- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

- (UIView*)findWebViewScrollView:(UIView*)view;
- (UIView*)findWebViewDocumentView:(UIView*)view;

- (void)addLongPressGestureRecognizer;

@end
