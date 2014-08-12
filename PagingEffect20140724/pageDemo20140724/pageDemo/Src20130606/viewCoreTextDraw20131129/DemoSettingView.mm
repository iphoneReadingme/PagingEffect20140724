
#import "ColorPickerView.h"
#import "DemoSettingView.h"


///< 私有方法
@interface DemoSettingView (/*DemoSettingView_Private*/) <UIPickerViewDelegate, UIPickerViewDataSource>
{
	
}

@property (nonatomic, retain) UIColor* pageTextColor;       ///< 文本文字颜色
@property (nonatomic, retain) UIColor* titleTextColor;      ///< 标题文字颜色
@property (nonatomic, retain) ColorPickerView * colorPickView;       // 颜色选择


- (void)addSomeViews:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

- (void)addButtons;

@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation DemoSettingView


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
//		[self forTest];
		self.backgroundColor = [UIColor grayColor];
		
		// MARK: 添加观察者接口
		[self addAppObserver];
		
		self.pageTextColor = [UIColor blackColor];
		self.titleTextColor = [UIColor blackColor];
		
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
	[self removeAppObserver];
	[self releaseColorPickView];
	
	[m_pFontName release];
	m_pFontName = nil;
	
	[m_pFontSize release];
	m_pFontSize = nil;
	[m_pLineSpace release];
	m_pLineSpace = nil;
	[m_pParagraphSpacing release];
	m_pParagraphSpacing = nil;
	
	[m_pTextAlignment release];
	m_pTextAlignment = nil;
}

// =================================================================
#pragma mark- == 属性设置
- (void)addTextFieldLineSpace:(CGRect)rect
{
//	CGRect rect = CGRectZero;
//	rect.origin.x = 10;
//	rect.origin.y = 100;
//	rect.size.width = 80;
//	rect.size.height = 40;
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = @"行间距:";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect.size.width;
	
	UITextField* pLineSpace = [[UITextField alloc] initWithFrame:rect];
	
	pLineSpace.backgroundColor = [UIColor whiteColor];
	pLineSpace.text = @"8";
	m_pLineSpace = [pLineSpace retain];
	[self addSubview:pLineSpace];
	[pLineSpace release];
}

- (void)addTextFieldFontSize:(CGRect)rect
{
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = @"文字大小:";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect.size.width;
	
	UITextField* pFontSize = [[UITextField alloc] initWithFrame:rect];
	
	pFontSize.backgroundColor = [UIColor whiteColor];
	pFontSize.text = @"16";
	m_pFontSize = [pFontSize retain];
	[self addSubview:pFontSize];
	[pFontSize release];
}


static NSArray* fontNameList =@[@"Bodoni 72",
								@"Arial",
								@"Helvetica",
								@"STHeitiSC-Light",
//								@"FZLanTingHeiS-R-GB",
//								@"Bitstream Vera Sans Mono",
								@"Didot",
								@"Futura",
								@"Hoefler Text",
								@"Zapfino",
								];

- (void)addTextFieldFontName:(CGRect)rect
{
	CGRect rect1 = rect;
	rect1.size.width = 160;
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect1];
	pLabel.text = [NSString stringWithFormat:@"文字字体:[1,%d]", [fontNameList count]];
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect1.size.width;
	
	UITextField* pFontName = [[UITextField alloc] initWithFrame:rect];
	
	pFontName.backgroundColor = [UIColor whiteColor];
	pFontName.text = @"2";
	m_pFontName = [pFontName retain];
	[self addSubview:pFontName];
	[pFontName release];
}

- (void)addTextFieldParagraphSpacing:(CGRect)rect
{
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = @"段间距:";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += rect.size.width;
	
	UITextField* pTextField = [[UITextField alloc] initWithFrame:rect];
	
	pTextField.backgroundColor = [UIColor whiteColor];
	pTextField.text = @"0";
	m_pParagraphSpacing = [pTextField retain];
	[self addSubview:pTextField];
	[pTextField release];
}

- (void)addSomeViews:(CGRect)frame
{
	CGSize size = frame.size;
	size.height = 2048;
	self.contentSize = size;
	
	CGRect rect = CGRectMake(10, 100, 80, 40);
	
	[self addTextFieldFontSize:rect];
	
	rect.origin.y += 10;
	rect.origin.y += rect.size.height;
	[self addTextFieldFontName:rect];
	
	rect.origin.y += 10;
	rect.origin.y += rect.size.height;
	[self addTextFieldLineSpace:rect];
	
	rect.origin.y += 10;
	rect.origin.y += rect.size.height;
	[self addTextFieldParagraphSpacing:rect];
	
	rect.size.height = 80;
	rect.origin.y += 60;
	rect.size.width += rect.size.height;
	[self addUIPickerViewTextAlignment:rect];
	
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
	CGRect frame = [self bounds];
	CGRect btnRect = CGRectMake(0, 40, 100, 50);
	btnRect.origin.x = frame.size.width - btnRect.size.width;
	
	int nIndex = 1;
	UIButton* pBtn = nil;
	
	btnRect.origin.x = 20;
	pBtn = [self createButton:nIndex++ withName:@"UIButtonTest1" withTitle:@"保存文本属性"];
	[pBtn setFrame:btnRect];
	
	btnRect.origin.x += btnRect.size.width + 10;
	pBtn = [self createButton:nIndex++ withName:@"UIButtonTest1" withTitle:@"标题颜色"];
	[pBtn setFrame:btnRect];
	
	btnRect.origin.x += btnRect.size.width + 10;
	pBtn = [self createButton:nIndex++ withName:@"UIButtonTest1" withTitle:@"文字颜色"];
	[pBtn setFrame:btnRect];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	int nTag = sender.tag;
	if (nTag == 1)
	{
		[self saveTextAttributes];
	}
	else if (nTag == 2)
	{
		[self addColorPickView:kKeyNotificationSaveChapterNameColorAttributes];
	}
	else if (nTag == 3)
	{
		[self addColorPickView:kKeyNotificationSaveTextColorAttributes];
	}
}

- (NSString*)getFontName:(int)index
{
	NSString* fontName = nil;
	if (1 <= index && index <= [fontNameList count])
	{
	}
	else
	{
		index = 2;
	}
	
	fontName = [fontNameList objectAtIndex:index-1];
	
	return fontName;
}

#pragma mark -== 保存文本属性
- (void)saveTextAttributes
{
	//	[m_pLineSpace becomeFirstResponder];
	[m_pLineSpace resignFirstResponder];
	[m_pFontSize resignFirstResponder];
	[m_pFontName resignFirstResponder];
	[m_pParagraphSpacing resignFirstResponder];
	
	
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
	[dict setObject:[self getFontName:[m_pFontName.text intValue]] forKey:@"fontName"];
	[dict setObject:m_pFontSize.text forKey:@"fontSize"];
	[dict setObject:m_pLineSpace.text forKey:@"lineSpace"];
	[dict setObject:m_pParagraphSpacing.text forKey:@"paragraphSpacing"];
	int nIndex = [m_pTextAlignment selectedRowInComponent:0];
	[dict setObject:[NSNumber numberWithInt:nIndex] forKey:@"TextAlignment"];
	
	[dict setObject:_pageTextColor forKey:@"pageTextColor"];
	[dict setObject:_titleTextColor forKey:@"titleTextColor"];
	
	// 暂时使用默认值
	NSString* edgeInsets = NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0, 10, 0, 10));
	[dict setObject:edgeInsets forKey:@"UIEdgeInsets"];
	
	
	NSLog(@"===通知保存文本属性===");
	[[NSNotificationCenter defaultCenter] postNotificationName:kKeyNotificationSaveTextAttributes object:dict];
}

#pragma mark -==选择文本对齐方式


static NSArray* textAlignmentList =@[@"左对齐",
								@"右对齐",
								@"居中对齐",
								@"左右对齐",
								@"自然文本对齐",
								];

- (void)addUIPickerViewTextAlignment:(CGRect)rect
{
	CGRect labelFrame = rect;
	labelFrame.size.width = 120;
	UILabel* pLabel = [[UILabel alloc] initWithFrame:labelFrame];
	pLabel.text = @"文本对齐方式:";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	[pLabel release];
	
	rect.origin.x += labelFrame.size.width;
	
	UIPickerView* pUIPickerView = [[UIPickerView alloc] initWithFrame:rect];
	
	pUIPickerView.backgroundColor = [UIColor whiteColor];
	pUIPickerView.delegate = self;
	m_pTextAlignment = [pUIPickerView retain];
	[self addSubview:pUIPickerView];
	[pUIPickerView release];
}

#pragma mark -
#pragma mark Picker Date Source Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [textAlignmentList count];
}


#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [textAlignmentList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0)
	{
        NSString *selectedState = [textAlignmentList objectAtIndex:row];
		NSLog(@"selectedState=%@", selectedState);
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return [pickerView bounds].size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

// =================================================================
#pragma mark- ==添加观察者接口

- (void)addAppObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTextColorAttributes:) name:kKeyNotificationSaveTextColorAttributes object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTextColorAttributes:) name:kKeyNotificationSaveChapterNameColorAttributes object:nil];
}

- (void)removeAppObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKeyNotificationSaveTextColorAttributes object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKeyNotificationSaveChapterNameColorAttributes object:nil];
}

- (void)saveTextColorAttributes:(NSNotification*)notify
{
	if ([NSThread isMainThread])
	{
		//		[self saveTextAttributesDelay:notify];
		[self performSelector:@selector(saveTextColorAttributesDelay:) withObject:notify afterDelay:0.05f];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(saveTextColorAttributesDelay:) withObject:notify waitUntilDone:NO];
	}
}

- (void)saveTextColorAttributesDelay:(NSNotification*)notify
{
	[self releaseColorPickView];
	
	UIColor* color = [notify object];
	if ([[notify name] isEqualToString:kKeyNotificationSaveTextColorAttributes])
	{
		self.pageTextColor = color;
	}
	
	if ([[notify name] isEqualToString:kKeyNotificationSaveChapterNameColorAttributes])
	{
		self.titleTextColor = color;
	}
}

- (void)releaseColorPickView
{
	if (_colorPickView)
	{
		[_colorPickView removeFromSuperview];
		self.colorPickView = nil;
	}
}

- (void)addColorPickView:(NSString*)kKeyNotify
{
	[self releaseColorPickView];
	
	CGRect rect = [self bounds];
	rect.origin.y = 20;
	self.colorPickView = [[[ColorPickerView alloc] initWithFrame:rect with:kKeyNotify] autorelease];
	[self addSubview:self.colorPickView];
}

@end

