/*
 
 File             =  iUIMediaRootView.h
 Description  =  多媒体功能实现(MultiMedia).
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-02
 
 */

//#import <UIKit/UIKit.h>


@interface iUIWebView2 : UIWebView
//<UIWebViewDelegate, UIGestureRecognizerDelegate>
{

}

-(void)releaseObject;

-(void)addViews;
- (void)initData;

// 加载网页
- (void)startNewRequest:(NSString*)pStrURL;


@end

