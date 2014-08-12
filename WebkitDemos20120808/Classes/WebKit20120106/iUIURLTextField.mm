//
//  iUIMediaRootView.mm
//  YFS_Sim111027_i42
//
//  Created by yangfs on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iUIWebKitMacroDefine.h"
#import "iUIURLTextField.h"
#import "iUIWebViewManager.h"



// =================================================================
#pragma mark -
#pragma mark 实现iUIURLTextField

@implementation iUIURLTextField


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Initialization code.
		//[self addViews];
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
	[self releaseObject];
    [super dealloc];
}

//=====================================================================
-(void)releaseObject
{
}

-(void)addViews
{
	//CGRect selfFrame = [self frame];
	self.backgroundColor = [UIColor blueColor];
	self.layer.borderWidth = 2;
	self.layer.borderColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.0 alpha:1.0].CGColor;
	//[self createButtons];
}

// =================================================================
#pragma mark -
#pragma mark URL输入框
//- (void)addURLTextField:(CGRect)frame
//{
//}


// =================================================================
#pragma mark -
#pragma mark 

// =================================================================
#pragma mark -
#pragma mark 手势相关




// =================================================================
#pragma mark -
#pragma mark - UITextFieldDelegate

//added by huangrk 2011-5-30
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	// became first responder
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//{
//	// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
	//[self onURLEditerChange:@""];
	self.text = @"";
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (![textField canResignFirstResponder])
	{
		return NO;
	}
	NSString* url = textField.text;
	url = nil;
	return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//	// return NO to not change text
//}

// =================================================================
#pragma mark -
#pragma mark 


@end

// =================================================================
#pragma mark -
#pragma mark 文件尾

