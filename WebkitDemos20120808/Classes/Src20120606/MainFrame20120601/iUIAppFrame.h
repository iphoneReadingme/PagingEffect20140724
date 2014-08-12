


@interface iUIAppFrame : NSObject
{
	
}

+ (iUIAppFrame*)shareInstance;

- (int)getCmdBarHeight;
- (UIInterfaceOrientation)getCurInterfaceOrientation;
- (void)hiddenSystemStatusBarOnFullScreen:(BOOL)bHidden;

@end

