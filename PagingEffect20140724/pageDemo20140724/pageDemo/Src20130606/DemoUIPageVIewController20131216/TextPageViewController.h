
/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: TextPageViewController.h
 *
 * Description	: TextPageViewController书页内容控制器,用于显示页面内容
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on 2013-12-16.
 * History		: modify: 2013-12-16.
 *
 ******************************************************************************
 **/


@interface TextPageViewController : UIViewController
{
}

+ (TextPageViewController*)getPageViewControllerForPageIndex:(NSUInteger)pageIndex;

- (NSInteger)pageIndex;

@end

