//
//  GestureViewController.m
//  KIF
//
//  Created by Brian Nickel on 7/28/13.
//
//

#import <UIKit/UIKit.h>

@interface GestureViewController : UIViewController
@property (nonatomic) IBOutlet UILabel *lastSwipeDescriptionLabel;
@property (nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GestureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGRectUnion(self.scrollView.bounds, self.bottomRightLabel.frame).size;
}

- (IBAction)swipedUp:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Up";
}

- (IBAction)swipedDown:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Down";
}

- (IBAction)swipedLeft:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Left";
}

- (IBAction)swipedRight:(id)sender
{
    self.lastSwipeDescriptionLabel.text = @"Right";
}


@end
