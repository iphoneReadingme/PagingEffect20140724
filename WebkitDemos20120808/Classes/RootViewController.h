//
//  RootViewController.h
//  WebkitDemos
//
//  Created by yangfs on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController<UINavigationControllerDelegate>
{
@private
	NSMutableArray *items;
}

@end
