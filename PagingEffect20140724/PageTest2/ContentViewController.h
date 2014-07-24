//
//  ContentViewController.h
//  PageTest2
//
//  Created by apple on 13-9-13.
//  Copyright (c) 2013年 kongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (retain,nonatomic)id dataObject;
@end
