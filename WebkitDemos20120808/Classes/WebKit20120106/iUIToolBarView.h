/*
 
 File             =  iUIToolBarView.h
 Description  =  页面浏览工具栏.
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-06
 
 */

#ifndef DEF_iUIToolBarView_H_
#define DEF_iUIToolBarView_H_

//#import <UIKit/UIKit.h>


@interface iUIToolBarView : UIView
{
	UIButton* m_pBtnBack;              ///< 后退
	UIButton* m_pBtnForward;         ///< 前进
	UIButton* m_pBtnGo;                ///< 打开Go
	UIButton* m_pBtnRefresh;        ///< 刷新
	
	// WebViewController
	id m_pWebViewController;
}

-(void)releaseObject;

-(void)addViews;

-(UIButton*)createButton:(NSString*)title withTag:(int)tag;
-(void)createButtons;
- (void)setButtonStatus:(UIButton*)pBtn with:(BOOL)bEnabled;
- (void)updateButtonsStatus;

- (void)setWebViewController:(id)pWebViewController;

@end

#endif // #ifndef DEF_iUIToolBarView_H_
