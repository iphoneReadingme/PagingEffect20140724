/*
 *****************************************************************************
 * Copyright (C) 2005-2013 UC Mobile Limited. All Rights Reserved
 * File			: NBPageItem.m
 *
 * Description	: NBPageItem
 *
 * Author		: daijb@ucweb.com
 * History		:
 *			   Creation, 14-6-17, daijb@ucweb.com, Create the file
 ******************************************************************************
 **/

#import "NBPageItem.h"

@implementation NBPageItem

#pragma mark - Serialize of NBPageItem

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.chapterIndex forKey:@"chapterIndex"];
    [encoder encodeInteger:self.startInChapter forKey:@"startInChapter"];
    [encoder encodeInteger:self.length forKey:@"length"];
    [encoder encodeInteger:self.pageIndex forKey:@"pageIndex"];
    [encoder encodeFloat:self.lastPageViewHeight forKey:@"lastPageViewHeight"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
		self.chapterIndex = [decoder decodeIntForKey:@"chapterIndex"];
		self.startInChapter = [decoder decodeIntForKey:@"startInChapter"];
		self.length = [decoder decodeIntForKey:@"length"];
		self.pageIndex = [decoder decodeIntForKey:@"pageIndex"];
		self.lastPageViewHeight = [decoder decodeFloatForKey:@"lastPageViewHeight"];
    }
    
    return self;
}

@end