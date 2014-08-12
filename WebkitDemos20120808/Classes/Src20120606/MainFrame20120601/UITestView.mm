

#import <UIKit/UIKit.h>
#import "UITestView.h"



@interface UITitleLabelView : UILabel

@end
@implementation UITitleLabelView

@end


@implementation UIView (UIVIEW_Private_ForTest)

- (void)addTitleView:(NSString*)title
{
	if (title != nil)
	{
		CGRect selfFrame = [self frame];
		CGRect frame = CGRectZero;
		frame.origin.x = selfFrame.size.width*0.25;
		frame.size.width = selfFrame.size.width*0.5;
		frame.size.height = 30;
		
		UILabel* pTitleView = [[UITitleLabelView alloc] initWithFrame:frame];
		pTitleView.backgroundColor = [UIColor clearColor];
		pTitleView.text = title;
		[self addSubview:pTitleView];
		[pTitleView release];
	}
}


@end
