//
//  ViewController.m
//  WebkitDemo
//
//  Created by yangfs on 14/12/17.
//  Copyright (c) 2014年 yangfs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	
	UIView* pageView = [[UIView alloc] initWithFrame:[self.view bounds]];
	[self.view addSubview:pageView];
	[pageView autorelease];
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
