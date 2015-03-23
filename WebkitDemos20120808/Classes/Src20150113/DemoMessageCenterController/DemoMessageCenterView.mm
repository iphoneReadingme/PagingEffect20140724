
#import <UIKit/UIKit.h>
#import "DemoMessageCenterView.h"


#define kTableCellHeight            (50.0f)


///< 私有方法
@interface DemoMessageCenterView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UIView *bgAnimationView;

@property (nonatomic, retain) UITableView *msgTableView;

@property (nonatomic, retain) NSMutableArray *sourceList;

@end

// =================================================================

@implementation DemoMessageCenterView


- (void)forTest
{
	// for test
	self.backgroundColor = [UIColor brownColor];
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		[self forTest];
		self.backgroundColor = [UIColor whiteColor];
		
		[self loadData];
		[self addSubViews:frame];
		
    }
    return self;
}

- (void)dealloc
{
	[self releaseObject];
    
    [super dealloc];
}

-(void)releaseObject
{
	[_sourceList release];
	_sourceList = nil;
	
	[_bgAnimationView release];
	_bgAnimationView = nil;
	
	[_msgTableView release];
	_msgTableView = nil;
}

- (void)addSubViews:(CGRect)frame
{
	CGSize size = frame.size;
	self.contentSize = size;
	
	[self addMsgTableView];
}

- (void)addBgView:(CGRect)frame
{
	CGRect rect = CGRectMake(20, 60, 100, 100);
	UIView* pView = [[[UIView alloc] initWithFrame:rect] autorelease];
	pView.backgroundColor = [UIColor whiteColor];
	[self addSubview:pView];
}

- (void)addMsgTableView
{
	CGRect rect = [self bounds];
	
	UITableView* tableView = [[UITableView alloc] initWithFrame:rect style: UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.autoresizesSubviews = YES;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.opaque = YES;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addSubview: tableView];
	_msgTableView = tableView;
}

- (void)loadData
{
	[self getSourceData];
}

- (NSMutableArray*)getSourceData
{
//	NSMutableArray* sourceList = nil;
	
	if (_sourceList == nil)
	{
		_sourceList = [NSMutableArray arrayWithArray: @[@"apple", @"pearch", @"tomato", @"test", @"test2"]];
		[_sourceList retain];
	}
	
	return _sourceList;
}

#pragma mark -== UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kTableCellHeight;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark -== UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_sourceList count];
}

NSString* kKeyCellIdentifier = @"kKeyCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kKeyCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kKeyCellIdentifier] autorelease];
	}
	
	NSUInteger nRow = [indexPath row];
	NSString* title = nil;
	if (nRow < [_sourceList count])
	{
		title = [_sourceList objectAtIndex:nRow];
	}
	cell.textLabel.text = title;
	
	return cell;
}


@end


