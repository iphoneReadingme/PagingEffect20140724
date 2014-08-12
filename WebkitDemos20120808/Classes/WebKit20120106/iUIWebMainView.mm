//
//  iUIMediaRootView.mm
//  YFS_Sim111027_i42
//
//  Created by yangfs on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "iUIWebKitMacroDefine.h"

#import "iUIWebMainView.h"


// =================================================================
#pragma mark -
#pragma mark 实现iUIWebMainView

@implementation iUIWebMainView


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Initialization code.
		//self.backgroundColor = [UIColor blueColor];
		self.backgroundColor = [UIColor brownColor];
		self.layer.borderWidth = 4;
		self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.99 blue:1.0 alpha:1.0].CGColor;
		//CGRect selfFrame = [self frame];
		int i=0;
		i=0;
		
		// 获取颜色值
		UIColor *uicolor = [UIColor redColor];
		CGColorRef color = [uicolor CGColor];
		int numComponents = CGColorGetNumberOfComponents(color);
		if (numComponents >= 3)
		{
			const CGFloat *tmComponents = CGColorGetComponents(color);
//			CGFloat red = tmComponents[0];
//			CGFloat green = tmComponents[1];
//			CGFloat blue = tmComponents[2];
			CGFloat alpha = tmComponents[3];
			alpha = 0;
		}
	}
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
	//[self releaseObject];
	[super dealloc];
}

//=====================================================================
-(void)releaseObject
{
	
}

-(void)addViews
{
}

// =================================================================
#pragma mark -
#pragma mark 
- (void)drawRect:(CGRect)rect
{
	CGRect selfFrame = [self frame];
	selfFrame.origin.x = kBorderLineWidth*0.5;
	selfFrame.origin.y = kBorderLineWidth*0.5;
	selfFrame.size.width -= kBorderLineWidth;
	selfFrame.size.height -= kBorderLineWidth;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Drawing code
	// Drawing with a white stroke color
	CGContextSetRGBStrokeColor(context, 1.0, 0, 1, 1.0);
	// And draw with a blue fill color
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, kBorderLineWidth);
	
	// Add an ellipse circumscribed in the given rect to the current path, then stroke it
	CGContextAddRect(context, selfFrame);
	CGContextStrokePath(context);
	
	CGContextAddRect(context, selfFrame);
	CGContextFillPath(context);
}

@end

// =================================================================
#pragma mark -
#pragma mark 文件尾

