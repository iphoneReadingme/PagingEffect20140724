//
//  WebkitDemoTests.m
//  WebkitDemoTests
//
//  Created by yangfs on 14/12/17.
//  Copyright (c) 2014年 yangfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface WebkitDemoTests : XCTestCase

@end

@implementation WebkitDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
	XCTAssert(YES, @"Pass");
//	XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
