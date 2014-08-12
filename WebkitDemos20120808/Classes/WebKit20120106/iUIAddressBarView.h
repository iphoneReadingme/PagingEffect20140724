/*
 
 File             =  iUIToolBarView.h
 Description  =  页面浏览工具栏.
 Version       =  1.0.0
 Author        =  yangfasheng
 Date           =  2012-01-06
 
 */

#ifndef DEF_iUIAddressBarView_H_
#define DEF_iUIAddressBarView_H_

//#import <UIKit/UIKit.h>


@interface iUIAddressBarView : UIView
{
	//UIButton* m_pBtnBack; // 后退
	//UIButton* m_pBtnForward; // 前进
	UIButton* m_pBtnGo;
	//UIButton* m_pBtnBack;
	UITextField* m_pURLTextField; // URL输入框
}

-(void)releaseObject;

-(void)addViews;

-(UIButton*)createButton:(NSString*)title withTag:(int)tag;
-(void)createButtons;
- (void)setButtonStatus:(UIButton*)pBtn with:(BOOL)bEnabled;
- (void)updateButtonsStatus;

- (void)addURLTextField:(CGRect)frame;

@end

#endif // #ifndef DEF_iUIToolBarView_H_
