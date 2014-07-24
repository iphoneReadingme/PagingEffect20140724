//
//  PageAppViewController.h
//  PageTest2
//
//  Created by apple on 13-9-13.
//  Copyright (c) 2013年 kongyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
@interface PageAppViewController : UIViewController<UIPageViewControllerDataSource>{
    UIPageViewController * pageController;
    NSArray * pageContent;
}
@property(strong,nonatomic)UIPageViewController * pageController;
@property(strong,nonatomic)NSArray * pageContent;
@end
