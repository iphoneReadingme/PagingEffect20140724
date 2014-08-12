
#import <UIKit/UIKit.h>
//#import "ResManager.h"
#import "DemoViewCALayer.h"
#import "DemoViewCATransform3D.h"
#import "DemoViewCALayerMacroDefine.h"


#define kIconViewShowing   @""
#define kIconViewHideing   @""

///< 私有方法
@interface DemoViewCALayer (DemoViewCALayer_Private)

- (void)addSubViews:(CGRect)frame;
- (void)addBgView:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void)addButtons;

- (void)add3DTransformView;
- (void)remove3DTransformView;

@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation DemoViewCALayer


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
	[m_pLabelRadius release];
	m_pLabelRadius = nil;
	
    [m_pImgView release];
	m_pImgView = nil;
}

- (void)addBgView:(CGRect)frame
{
	
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
	pLabel.text = @"圆角半径:[0]";
	pLabel.backgroundColor = [UIColor clearColor];
	
	[self addSubview:pLabel];
	m_pLabelRadius = [pLabel retain];
	[pLabel release];
}

- (void)addUISlider
{
	CGRect frame = [m_pLabelRadius frame];
	CGRect rect = CGRectZero;
	rect.origin.x = 10;
	rect.origin.y = frame.origin.y + frame.size.height;
	rect.size.width = 100;
	rect.size.height = 50;
	
	UISlider* pSlider = [[UISlider alloc] initWithFrame:rect];
	
    pSlider.minimumValue = 1;
	pSlider.maximumValue = 100;
    pSlider.value = 0;
    pSlider.accessibilityLabel = @"fontSizeSettingSlider";
	
	[pSlider addTarget:self action:@selector(onSliderValueChange:) forControlEvents:UIControlEventValueChanged];
	
	[self addSubview:pSlider];
	[pSlider release];
}

- (void)onSliderValueChange:(UISlider *)slider
{
    // 需要步进，四舍五入取值
    m_nCornerRadius = roundf(slider.value);
    slider.value = m_nCornerRadius*1.0f/slider.minimumValue;
	
	// Uncomment viewDidLoad and add the following lines
	self.layer.backgroundColor = [UIColor orangeColor].CGColor;
	self.layer.cornerRadius = m_nCornerRadius;
	m_pLabelRadius.text = [NSString stringWithFormat:@"圆角半径:[%d]", m_nCornerRadius];
}

// =================================================================
#pragma mark- == 3、层和子层
- (void)addSubLayer
{
	/*
	 设置layler的属性，下面分别是：
	 设置背景色，
	 阴影的偏差值，
	 阴影的半径，
	 阴影的颜色，
	 阴影的透明度，
	 子层的freme值。
	 然后把新的层add到view的层里。
	 */
	CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor purpleColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.frame = CGRectMake(130, 30, 60, 100);
    [self.layer addSublayer:sublayer];
}

// =================================================================
#pragma mark- == 4、添加图片内容和层的圆角
- (void)addImagelayer
{
	/*
	 主要内容有：
	 新建imagelayer放置图片
	 设置圆角半径cornerRadius
	 设置层的内容contents为图片
	 边界遮罩masksToBounds
	 */
	CALayer *sublayer = [CALayer layer];
	sublayer.backgroundColor = [UIColor purpleColor].CGColor;
	sublayer.shadowOffset = CGSizeMake(0, 3);
	sublayer.shadowRadius = 5.0;
	sublayer.shadowColor = [UIColor blackColor].CGColor;
	sublayer.shadowOpacity = 0.8;
	sublayer.frame = CGRectMake(130, 230, 128, 192);
	sublayer.borderColor = [UIColor blackColor].CGColor;
	sublayer.borderWidth = 2.0;
	sublayer.cornerRadius = 10.0;
	sublayer.cornerRadius = m_nCornerRadius;
	[self.layer addSublayer:sublayer];
	
	CALayer *imageLayer = [CALayer layer];
	imageLayer.frame = sublayer.bounds;
	CGRect rectImgLayer = CGRectMake(0, 0, 60, 100);
	imageLayer.frame = rectImgLayer;
	imageLayer.cornerRadius = 10.0;
	imageLayer.cornerRadius = m_nCornerRadius;
	//imageLayer.contents = (id)[UIImage imageNamed:@"ucappstore_songshu.png"].CGImage;
//	imageLayer.contents = (id)resGetImage(@"HomePage/appCenter/ucappstore_songshu.png").CGImage;
	imageLayer.masksToBounds = YES;
	[sublayer addSublayer:imageLayer];
}

- (void)addImageView
{
	m_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[m_imageView setFrame:CGRectMake(10, 10, 128, 128)];
//	m_imageView.image = resGetImage(@"HomePage/appCenter/ucappstore_songshu.png");
	//m_imageView.image = (id)resGetImage(@"HomePage/appCenter/ucappstore_songshu.png").CGImage;
	[self addSubview:m_imageView];
}


- (void)addSubViews:(CGRect)frame
{
	CGSize size = frame.size;
	size.height = 2048;
	self.contentSize = size;
	
	[self addBgView:frame];
	[self addSubLayer];
	[self addImagelayer];
	[self addImageView];
	
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
	
	[self addSubview:button];
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
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"打开3D动画视图"];
	[pBtn setFrame:btnRect];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	
	self.backgroundColor = [UIColor clearColor];
	[self add3DTransformView];
}

#pragma mark -== 3D动画
- (void)add3DTransformView
{
	m_pViewCATransform3D = [[DemoViewCATransform3D alloc] initWithFrame:[self frame]];
	[self addSubview:m_pViewCATransform3D];
}

- (void)remove3DTransformView
{
	[m_pViewCATransform3D removeFromSuperview];
	[m_pViewCATransform3D release];
	m_pViewCATransform3D = nil;
}

- (void)onButtonBack
{
	[self remove3DTransformView];
}

@end


