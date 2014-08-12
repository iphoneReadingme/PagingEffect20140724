

#import "BookLayoutConfig.h"
#import "DemoSettingView.h"
#import "DemoViewSimpleParagraph.h"
#import "DemoViewCoreTextDraw.h"
#import "DemoViewCoreTextDrawMacroDefine.h"



///< 私有方法
@interface DemoViewCoreTextDraw (/*DemoViewCoreTextDraw_private*/)
{
	
}

@property (nonatomic, retain) DemoSettingView * demoSettingView;
@property (nonatomic, retain) BookLayoutConfig * layoutConfig;
@property (nonatomic, retain) DemoViewSimpleParagraph * simplePageView;

- (void)addSomeViews:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

- (void)addButtons:(CGRect)frame;


@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation DemoViewCoreTextDraw


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
		
		self.layoutConfig = [BookLayoutConfig bookLayoutConfigWithFontSize:18 andWidth:320 andHeight:440];
		[self.layoutConfig setDefaultParam];
		
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
	
	self.demoSettingView = nil;
	self.simplePageView = nil;
	self.layoutConfig = nil;
}

// =================================================================
#pragma mark- == 边框圆角半径 设置层的背景颜色，层的设置圆角半径为20
#define kKeyButtonHeight        50

- (void)addSomeViews:(CGRect)frame
{
	// MARK: 添加观察者接口
	[self addAppObserver];
	
//	CGSize size = frame.size;
//	size.height = 2048;
//	self.contentSize = size;
	
	CGRect rect = CGRectMake(0, 60, frame.size.width, frame.size.height - kKeyButtonHeight -20);
	[self addSimpleParagraphView:rect];
	
	rect = CGRectMake(0, frame.size.height - kKeyButtonHeight -10, frame.size.width, kKeyButtonHeight);
	[self addButtons:rect];
}

- (void)addSimpleParagraphView:(CGRect)frame
{
	self.simplePageView = [[[DemoViewSimpleParagraph alloc] initWithFrame:frame] autorelease];
	[self addSubview:_simplePageView];
	_simplePageView.layer.borderColor = [UIColor redColor].CGColor;
	_simplePageView.layer.borderWidth = 2;
}

// =================================================================
#pragma mark- == Core Animation之多种动画效果
// 1、把图片移到右下角变小透明
// =================================================================
#pragma mark-
#pragma mark 创建按钮

- (void)onButtonClickEvent:(UIButton*)button
{
	int nTag = button.tag;
	if (nTag == 1)
	{
		// 下一页
//		[self showNextPage];
	}
	else if (nTag == 2)
	{
		// 上一页
//		[self showPreviousPage];
	}
	else if (nTag == 3)
	{
		// 下一章
//		[self showNextChapter];
	}
	else if (nTag == 4)
	{
		// 上一章
//		[self showPreviousChapter];
	}
	else if (nTag == 5)
	{
		// "属性配置"按钮
		[self addSettingView];
	}
}

- (void)addButtons:(CGRect)frame
{
	UIButton* pBtn = nil;
    CGRect selfFrame = frame;
    int btnWidth = selfFrame.size.width / 5;
	int nTag = 1;
	
	btnWidth -= 5;
	CGRect btnRect = CGRectMake(0, frame.origin.y, btnWidth, frame.size.height);
//	btnRect.origin.y = selfFrame.size.height - btnRect.size.height;
	
#if 0
	// "下一页"按钮
	nTag = 1;
	btnRect.origin.x += 0;
	pBtn = [self newButton:nTag withName:nil withTitle:@"下一页"];
	[pBtn setFrame:btnRect];
	[pBtn release];
	
	// "上一页"按钮
	nTag = 2;
	btnRect.origin.x += btnWidth + 5;
	pBtn = [self newButton:nTag withName:nil withTitle:@"上一页"];
	[pBtn setFrame:btnRect];
	[pBtn release];
	
	// "下一章"按钮
	nTag = 3;
	btnRect.origin.x += btnWidth + 5;
	pBtn = [self newButton:nTag withName:nil withTitle:@"下一章"];
	[pBtn setFrame:btnRect];
	[pBtn release];
	
	// "上一章"按钮
	nTag = 4;
	btnRect.origin.x += btnWidth + 5;
	pBtn = [self newButton:nTag withName:nil withTitle:@"上一章"];
	[pBtn setFrame:btnRect];
	[pBtn release];
#endif
	// "属性配置"按钮
	nTag = 5;
	//	btnRect.origin.x = (selfFrame.size.width - btnWidth)*0.5f;
	btnRect.origin.x = selfFrame.size.width - btnWidth;
	pBtn = [self newButton:nTag withName:nil withTitle:@"属性配置"];
	[pBtn setFrame:btnRect];
	[pBtn release];
}

- (UIButton*)newButton:(int)nTag withName:(NSString*)pStrName withTitle:(NSString*)pTitle
{
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button addTarget:self action:@selector(onButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = nTag;
	button.accessibilityLabel = pStrName;
	[button setTitle:pTitle forState:UIControlStateNormal];
	button.backgroundColor = [UIColor blueColor];
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	[self addSubview:button];
	
	return button;
}

// =================================================================
#pragma mark- ==添加观察者接口

- (void)addAppObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTextAttributes:) name:kKeyNotificationSaveTextAttributes object:nil];
}

- (void)removeAppObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKeyNotificationSaveTextAttributes object:nil];
}

#pragma mark -==文本属性设置相关
- (void)saveTextAttributes:(NSNotification*)notify
{
	if ([NSThread isMainThread])
	{
		//		[self saveTextAttributesDelay:notify];
		[self performSelector:@selector(saveTextAttributesDelay:) withObject:notify afterDelay:0.05f];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(saveTextAttributesDelay:) withObject:notify waitUntilDone:NO];
	}
}

- (void)saveTextAttributesDelay:(NSNotification*)notify
{
	[self releaseSettingView];
	
	NSMutableDictionary* dict = [notify object];
	NSLog(@"===dict=%@", dict);
	
	NSString* value = [dict objectForKey:@"fontName"];
	self.layoutConfig.fontName = value;
	
	value = [dict objectForKey:@"fontSize"];
	self.layoutConfig.fontSize = [value intValue];
	
	value = [dict objectForKey:@"lineSpace"];
	self.layoutConfig.lineSpace = [value intValue];
	
	value = [dict objectForKey:@"paragraphSpacing"];
	self.layoutConfig.paragraphSpacing = [value intValue];
	
	NSNumber* number = [dict objectForKey:@"TextAlignment"];
	self.layoutConfig.textAlignment = [number intValue];
	
	value = [dict objectForKey:@"UIEdgeInsets"];
	self.layoutConfig.contentInset = UIEdgeInsetsFromString(value);
	self.layoutConfig.contentInset = UIEdgeInsetsMake(15, 10, 0, 10);
	
	self.layoutConfig.pageTextColor = [dict objectForKey:@"pageTextColor"];
	self.layoutConfig.titleTextColor = [dict objectForKey:@"titleTextColor"];
	
	_simplePageView.layoutConfig = self.layoutConfig;
	
	// 刷新
	[self performSelector:@selector(delayRedraw) withObject:nil afterDelay:0.50f];
}

- (void)delayRedraw
{
    [_simplePageView setNeedsDisplay];
}

- (void)releaseSettingView
{
	if (_demoSettingView)
	{
		[_demoSettingView removeFromSuperview];
		self.demoSettingView = nil;
	}
	
}

- (void)addSettingView
{
	[self releaseSettingView];
	
	CGRect rect = [self bounds];
	rect.origin.y = 20;
	self.demoSettingView = [[[DemoSettingView alloc] initWithFrame:rect] autorelease];
	[self addSubview:_demoSettingView];
}


@end


