//
//  NBNovelBox.h
//  NBNovelBox
//
//  Created by yangfs on 14/12/17.
//  Copyright (c) 2014年 yangfs. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "NBPageViewController.h"
//#import "../NBPageViewController/NBPageViewController.h"
//#import "NBMockChapterContent.h"
//#import "../../NBNovelBoxTests/TestSource/NBDataModelMocks/NBMockChapterContent.h"


@interface NBNovelBox : NSObject

- (NSString*)getTestString;

+ (UIViewController*)createPageViewController;

@end



