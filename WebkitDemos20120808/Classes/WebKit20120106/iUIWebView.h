/*
 
 File             =  iUIMediaRootView.h
 Description  =  多媒体功能实现(MultiMedia).
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-02
 
 */

//#import <UIKit/UIKit.h>


@interface iUIWebView : UIWebView <UIWebViewDelegate, UIGestureRecognizerDelegate>
{

}

-(void)releaseObject;

-(void)addViews;
- (void)initData;

// 加载网页
- (void)startNewRequest:(NSString*)pStrURL;
- (id)getCoreWebView;


@end


// =================================================================
#pragma mark -
#pragma mark 截取UIWebView的图片请求消息
BOOL isAImageRequest (NSURLRequest *request);
//void exchangeImplementations (void);
void investigateUIWebView (void);
//void exchangeImplementationsOnAppStore (void);

//#pragma mark - UIWebView category
// 截获UIWebView的图片请求消息 2012-01-06

@interface UIWebView (UIWebView_cat)
+ (void)setRequestCount:(int)nCount;
+ (void)RequestWebPageDataDidFinishLoad:(UIWebView *)webView;
+ (void)exchangeImplementations;
+ (void)exchangeImplementationsOnAppStore;

- (id)customWebView:(id)sender resource:(id)identifier willSendRequest:(id)request redirectResponse:(id)redirectResponse fromDataSource:(id)dataSource;
- (id)customWebView:(id)sender identifierForInitialRequest:(id)request fromDataSource:(id)dataSource;

@end
