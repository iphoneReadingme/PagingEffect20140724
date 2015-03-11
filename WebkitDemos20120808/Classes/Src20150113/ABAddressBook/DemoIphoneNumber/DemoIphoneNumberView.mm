
#import <UIKit/UIKit.h>
#import "DemoIphoneNumberView.h"
#import "DemoIphoneNumberHelper.h"



///< 私有方法
@interface DemoIphoneNumberView()

@property (nonatomic, retain) UIView *bgAnimationView;

- (void)addButtons;

@end

// =================================================================

@implementation DemoIphoneNumberView


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
	
	[self addButtons];
}

- (void)addBgView:(CGRect)frame
{
	CGRect rect = CGRectMake(20, 60, 100, 100);
	UIView* pView = [[[UIView alloc] initWithFrame:rect] autorelease];
	pView.backgroundColor = [UIColor whiteColor];
	[self addSubview:pView];
}

// =================================================================
#pragma mark- == Core Animation之多种动画效果
// 1、把图片移到右下角变小透明
// =================================================================
#pragma mark-
#pragma mark 创建按钮

- (UIButton*)createButton:(int)nTag withName:(NSString*)pStrName withTitle:(NSString*)pTitle
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
	[button addTarget:self action:@selector(onButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = nTag;
	button.accessibilityLabel = pStrName;
	[button setTitle:pTitle forState:UIControlStateNormal];
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	[self addSubview:button];
	
	return button;
}

- (void)addButtons
{
	CGRect frame = [self bounds];
	frame.origin = CGPointZero;
	CGRect btnRect = CGRectMake(0, 0, 140, 64);
//	btnRect.origin.x = frame.size.width - btnRect.size.width;
	int nIndex = 1;
	UIButton* pBtn = nil;
	
	// "添加联系人"按钮
	btnRect = CGRectMake(0, 0, 80, 64);
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"添加联系人"];
	[pBtn setFrame:btnRect];
	
	nIndex = 2;
	// "显示联系人"按钮
	btnRect.origin.x += 20 + btnRect.size.width;
	pBtn = [self createButton:nIndex withName:@"UIButtonTest2" withTitle:@"显示联系人"];
	[pBtn setFrame:btnRect];
	
	
	nIndex = 3;
	// "清空联系人"按钮
	btnRect.origin.x += 20 + btnRect.size.width;
	pBtn = [self createButton:nIndex withName:@"UIButtonTest2" withTitle:@"清空联系人"];
	[pBtn setFrame:btnRect];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	NSInteger nTag = sender.tag;
	if (nTag == 1)
	{
		[self addPersons];
	}
	else if (nTag == 2)
	{
		[self showPersons];
	}
	else if (nTag == 3)
	{
		[self clearAllPersons];
	}
}

- (void)clearAllPersons
{
	[DemoIphoneNumberHelper clearAllPersons];
}

- (void)addPersons
{
	[DemoIphoneNumberHelper addPersons];
}

- (void)showPersons
{
	NSMutableArray* personArray = [DemoIphoneNumberHelper readPersons];
	
	personArray = nil;
}

@end


