
#import <UIKit/UIKit.h>
#import "DemoMessageCenterView.h"


///< 私有方法
@interface DemoMessageCenterView()<UIActionSheetDelegate>

@property (nonatomic, retain) UIView *bgAnimationView;


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
		self.backgroundColor = [UIColor clearColor];
		[self addSubViews:frame];
		
//		[self addShakeEvent];
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
}

- (void)addSubViews:(CGRect)frame
{
	CGSize size = frame.size;
	size.height = 2048;
	self.contentSize = size;
	
}

- (void)addBgView:(CGRect)frame
{
	CGRect rect = CGRectMake(20, 60, 100, 100);
	UIView* pView = [[[UIView alloc] initWithFrame:rect] autorelease];
	pView.backgroundColor = [UIColor whiteColor];
	[self addSubview:pView];
}

@end


