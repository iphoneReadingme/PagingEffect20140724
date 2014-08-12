
#import <UIKit/UIKit.h>
#import "AnimationDemoView.h"
#import "AnimationMacroDefine.h"


#define kIconViewShowing   @""
#define kIconViewHideing   @""

///< 私有方法
@interface AnimationDemoView (AnimationDemoView_Private)

- (void)forTest;
- (void)releaseObject;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;


@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation AnimationDemoView


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
		[self addBgView:frame];
		
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
}

- (void)addBgView:(CGRect)frame
{
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



@end


