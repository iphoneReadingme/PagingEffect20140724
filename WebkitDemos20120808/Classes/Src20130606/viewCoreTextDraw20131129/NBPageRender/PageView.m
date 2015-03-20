/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 UC Mobile Limited. All Rights Reserved
 * File         :  PageView.m
 * Description	:  小说阅读器每一页视图PageView
 * Author       :  yuping@ucweb.com
 * History      :  Creation, 2013/11/23, yuping, Create the file
 ******************************************************************************
 **/



#import "PageView.h"
#import "NBPageViewCache.h"


typedef enum
{
    touchevent_error
    ,touchevent_prepage
    ,touchevent_menu
    ,touchevent_nextpage
}TOUCHEVENT_TYPE;


CGFloat distance(CGPoint a, CGPoint b)
{
	return sqrtf(powf(a.x - b.x, 2) + powf(a.y - b.y, 2));
}

@interface PageView ()

@property (nonatomic, assign) CGSize pageSize;

@end

@implementation PageView


- (id)initWithFrame:(CGRect)frame layoutSize:(CGSize)size
{
    if ((self = [super initWithFrame:frame]))
    {
		self.layer.borderColor = [UIColor redColor].CGColor;
		self.layer.borderWidth = 2;
		
        self.clipsToBounds = YES;
        _pageCache = [[NBPageViewCache alloc] initWithPageSize:size];
    }
    
    return self;
}

- (void)dealloc
{
    self.pageCache.dataSource = nil;
	self.pageCache = nil;
	
    [super dealloc];
}

- (void)setPageBackgroundColor:(UIColor *)color
{
	self.backgroundColor = color;
	self.backgroundColor = [UIColor clearColor];
}

#pragma mark - data accessors
- (id<NBPageViewDataSource>)dataSource
{
	return self.pageCache.dataSource;
}

- (void)setDataSource:(id<NBPageViewDataSource>)value
{
	self.pageCache.dataSource = value;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if (!CGSizeEqualToSize(self.pageSize, self.bounds.size))
    {
		self.pageSize = self.bounds.size;
		self.pageCache.pageSize = self.bounds.size;
	}
}

@end
