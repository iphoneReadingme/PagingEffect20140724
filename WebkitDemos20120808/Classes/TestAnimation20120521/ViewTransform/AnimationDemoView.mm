
#import <UIKit/UIKit.h>
#import "AnimationDemoView.h"
#import "AnimationMacroDefine.h"


#define kIconViewShowing   @""
#define kIconViewHideing   @""

///< 私有方法
@interface AnimationDemoView (AnimationDemoView_Private)

- (void)forTest:(UIView*)pView;
- (void)releaseObject;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void)setTimer;
- (void)killTimer;
- (void)OnTimeOut;

- (void)executeAnimation:(bool)bAnimation;
- (void)addBgView:(CGRect)frame;

@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation AnimationDemoView


- (void)forTest:(UIView*)pView
{
	// for test
	pView.backgroundColor = [UIColor brownColor];
	pView.layer.borderWidth = 4;
	pView.layer.borderColor = [UIColor colorWithRed:1.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		[self forTest:self];
		self.backgroundColor = [UIColor clearColor];
		[self addBgView:frame];
		[self setTimer];
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
    [m_pImgView release];
	m_pImgView = nil;
	
	[self killTimer];
}

- (void)addBgView:(CGRect)frame
{
	UIImage* pImage = [UIImage imageNamed:@"images/ucappstore_doubanfm.png"];
	CGSize imgSize = [pImage size];
	frame.origin.x = (frame.size.width - imgSize.width)*0.5f;
	frame.origin.y = (frame.size.height - imgSize.height)*0.5f;
	frame.size = imgSize;
	
	m_pImgView = [[UIImageView alloc] initWithFrame:frame];
	m_pImgView.image = pImage;
	[self forTest:m_pImgView];
	[self addSubview:m_pImgView];
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
#pragma mark-
#pragma mark 通过定时方法隐藏icon对象

- (void)killTimer
{
	[m_timer invalidate];
	m_timer = nil;
}

- (void)OnTimeOut
{
	[self executeAnimation:true];
	
	// increase timer interval to save cpu use rate
	m_fAngle += 0.01f;
	if (m_fAngle > 6.2857)
	{
		m_fAngle = 0.0f;
	}
}

- (void)setTimer
{
	m_fInterval = 1.0f/24.0f;
	m_fAngle = 0.0f;
	
	[self killTimer];
	m_timer = [NSTimer scheduledTimerWithTimeInterval:m_fInterval target:self
											 selector:@selector(OnTimeOut) userInfo:nil repeats:YES];
}


// =================================================================
#pragma mark-
#pragma mark 执行动画
- (void)executeAnimation:(bool)bAnimation
{
	CGRect frame = [[self superview] frame];
	CGRect rect = [self frame];
	rect.origin.y = frame.size.height;
	
    if (bAnimation)
    {
        [UIView beginAnimations:kIconViewShowing context:NULL];;
        [UIView setAnimationCurve: UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.2f];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
		//[self setFrame:rect];
		m_pImgView.transform = CGAffineTransformMakeRotation(m_fAngle);
		//m_pImgView.transform = CGAffineTransformMakeRotation(m_fAngle);
        
        [UIView commitAnimations];
    }
    else
    {
		[self setFrame:rect];
    }
    
}

@end


