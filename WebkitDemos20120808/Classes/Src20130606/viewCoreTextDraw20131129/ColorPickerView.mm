
#import "ColorPickerView.h"


///< 私有方法
@interface ColorPickerView ()<UITextFieldDelegate>
{
	
}

@property (nonatomic, retain) NSString * kKeyNotify;           // 颜色类型(标题/文本)
@property (nonatomic, retain) UIView * colorShowView;       // 颜色效果视图
@property (nonatomic, retain) UITextField * redComponent;   // 红
@property (nonatomic, retain) UITextField * greenComponent; // 绿
@property (nonatomic, retain) UITextField * blueComponent;  // 蓝


- (void)addSomeViews:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

- (void)addButtons;

@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation ColorPickerView


- (void)forTest
{
	// for test
	self.backgroundColor = [UIColor brownColor];
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame with:(NSString*)kKeyNotify
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
//		[self forTest];
		self.kKeyNotify = kKeyNotify;
		self.backgroundColor = [UIColor grayColor];
		[self addSomeViews:frame];
		
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
	self.kKeyNotify = nil;
	self.colorShowView = nil;
	self.redComponent = nil;
	self.greenComponent = nil;
	self.blueComponent = nil;
}

// =================================================================
#pragma mark- == 三基色属性设置控件
- (void)addTextFieldRedComponent:(CGRect)rect
{
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = @"红:";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect.size.width;
	
	UITextField* pLineSpace = [[UITextField alloc] initWithFrame:rect];
	
	pLineSpace.backgroundColor = [UIColor whiteColor];
	pLineSpace.text = @"255";
	pLineSpace.delegate = self;
	self.redComponent = [pLineSpace retain];
	[self addSubview:pLineSpace];
	[pLineSpace release];
}

- (void)addTextFieldGreenComponent:(CGRect)rect
{
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = @"绿:";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect.size.width;
	
	UITextField* pLineSpace = [[UITextField alloc] initWithFrame:rect];
	
	pLineSpace.backgroundColor = [UIColor whiteColor];
	pLineSpace.text = @"255";
	pLineSpace.delegate = self;
	self.greenComponent = [pLineSpace retain];
	[self addSubview:pLineSpace];
	[pLineSpace release];
}

- (void)addTextFieldBlueComponent:(CGRect)rect
{
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = @"蓝";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect.size.width;
	
	UITextField* pLineSpace = [[UITextField alloc] initWithFrame:rect];
	
	pLineSpace.backgroundColor = [UIColor whiteColor];
	pLineSpace.text = @"255";
	pLineSpace.delegate = self;
	self.blueComponent = [pLineSpace retain];
	[self addSubview:pLineSpace];
	[pLineSpace release];
}

- (void)addSomeViews:(CGRect)frame
{
	CGRect rect = CGRectMake(10, 100, 80, 40);
	
	[self addTextFieldRedComponent:rect];
	
	rect.origin.y += 10;
	rect.origin.y += rect.size.height;
	[self addTextFieldGreenComponent:rect];
	
	rect.origin.y += 10;
	rect.origin.y += rect.size.height;
	[self addTextFieldBlueComponent:rect];
	
	rect.origin.y += 10;
	rect.origin.y += rect.size.height;
	UIView* colorShowView = [[[UIView alloc] initWithFrame:rect] autorelease];
	colorShowView.backgroundColor = [UIColor whiteColor];
	colorShowView.layer.borderColor = [UIColor redColor].CGColor;
	colorShowView.layer.borderWidth = 2;
	[self addSubview:colorShowView];
	self.colorShowView = colorShowView;
	
	[self addButtons];
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
	
	button.backgroundColor = [UIColor blueColor];
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	[self addSubview:button];
	//[button retain];
	
	return button;
}

- (void)addButtons
{
//	CGRect frame = [self bounds];
	CGRect btnRect = CGRectMake(0, 0, 100, 50);
//	btnRect.origin.x = frame.size.width - btnRect.size.width;
	btnRect.origin.x = 20;
	int nIndex = 1;
	UIButton* pBtn = nil;
	
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"确定"];
	[pBtn setFrame:btnRect];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	[self saveColorAttributes];
}

- (UIColor*)getColor
{
	int red = [[_redComponent text] intValue];
	int green = [[_greenComponent text] intValue];
	int blue = [[_blueComponent text] intValue];
	UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
	
	return color;
}

#pragma mark -== 保存文本属性
- (void)saveColorAttributes
{
	NSLog(@"===通知保存文本属性===");
	_colorShowView.backgroundColor = [self getColor];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:_kKeyNotify object:[self getColor]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	_colorShowView.backgroundColor = [self getColor];
	
	return YES;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//	
//	_colorShowView.backgroundColor = [self getColor];
//	return YES;
//}

@end


