
#import <UIKit/UIKit.h>
#import "ResManager.h"
#import "DemoViewCATransform3D.h"
#import "DemoViewCALayerMacroDefine.h"


#define kIconViewShowing   @""
#define kIconViewHideing   @""
#define kLabelText         @"3D动画角度:[%d]"

///< 私有方法
@interface DemoViewCATransform3D (DemoViewCALayer_Private)

- (void)addSubViews:(CGRect)frame;
- (void)addBgView:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void)addButtons;

@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation DemoViewCATransform3D


- (void)forTest
{
	// for test
//	self.backgroundColor = [UIColor brownColor];
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor colorWithRed:0.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		[self forTest];
		self.backgroundColor = [UIColor clearColor];
		[self addSubViews:[self bounds]];
		
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
	[m_pLabelTitle release];
	m_pLabelTitle = nil;
	
	[m_pContainerView release];
	m_pContainerView = nil;
	[m_p3DAnimationView release];
	m_p3DAnimationView = nil;
	
}

- (CGRect)getFrame3DAnimationView
{
	CGRect rect = [self bounds];
	rect.origin.x = 100;
	rect.size.width -= 100;
	
	return rect;
}

- (void)addBgView:(CGRect)frame
{
	
	m_pContainerView = [[UIView alloc] initWithFrame:frame];
	m_pContainerView.backgroundColor = [UIColor grayColor];
	[self addSubview:m_pContainerView];
	
	CGRect rect = [self getFrame3DAnimationView];
	m_p3DAnimationView = [[UIImageView alloc] initWithFrame:rect];
	m_p3DAnimationView.backgroundColor = [UIColor magentaColor];
	m_p3DAnimationView.image = resGetImage(@"HomePage/appCenter/ucappstore_songshu.png");
	
	[m_pContainerView addSubview:m_p3DAnimationView];
}

// =================================================================
#pragma mark- == 边框圆角半径 设置层的背景颜色，层的设置圆角半径为20
- (void)addLabel
{
	CGRect rect = CGRectZero;
	rect.origin.x = 10;
	rect.origin.y = 100;
	rect.size.width = 150;
	rect.size.height = 40;
	UILabel* pLabel = [[UILabel alloc] initWithFrame:rect];
	pLabel.text = [NSString stringWithFormat:kLabelText, 0];
	pLabel.backgroundColor = [UIColor clearColor];
	
	[m_pContainerView addSubview:pLabel];
	m_pLabelTitle = [pLabel retain];
	[pLabel release];
}

- (void)addUISlider
{
	CGRect frame = [m_pLabelTitle frame];
	CGRect rect = CGRectZero;
	rect.origin.x = 10;
	rect.origin.y = frame.origin.y + frame.size.height;
	rect.origin.y = 0;
	rect.size.width = 90/2.0f;
	rect.size.height = 50;
	
	UISlider* pSlider = [[UISlider alloc] initWithFrame:rect];
	
    pSlider.minimumValue = 1;
	pSlider.maximumValue = rect.size.width;
    pSlider.value = 0;
    pSlider.accessibilityLabel = @"fontSizeSettingSlider";
	
	[pSlider addTarget:self action:@selector(onSliderValueChange:) forControlEvents:UIControlEventValueChanged];
	
	[m_pContainerView addSubview:pSlider];
	[pSlider release];
}

- (void)onSliderValueChange:(UISlider *)slider
{
    // 需要步进，四舍五入取值
    int nValue = roundf(slider.value);
    slider.value = nValue*1.0f/slider.minimumValue;
	m_nAngle = nValue + nValue;
	// Uncomment viewDidLoad and add the following lines
//	self.layer.backgroundColor = [UIColor orangeColor].CGColor;
//	self.layer.cornerRadius = m_nCornerRadius;
//	m_pLabelTitle.text = [NSString stringWithFormat:@"圆角半径:[%d]", m_nCornerRadius];
	m_pLabelTitle.text = [NSString stringWithFormat:kLabelText, m_nAngle];
	
	[self onCATransform3D:m_nAngle];
}

-(int)getSubviewIndex
{
	return [self.superview.subviews indexOfObject:self];
}

- (BOOL)isPortraitScreen    ///< 是否竖屏
{
	UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationIsPortrait(statusBarOrientation);
	
	//CGRect bounds = [UIGlobal getMainBounds];
	//return (bounds.size.height > bounds.size.width);
}

- (float)getScale
{
	return (1 - m_nAngle/180.0f);
}

- (void)printTransform:(CATransform3D)transform
{
	NSLog(@"================angle=%3d=====================", m_nAngle);
	NSLog(@"   1         2          3         4");
	NSLog(@"%0.6f  %0.6f  %0.6f  %0.6f", transform.m11, transform.m13, transform.m13, transform.m14);
	NSLog(@"%0.6f  %0.6f  %0.6f  %0.6f", transform.m21, transform.m23, transform.m23, transform.m24);
	NSLog(@"%0.6f  %0.6f  %0.6f  %0.6f", transform.m31, transform.m33, transform.m33, transform.m34);
	NSLog(@"%0.6f  %0.6f  %0.6f  %0.6f", transform.m41, transform.m43, transform.m43, transform.m44);
}

- (void)onCATransform3D:(int)nAngle
{
	UIView * animationView = m_p3DAnimationView;
//	UIView * back_view = m_pContainerView;
//	int orignalIndex = [self getSubviewIndex];
	
	CGRect frame = animationView.frame;
	CGPoint anchorPoint = animationView.layer.anchorPoint;
	
	CATransform3D transform = CATransform3DIdentity;
//	transform = animationView.layer.transform;
//	MWMD_LOG_NSLOG(@"===UIView animate transform preparing start===");
	if ([self isPortraitScreen])
	{
		// anchorPoint 用于控制动画起点坐标
		animationView.layer.anchorPoint = CGPointMake(0.5, 0.50);
//		transform.m34 = 1.0/400;
		transform.m34 = [self getScale];
		
		transform = CATransform3DConcat(animationView.layer.transform, transform);
		transform = CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 360-m_nAngle), transform);
		transform = CATransform3DConcat(CATransform3DMakeRotation(m_nAngle/180.0f, 1, 0, 0), transform);
		//            transform = CATransform3DConcat(CATransform3DMakeTranslation(0, 100, 400), transform);
		//            transform = CATransform3DConcat(CATransform3DMakeRotation(M_PI_2 * 92 / 100, 1, 0, 0), transform);
		transform = CATransform3DMakeRotation(m_nAngle/180.0f, 1, 0, 0);
		transform.m34 = -1.0f / 400;
//		MWMD_LOG_NSLOG(@"===isPortraitScreen animate transform ====");
		[self printTransform:transform];
	}
	else
	{
		animationView.layer.anchorPoint = CGPointMake(0.80, 0.5);
		transform.m34 = 1.0/400;
//		transform = CATransform3DConcat(CATransform3DMakeTranslation(100, 0, 400), transform);
//		transform = CATransform3DConcat(CATransform3DMakeRotation(M_PI_2 * 92 / 100, 0, -1, 0), transform);
		transform = CATransform3DConcat(CATransform3DMakeTranslation(100, 0, m_nAngle), transform);
		transform = CATransform3DConcat(CATransform3DMakeRotation(m_nAngle/360.0f, 0, -1, 0), transform);
	}
	
//	MWMD_LOG_NSLOG(@"===UIView animate transform preparing end===");
	
	animationView.frame = frame;
	animationView.layer.transform = transform;
	
	NSLog(@"%@", animationView);
	NSLog(@"%@", [[animationView layer] description]);
	// 图层的 zPosition 属性值指定了该图层位于 Z 轴上面位置,zPosition 用于设置图层 相对于图层的同级图层的可视位置。
//	int zPosition = animationView.layer.zPosition;
//	animationView.layer.zPosition = 1000;
//	
//	MWMD_LOG_NSLOG(@"===UIView animate start ===");
//	
//	[UIView animateWithDuration:0.3
//						  delay:0
//	 // // slow at beginning and end
//						options:UIViewAnimationOptionCurveEaseInOut
//					 animations:^{
//						 animationView.layer.transform = CATransform3DIdentity;
//						 
//					 }
//					 completion:^(BOOL finished) {
//						 MWMD_LOG_NSLOG(@"===UIView animate finished 动画time = 0.3s ===");
//						 animationView.layer.anchorPoint = anchorPoint;
//						 animationView.frame = frame;
//						 animationView.layer.zPosition = zPosition;
//						 
//						 
//					 }];
	
	
	animationView.layer.zPosition = 3*m_nAngle;
	animationView.layer.anchorPoint = anchorPoint;
	if ([self getScale] < -0.9 || [self getScale] > 0.9)
	{
		animationView.layer.zPosition = 0;
		animationView.layer.anchorPoint = CGPointMake(0.5, 0.50);
		animationView.layer.transform = CATransform3DIdentity;
		animationView.frame = [self getFrame3DAnimationView];
	}
}

// =================================================================

- (void)addSubViews:(CGRect)frame
{
	[self addBgView:frame];
	[self addLabel];
	[self addUISlider];
	
	[self addButtons];
}


// =================================================================
#pragma mark-
#pragma mark 动画结束

///< 动画结束
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:kIconViewHideing])
	{
		//WKMD_LOG_NSLOG(@"==iconView_hiding==animationDidStop===");
	}
    else if ([animationID isEqualToString:kIconViewShowing])
    {
		//WKMD_LOG_NSLOG(@"==iconView_showing==animationDidStop===");
		
    }
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
	
//	[self addSubview:button];
	//[button retain];
	
	return button;
}

- (void)addButtons
{
	CGRect frame = [self bounds];
	CGRect btnRect = CGRectMake(0, 0, 100, 64);
	btnRect.origin.x = frame.size.width - btnRect.size.width;
	int nIndex = 0;
	UIButton* pBtn = nil;
	
	// "把图片移到右下角变小透明"按钮
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"返回"];
	[pBtn setFrame:btnRect];
	[m_pContainerView addSubview:pBtn];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	if ([[self superview] respondsToSelector:@selector(onButtonBack)])
	{
		[[self superview] performSelector:@selector(onButtonBack)];
	}
}

@end


