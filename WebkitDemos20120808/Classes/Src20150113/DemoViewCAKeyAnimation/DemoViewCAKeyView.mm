
#import <UIKit/UIKit.h>
#import "DemoViewCAKeyView.h"
#import "FEEmojiViewController.h"



///< 私有方法
@interface DemoViewCAKeyView()

@property (nonatomic, retain) UIView *bgAnimationView;

- (void)addButtons;

@end

// =================================================================

@implementation DemoViewCAKeyView


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
	
	// "发起搜索"按钮
	btnRect = CGRectMake(0, 0, 60, 64);
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"搜索"];
	[pBtn setFrame:btnRect];
	
	nIndex = 2;
	// "把图片移到右下角变小透明"按钮
	btnRect.origin.x += 20 + btnRect.size.width;
	btnRect.size.width = 140;
	pBtn = [self createButton:nIndex withName:@"UIButtonTest2" withTitle:@"T3_页面加载完成"];
	[pBtn setFrame:btnRect];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	if (sender.tag == 1)
	{
		[self matchFestivalByKeyWord];
	}
	else if (sender.tag == 2)
	{
		[self showFEEmojiView];
	}
	
//	[self startAnimation];
}

// =================================================================
#pragma mark - ==动画结束

/*
 Keyframe Animation 关键帧动画
 关键帧动画（CAKeyframeAnimation）是一种可以替代基本动画的动画（CABasicAnimation）;它们都是CAPropertyAnimation的子类，它们都以相同的方式使用。不同的是，关键帧动画，除了可以指定起点和终点的值，也可以规定该动画的各个阶段（帧）的值。这相当于设置动画的属性值（一个NSArray）那么简单。
 
 */
#pragma mark - == Keyframe Animation 关键帧动画
- (void)startAnimation
{
	///< 测试动画调用接口
//	[self executeAnimation9:self];
	[self showFEEmojiView];
}

- (void)executeAnimation9:(UIView*)pView
{
	CGPoint pt = pView.center;
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:5];
	
	NSValue* value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	
	[animationValues addObject:value];
	
	pt.y -= 8/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	
	pt.y += 14/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	
	pt.y -= 10/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	
	pt.y += 4/2.0f;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"position";
	animation.duration = 50.0f/60;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunctions = @[
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  ];
	
	animation.keyTimes = @[@0.0, @(10.0f/60), @(23.0f/60), @(33.0f/60), @(50.0f/60)];
	// 应用动画
	[pView.layer addAnimation:animation forKey:nil];
}


- (void)showFEEmojiView
{
	[[FEEmojiViewController sharedInstance] showEmojiView:self];
}

- (void)matchFestivalByKeyWord
{
	[[FEEmojiViewController sharedInstance] matchFestivalByKeyWord:nil];
}

@end


