//
//  main.m
//  WebkitDemos
//
//  Created by yangfs on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
	NSLog(@"[[NSBundle mainBundle] bundlePath];=%@", [[NSBundle mainBundle] bundlePath]);
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
