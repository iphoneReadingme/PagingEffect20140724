
#import <UIKit/UIKit.h>
//#import "ResManager.h"
#import "DemoViewCALayer.h"
#import "DemoViewCATransform3D.h"
#import "DemoViewCALayerMacroDefine.h"


#define kIconViewShowing   @""
#define kIconViewHideing   @""

///< 私有方法
@interface DemoViewCALayer()// (DemoViewCALayer_Private)

@property (nonatomic, retain) UIView *bgAnimationView;
@property (nonatomic, retain) UIImageView *leftIcon;
@property (nonatomic, retain) UIView *bezierCuvShapeView;  ///< 显示三次贝塞尔曲线的函数缓冲图像的视图


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

- (void)addSubViews:(CGRect)frame
{
	CGSize size = frame.size;
	size.height = 2048;
	self.contentSize = size;
	
	[self addSubLayer];
	[self addImagelayer];
	[self addImageView];
	
	[self addLabel];
	[self addUISlider];
	[self addButtons];
	
	[self addBgView:frame];
}

- (void)addBgView:(CGRect)frame
{
	CGRect rect = CGRectMake(20, 60, 100, 100);
	UIView* pView = [[[UIView alloc] initWithFrame:rect] autorelease];
	pView.backgroundColor = [UIColor whiteColor];
	[self addSubview:pView];
	self.bezierCuvShapeView = pView;
	
	rect = CGRectMake(0, rect.origin.y+rect.size.height+20, 100, 44);
	pView = [[[UIView alloc] initWithFrame:rect] autorelease];
	pView.backgroundColor = [UIColor whiteColor];
	[self addSubview:pView];
	self.bgAnimationView = pView;
	
	CGRect imgRect = CGRectMake(0, 0, 28, 28);
	imgRect.origin.x = (rect.size.width - imgRect.size.width)*0.5;
	imgRect.origin.y = (rect.size.height - imgRect.size.height)*0.5;
	UIImageView* imgView = [[[UIImageView alloc] initWithFrame:imgRect] autorelease];
	imgView.backgroundColor = [UIColor grayColor];
	[self.bgAnimationView addSubview:imgView];
	self.leftIcon = imgView;
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
	[self startAnimation];
	
//	self.backgroundColor = [UIColor clearColor];
//	[self add3DTransformView];
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

/*
 Keyframe Animation 关键帧动画
 关键帧动画（CAKeyframeAnimation）是一种可以替代基本动画的动画（CABasicAnimation）;它们都是CAPropertyAnimation的子类，它们都以相同的方式使用。不同的是，关键帧动画，除了可以指定起点和终点的值，也可以规定该动画的各个阶段（帧）的值。这相当于设置动画的属性值（一个NSArray）那么简单。
 
 */
#pragma mark - == Keyframe Animation 关键帧动画
- (void)startAnimation
{
	///< 测试动画调用接口
//	[self executeAnimation:self.leftIcon];
//	[self executeAnimation1:self.bezierCuvShapeView];
//	[self executeAnimation2:self.leftIcon];
	
//	[self executeAnimation4:self.bgAnimationView];
//	[self executeAnimation5:self.bgAnimationView];
	//	[self executeAnimation6:self.bgAnimationView];
//	[self executeAnimation7:self.leftIcon];

//	[self executeAnimation8:self.leftIcon];
	[self executeAnimation9:self.leftIcon];
}


/*
 CAMediaTimingFunction有一个getControlPointAtIndex:values:的方法，可以用来检索曲线的点，使用它我们可以找到标准缓冲函数的点，然后用UIBezierPath和CAShapeLayer来把它画出来。
 */
- (void)executeAnimation1:(UIView*)pView
{
	// 创建计时函数
	CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	// 获得控制点
	CGPoint controlPoint1, controlPoint2;
	[function getControlPointAtIndex:1 values:(float *)&controlPoint1];
	[function getControlPointAtIndex:2 values:(float *)&controlPoint2];
	// 创建曲线
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointZero];
	[path addCurveToPoint:CGPointMake(1, 1) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
	// 缩放路径到可显示状态
	[path applyTransform:CGAffineTransformMakeScale(50, 50)];
	// 创建CAShapeLayer
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.strokeColor = [UIColor redColor].CGColor;
	shapeLayer.fillColor = [UIColor clearColor].CGColor;
	shapeLayer.lineWidth = 2.0f;
	shapeLayer.path = path.CGPath;
	[pView.layer addSublayer:shapeLayer];
	// flip geometry so that 0,0 is in the bottom-left
	pView.layer.geometryFlipped = YES;
}

///< 小例子：添加了自定义缓冲函数的时钟程序
- (void)executeAnimation3:(UIView*)pView
{
}

- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated
{
	// 生成变换
	CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
	if (animated) {
		// 创建变换动画
		CABasicAnimation *animation = [CABasicAnimation animation];
		animation.keyPath = @"transform";
		animation.fromValue = [handView.layer.presentationLayer valueForKey:@"transform"];
		animation.toValue = [NSValue valueWithCATransform3D:transform];
		animation.duration = 0.5;
		animation.delegate = self;
		animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
		// 应用动画
		handView.layer.transform = transform;
		[handView.layer addAnimation:animation forKey:nil];
	} else {
		// 直接设置变换
		handView.layer.transform = transform;
	}
}

- (void)executeAnimation:(UIView*)pView
{
	//	pView.enabled = NO;
	[UIView animateWithDuration:0.15 animations:^{
		pView.transform = CGAffineTransformMakeScale(0.7, 0.7);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.15 animations:^{
			pView.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			//[self setAddBtnState:NO];
			[UIView animateWithDuration:0.02 animations:^{
				pView.transform = CGAffineTransformMakeScale(1.09, 1.09);
			} completion:^(BOOL finished) {
				//[self.addToBookShelfBtn startAnimation];
				[UIView animateWithDuration:0.1 animations:^{
					pView.transform = CGAffineTransformMakeScale(0.97, 0.97);
				} completion:^(BOOL finished) {
					[UIView animateWithDuration:0.2 animations:^{
						pView.transform = CGAffineTransformMakeScale(1.0, 1.0);
					} completion:^(BOOL finished) {
						//						pView.enabled = YES;
					}];
				}];
			}];
		}];
	}];
}

- (void)executeAnimation2:(UIView*)pView
{
	///< 【动画 1】
	CAKeyframeAnimation *boundsOvershootAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
	CGSize startingSize = CGSizeZero;
	CGSize targetSize = CGSizeMake(100,100);
	CGSize overshootSize = CGSizeMake(120,120);
	CGSize undershootSize = CGSizeMake(80,80);
	
	NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCGSize:startingSize],
							 [NSValue valueWithCGSize:targetSize],
							 [NSValue valueWithCGSize:overshootSize],
							 [NSValue valueWithCGSize:undershootSize],
							 [NSValue valueWithCGSize:targetSize], nil];
	[boundsOvershootAnimation setValues:boundsValues];
	
	NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
					  [NSNumber numberWithFloat:0.5f],
					  [NSNumber numberWithFloat:0.8f],
					  [NSNumber numberWithFloat:0.9f],
					  [NSNumber numberWithFloat:1.0f], nil];
	[boundsOvershootAnimation setKeyTimes:times];
	boundsOvershootAnimation.duration = 1.0;
	
	///< 【动画 2】
	// Create a basic animation to restore the size of the placard
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.duration = 0.2;
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
	opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
	opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; // EaseIn curve
	//opacityAnimation.timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]]; // EaseOut curve
	opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1.0 :0.0 :1.0 :0.1]; // Bezier curve
	//opacityAnimation.timingFunction 是用来控制动画线性发展。
	//其中[CAMediaTimingFunction functionWithControlPoints:1.0 :0.0 :1.0 :0.1] 是一个贝塞尔曲线的控制方法。
	//这也可以令动画做到先慢後快或先快後慢的结果。 你会问, 我怎知道效果会怎样? 这里有一个图表化的工具说明数字线性关係 http://netcetera.org/camtf-playground.html
	
	// Create an animation group to combine the keyframe and basic animations
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction
	theGroup.delegate = self;
	theGroup.duration = 0.3f;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	theGroup.animations = [NSArray arrayWithObjects:boundsOvershootAnimation, transformAnimation, nil];
	
	///< 插入动画
	// Add the animation group to the layer
	[pView.layer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
}


/*
 这种方式还算不错，但是实现起来略显笨重（因为要不停地尝试计算各种关键帧和时间偏移）并且和动画强绑定了（因为如果要改变动画的一个属性，
 那就意味着要重新计算所有的关键帧）。
 那该如何写一个方法，用缓冲函数来把任何简单的属性动画转换成关键帧动画呢，下面我们来实现它。
 */
///< 小例子：使用关键帧实现反弹球的动画
- (void)executeAnimation4:(UIView*)pView
{
	CGFloat yOffset = self.bgAnimationView.frame.size.height;
	// 重置球到屏幕顶部
	pView.center = CGPointMake(150, 32+yOffset);
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"position";
	animation.duration = 1.0;
	animation.delegate = self;
	animation.values = @[
						 [NSValue valueWithCGPoint:CGPointMake(150, 32+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 268+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 140+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 268+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 220+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 268+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 250+yOffset)],
						 [NSValue valueWithCGPoint:CGPointMake(150, 268+yOffset)]
						 ];
	
	animation.timingFunctions = @[
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]
								  ];
	
	animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
	// 应用动画
	pView.layer.position = CGPointMake(150, 268+yOffset);
	[pView.layer addAnimation:animation forKey:nil];
}

float interpolate(float from, float to, float time)
{
	return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
	if ([fromValue isKindOfClass:[NSValue class]]) {
		// 获得类型
		const char *type = [fromValue objCType];
		if (strcmp(type, @encode(CGPoint)) == 0) {
			CGPoint from = [fromValue CGPointValue];
			CGPoint to = [toValue CGPointValue];
			CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
			return [NSValue valueWithCGPoint:result];
		}
	}
	// 提供安全的默认值
	return (time < 0.5)? fromValue: toValue;
}

/*
 10.2.4、过程自动化
 之前的例子中，把动画分割成相当大的几块，然后用Core Animation的缓冲进入和缓冲退出函数来大约形成我们想要的曲线。
 但如果把动画分割成更小的几部分，那么就可以用直线来拼接这些曲线（也就是线性缓冲）。
 为了实现自动化，我们需要知道如何做如下两件事情：
 自动把任意属性动画分割成多个关键帧
 用一个数学函数表示弹性动画，使得可以对帧做便宜
 为了解决第一个问题，我们需要复制Core Animation的插值机制。
 这是一个传入起点和终点，然后在这两个点之间指定时间点产出一个新点的机制。对于简单的浮点起始值，公式如下（假设时间从0到1）：
 value = (endValue – startValue) × time + startValue;
 那么如果要插入一个类似于CGPoint，CGColorRef或者CATransform3D这种更加复杂类型的值，我们可以简单地对每个独立的元素应用这个方法（也就CGPoint中的x和y值，CGColorRef中的红，蓝，绿，透明值，或者是CATransform3D中独立矩阵的坐标）。
 同样需要一些逻辑在插值之前对对象拆解值，然后在插值之后在重新封装成对象，也就是说需要实时地检查类型。
 一旦我们可以用代码获取属性动画的起始值之间的任意插值，我们就可以把动画分割成许多独立的关键帧，然后产出一个线性的关键帧动画。
 注意到我们用了60 x 动画时间（秒做单位）作为关键帧的个数，这时因为Core Animation按照每秒60帧去渲染屏幕更新，所以如果我们每秒生成60个关键帧，就可以保证动画足够的平滑（尽管实际上很可能用更少的帧率就可以达到很好的效果）。
 这可以起到作用，但效果并不是很好，到目前为止我们所完成的只是一个非常复杂的方式来使用线性缓冲复制CABasicAnimation的行为。
 这种方式的好处在于我们可以更加精确地控制缓冲，这也意味着我们可以应用一个完全定制的缓冲函数。那么该如何做呢？
 
 缓冲背后的数学并不很简单，但是幸运的是我们不需要一一实现它。罗伯特·彭纳有一个网页关于缓冲函数（http://www.robertpenner.com/easing%EF%BC%89%EF%BC%8C%E5%8C%85%E5%90%AB%E4%BA%86%E5%A4%A7%E5%A4%9A%E6%95%B0%E6%99%AE%E9%81%8D%E7%9A%84%E7%BC%93%E5%86%B2%E5%87%BD%E6%95%B0%E7%9A%84%E5%A4%9A%E7%A7%8D%E7%BC%96%E7%A8%8B%E8%AF%AD%E8%A8%80%E7%9A%84%E5%AE%9E%E7%8E%B0%E7%9A%84%E9%93%BE%E6%8E%A5%EF%BC%8C%E5%8C%85%E6%8B%ACC%E3%80%82
 这里是一个缓冲进入缓冲退出函数的示例（实际上有很多不同的方式去实现它）。
 */

///< 小例子：使用插入的值创建一个关键帧动画
- (void)executeAnimation5:(UIView*)pView
{
	// 重置视图位置
	CGFloat yOffset = self.bgAnimationView.frame.size.height;
	
	pView.center = CGPointMake(150, 32+yOffset);
	// 设置动画参数
	NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32+yOffset)];
	NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268+yOffset)];
	CFTimeInterval duration = 1.0;
	// 生成关键帧
	NSInteger numFrames = duration * 60;
	NSMutableArray *frames = [NSMutableArray array];
	for (int i = 0; i < numFrames; i++) {
		float time = 1 / (float)numFrames * i;
		[frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
	}
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"position";
	animation.duration = 1.0;
	animation.delegate = self;
	animation.values = frames;
	// 应用动画
	[pView.layer addAnimation:animation forKey:nil];
}

///< 这里是一个缓冲进入缓冲退出函数的示例（实际上有很多不同的方式去实现它）。
float quadraticEaseInOut(float t)
{
	return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
}

///< 对我们的弹性球来说，我们可以使用bounceEaseOut函数：
float bounceEaseOut(float t)
{
	if (t < 4/11.0) {
		return (121 * t * t)/16.0;
	} else if (t < 8/11.0) {
		return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
	} else if (t < 9/10.0) {
		return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
	}
	return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

/*
 缓冲背后的数学并不很简单，但是幸运的是我们不需要一一实现它。罗伯特·彭纳有一个网页关于缓冲函数（http://www.robertpenner.com/easing
 
 */
///< 小例子：用关键帧实现自定义的缓冲函数
- (void)executeAnimation6:(UIView*)pView
{
	// reset ball to top of screen
	// 重置视图位置
	CGFloat yOffset = self.bgAnimationView.frame.size.height + 100;
	
	pView.center = CGPointMake(150, 32+yOffset);
	// set up animation parameters
	NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32+yOffset)];
	NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268+yOffset)];
	CFTimeInterval duration = 1.0;
	// generate keyframes
	NSInteger numFrames = duration * 60;
	NSMutableArray *frames = [NSMutableArray array];
	for (int i = 0; i < numFrames; i++) {
		float time = 1/(float)numFrames * i;
		//apply easing
		time = bounceEaseOut(time);
		//add keyframe
		[frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
	}
	// create keyframe animation
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"position";
	animation.duration = 1.0;
	animation.delegate = self;
	animation.values = frames;
	// apply animation
	// 应用动画
	[pView.layer addAnimation:animation forKey:nil];
}

///< 小例子：用关键帧实现自定义的缓冲函数
- (void)executeAnimation7:(UIView*)pView
{
	CGFloat fOffset = 5.0f;
	CGPoint pt = pView.center;
	//pt = [pView frame].origin;
	NSMutableArray *animationValues = [NSMutableArray arrayWithCapacity:5];
	
	NSValue* value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	
	[animationValues addObject:value];
	
	pt.y -= 8;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	pt.y += 14;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	pt.y -= 10;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	pt.y += 4;
	value = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
	[animationValues addObject:value];
	
	// 创建关键帧动画
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
	animation.keyPath = @"position";
	animation.duration = fOffset*5.0f/6;
	animation.delegate = self;
	animation.values = animationValues;
	
	animation.timingFunctions = @[
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut],
								  ];
	
	animation.keyTimes = @[@0.0, @(fOffset*1.0f/6), @(fOffset*23.0f/60), @(fOffset*33.0f/60), @(fOffset*50.0f/60)];
	// 应用动画
	[pView.layer addAnimation:animation forKey:nil];
}

- (CABasicAnimation*)getAnimtionObject:(CGPoint)ptStart withEnd:(CGPoint)ptEnd beginTime:(CGFloat)fTimeStart duration:(CGFloat)duration
{
	CGFloat fOffset = 1.0f;
	
	CABasicAnimation *animationObj = nil;
	///< 动画
	animationObj = [CABasicAnimation animationWithKeyPath:@"animationObj"];
	animationObj.fromValue = [NSValue valueWithCGPoint:ptStart];
	animationObj.toValue = [NSValue valueWithCGPoint:ptEnd];
	
	[animationObj setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[animationObj setRemovedOnCompletion:YES];
	//animationObj.beginTime = fTimeStart;
	animationObj.duration = fOffset*duration;
	
	return animationObj;
}

///< 小例子：用关键帧实现自定义的缓冲函数
- (void)executeAnimation8:(UIView*)pView
{
	CGPoint ptS = pView.center;
	CGPoint ptE = ptS;
	CGFloat t1 = 0.0f;
	CGFloat t2 = 0.0f;
	
	///< 动画1
	ptE.y -= 8/2;
	t1 += t2;
	t2 = 10.0f/60;
	CABasicAnimation *animationObj1 = [self getAnimtionObject:ptS withEnd:ptE beginTime:t1 duration:t2];
	
	///< 动画2
	ptS = ptE;
	ptE.y += 14/2;
	t1 += t2;
	t2 = 13.0f/60;
	CABasicAnimation *animationObj2 = [self getAnimtionObject:ptS withEnd:ptE beginTime:t1 duration:t2];
	
	///< 动画3
	ptS = ptE;
	ptE.y -= 10/2;
	t1 += t2;
	t2 = 10.0f/60;
	CABasicAnimation *animationObj3 = [self getAnimtionObject:ptS withEnd:ptE beginTime:t1 duration:t2];
	
	///< 动画4
	ptS = ptE;
	ptE.y += 4/2;
	t1 += t2;
	t2 = 17.0f/60;
	CABasicAnimation *animationObj4 = [self getAnimtionObject:ptS withEnd:ptE beginTime:t1 duration:t2];
	
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.duration = 5.0f/6;
	group.animations = [NSArray arrayWithObjects:animationObj1, animationObj2, animationObj3, animationObj4, nil];
	group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	group.delegate = self;
	
//	[pView.layer addAnimation:group forKey:@"animations"];
	
	//	pView.enabled = NO;
	[UIView animateWithDuration:10.0f/60 animations:^{
		[pView.layer addAnimation:animationObj1 forKey:@"animations"];
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:13.0f/60 animations:^{
			[pView.layer addAnimation:animationObj2 forKey:@"animations"];
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:10.0f/60 animations:^{
				[pView.layer addAnimation:animationObj3 forKey:@"animations"];
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:17.0f/60 animations:^{
					[pView.layer addAnimation:animationObj4 forKey:@"animations"];
				} completion:^(BOOL finished)
				 {
					 ;
				}];
			}];
		}];
	}];
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

@end


