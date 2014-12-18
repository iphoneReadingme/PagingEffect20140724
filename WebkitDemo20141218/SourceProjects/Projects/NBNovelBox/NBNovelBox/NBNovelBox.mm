//
//  NBNovelBox.m
//  NBNovelBox
//
//  Created by yangfs on 14/12/17.
//  Copyright (c) 2014年 yangfs. All rights reserved.
//

#import "NBNovelBox.h"
#import "NBPageViewController.h"

@implementation NBNovelBox

- (NSString*)getTestString
{
	return @"===NBNoveBox object create test===";
}

+ (UIViewController*)createPageViewController
{
	return [NBPageViewController createPageViewController];
}

@end
