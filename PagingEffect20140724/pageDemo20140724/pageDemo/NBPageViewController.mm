//
//  NBPageViewController.m
//  pageDemo
//
//  Created by xxx on 27/12/2011.
//  Copyright (c) 2011 none. All rights reserved.
//


#import <CoreText/CoreText.h>
#import "ContentViewController.h"
#import "NBPageViewController.h"


///< 文件和路径
//#define kNBSMNWUnitTestData_PATH                        @"/Library"
#define kNBSMNWUnitTestData_PATH                        @"/Library/Application Support/others"
#define kNBSMNWUnitTestData_SRCPATH                     @"/HardCodeData"
#define kNBSMNWUnitTestData_JSON_FileName               @"/testData.txt"

typedef enum
{
    touchevent_error
	,touchevent_prepage
	,touchevent_menu
	,touchevent_nextpage
}TOUCHEVENT_TYPE;


@interface NBPageViewController()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate,
ContentViewControllerDelegate
>


@property (nonatomic) BOOL bException;  ///< 翻页是否有异常

@property (nonatomic) TOUCHEVENT_TYPE touchType;
@property (nonatomic) CGPoint itemBeginPoint;
@property (nonatomic) BOOL isTurnPage;
@property (nonatomic, assign) double lastTimeTap;
@property (nonatomic) BOOL isMenuShow;

@property (nonatomic, assign)int currentPageIndex; ///< 当前显示页面的索引

@property (nonatomic, retain) NSString* chapterText;
@property (nonatomic, retain) UIFont* fontObj;

@end


@implementation NBPageViewController

+ (NBPageViewController*)createPageViewController
{
	/*
	 UIPageViewControllerTransitionStyle枚举类型定义了如下两个翻转样式。
	 UIPageViewControllerTransitionStylePageCurl：翻书效果样式。
	 UIPageViewControllerTransitionStyleScroll：滑屏效果样式。
	 navigationOrientation设定了翻页方向，UIPageViewControllerNavigationDirection枚举类型定义了以下两种翻页方式。
	 UIPageViewControllerNavigationDirectionForward：从左往右（或从下往上）；
	 UIPageViewControllerNavigationDirectionReverse：从右向左（或从上往下）
	*/
	// style: 0.卷曲; 1.平滑(ios6.0以上才支持)
	// orient: 0.左右卷曲/滑动; 1.上下卷曲/滑动
	UIPageViewControllerTransitionStyle style[2] = {UIPageViewControllerTransitionStylePageCurl, UIPageViewControllerTransitionStyleScroll};
	UIPageViewControllerNavigationOrientation orient[2] = {UIPageViewControllerNavigationOrientationHorizontal, UIPageViewControllerNavigationOrientationVertical};
	
    return [[[NBPageViewController alloc] initWithTransitionStyle:style[0]
														   navigationOrientation:orient[0]
																		 options:nil] autorelease];
}

- (void)dealloc
{
	self.chapterText = nil;
	self.fontObj = nil;
	
	[super dealloc];
}

#pragma mark - == 加载测试数据
- (NSString*)getUnitTestDataPath
{
	NSString* folderPath = [NSHomeDirectory() stringByAppendingString:kNBSMNWUnitTestData_PATH];
    NSString* plistPath = [NSString stringWithFormat:@"%@%@", folderPath, kNBSMNWUnitTestData_JSON_FileName];
	
	[[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
	// 删除
	[[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		// 如果配置文件不存在, 从资源目录下复制一份
		NSString* srcPlist = [NSString stringWithFormat:@"%@%@%@", [[NSBundle mainBundle] bundlePath], kNBSMNWUnitTestData_SRCPATH, kNBSMNWUnitTestData_JSON_FileName];
		[[NSFileManager defaultManager] copyItemAtPath:srcPlist toPath:plistPath error:nil];
	}
	
	NSString* fullPath = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		fullPath = plistPath;
	}
	
	return fullPath;
}

- (NSString*)getTestDataContent
{
	NSString* testData = nil;
	NSString* filePath = [self getUnitTestDataPath];
	
	if ([filePath length] > 0)
	{
		NSData* data = [NSData dataWithContentsOfFile:filePath];
		
        testData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	}
	
	return testData;
}

#pragma mark -== View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.isTurnPage = YES;
	self.chapterText = [self getTestDataContent];
	
	///< 添加字体
	[self getFontFilePath];
	
	self.fontObj = [self loadCustomFont];
	
	[self addFirstPage];
}

- (void)addFirstPage
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.delegate = self;
    self.dataSource = self;
	
	_currentPageIndex = 0;
	
    UIViewController *startCtrl = nil;
    UIViewController *secondCtrl = nil;
	startCtrl = [self getCurrentPageViewController:0 with:NO]; ///< 初始化当前UIViewController
	secondCtrl = [self getCurrentPageViewController:1 with:NO];
	
    NSArray *viewControllers = nil;
	viewControllers = [NSArray arrayWithObject:startCtrl];
	//viewControllers = [NSArray arrayWithObjects:startCtrl, secondCtrl, nil];
	
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
}

// 屏幕即将旋转 layoutSubviews执行之前发生
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	NSArray *viewControllers = nil;
	viewControllers = [self viewControllers];
	for (ContentViewController* ctrl in viewControllers)
	{
		ctrl.textViewObj.frame = [self getPageViewBounds:self.spineLocation];
		ctrl.labelObj.frame = [self getPageViewBounds:self.spineLocation];
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	
}

// 屏幕旋转完毕
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSArray *viewControllers = nil;
	viewControllers = [self viewControllers];
	for (ContentViewController* ctrl in viewControllers)
	{
		ctrl.textViewObj.frame = [self getPageViewBounds:self.spineLocation];
		ctrl.labelObj.frame = [self getPageViewBounds:self.spineLocation];
	}
}


///< 翻到下一页
- (UIViewController *)turnToNextPage
{
    UIViewController* nextViewController = nil;;
	_currentPageIndex++;
	if (_currentPageIndex > 13)
	{
		_currentPageIndex = 0;
	}
	else
	{
		nextViewController = [self getCurrentPageViewController:_currentPageIndex with:NO];
	}
	
	return nextViewController;
}

///< 翻到上一页
- (UIViewController *)turnToPreviousPage
{
	UIViewController* preViewController = nil;
	
	_currentPageIndex--;
	if (_currentPageIndex < 0)
	{
		_currentPageIndex = 0;
	}
	else
	{
		preViewController = [self getCurrentPageViewController:_currentPageIndex with:YES];
	}
	return preViewController;
}

- (NSString*)getCurChapterText:(int)index with:(BOOL)isBackPage
{
	int nTextLen = [self.chapterText length];
	int nOffset = nTextLen/14;
	
	NSRange rangeText = NSMakeRange(index*nOffset, nOffset);
	NSString* text = [_chapterText substringWithRange:rangeText];
	if (isBackPage)
	{
		text = [NSString stringWithFormat:@"第%d章  %@【背面】\n\n%@", index+1, [text substringToIndex:10], text];
	}
	else
	{
		text = [NSString stringWithFormat:@"第%d章  %@【正面】\n\n%@", index+1, [text substringToIndex:10], text];
	}
	
	return text;
}

- (CGRect)getPageViewBounds:(UIPageViewControllerSpineLocation)spineLocation
{
	CGRect rect = CGRectMake(0, 50, 300, 30);
	rect = [self.view bounds];
	rect.origin.y = 20;
	rect.size.height -= rect.origin.y;
	if (spineLocation == UIPageViewControllerSpineLocationMid)
	{
		rect.size.width *=0.5f;
	}
	
	return rect;
}

- (UIViewController *)getCurrentPageViewController:(int)index with:(BOOL)isBackPage
{
	UIColor* bgColor[14] =
	{
		[UIColor blueColor],
		[UIColor darkGrayColor],
		[UIColor lightGrayColor],
		[UIColor whiteColor],
		[UIColor grayColor],
		
		[UIColor redColor],
		[UIColor greenColor],
		[UIColor blueColor],
		[UIColor cyanColor],
		[UIColor yellowColor],
		
		[UIColor magentaColor],
		[UIColor orangeColor],
		[UIColor purpleColor],
		[UIColor brownColor]
	};
	
	
    ContentViewController *viewCtrl = [[[ContentViewController alloc] init] autorelease];
	viewCtrl.isBackPage = YES;
	
	CGRect rect = [self getPageViewBounds:self.spineLocation];
	
//	UITextView* viewObj = [[UITextView alloc] initWithFrame:rect];
//	viewObj.editable = NO;
//	viewCtrl.textViewObj = viewObj;
	
	UILabel* viewObj = [[UILabel alloc] initWithFrame:rect];
	viewCtrl.labelObj = viewObj;
	viewObj.textAlignment = NSTextAlignmentLeft;
	viewObj.numberOfLines = 0;
	
	viewObj.backgroundColor = [UIColor grayColor];
	viewObj.text = [self getCurChapterText:index with:isBackPage];
	
	//[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]
	viewObj.font = [UIFont systemFontOfSize:17];  ///< 系统字体
	//viewObj.font = [UIFont fontWithName:@"Jxixinkai" size:25]; ///< 自字义字体
	//viewObj.font = [UIFont fontWithName:@"SingKaiEG-Bold-GB" size:25]; ///< 自字义字体
	viewObj.font = self.fontObj;
	
	viewObj.userInteractionEnabled = NO;
	//textViewObj.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
	
	[viewCtrl.view addSubview:viewObj];
	[viewObj release];
	
	viewCtrl.view.backgroundColor = bgColor[index];
	viewCtrl.delegate = self;
	
    return viewCtrl;
}

- (void)printfFonts
{
	NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
	NSString* fontName = @"Helvetica";
	for (NSString* nameItem in familyNames)
	{
		NSLog(@" Font name: %@", nameItem);
		if ([nameItem isEqualToString:@"恅隋棉俴翱潠翷"])
		{
			fontName = nameItem;
			//break;
		}
		else if ([nameItem isEqualToString:@"迷你简细行楷"])
		{
			fontName = nameItem;
			//break;
		}
		else
		{
			fontName = nameItem;
		}
		
		NSArray* fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:fontName]];
		
		int indFont = 0;
		for(indFont=0; indFont<[fontNames count]; ++indFont)
		{
			NSLog(@" Font name: %@",[fontNames objectAtIndex:indFont]);
		}
	}
}

- (UIFont*)loadCustomFont
{
	static UIFont* fontObj = nil;
	
	fontObj = [self dynamicLoadFont2];
	if (fontObj == nil)
	{
		//fontObj = [self dynamicLoadFont];
	}
	if (fontObj == nil)
	{
		fontObj = [UIFont systemFontOfSize:17];  ///< 系统字体;
	}
	
	return fontObj;
}

-  (NSString*)getFontFilePath2
{
	NSString* filePath = [NSString stringWithFormat:@"%@/Documents/huawenxingkai.ttf", NSHomeDirectory()];
	//filePath = [NSString stringWithFormat:@"%@/Documents/STxingkai_Normal.ttf", NSHomeDirectory()];
	
	BOOL bExist = NO;
	bExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (bExist != YES)
	{
		//		[self printfFonts];
		filePath = nil;
	}
	
	return filePath;
}

- (UIFont*)dynamicLoadFont2
{
	UIFont* fontObj = nil;
    
    //加载字体
    CFErrorRef error;
	NSString *fontPath = [self getFontFilePath2]; // a TTF file in iPhone Documents folder //字体文件所在路径
	if ([fontPath length] < 1)
	{
		return fontObj;
	}
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
	CGFontRef customFont = CGFontCreateWithDataProvider(fontDataProvider);
	
	bool bRegister = CTFontManagerRegisterGraphicsFont(customFont, &error);
	
    if (!bRegister)
    {
		//如果注册失败，则不使用
		CFStringRef errorDescription = CFErrorCopyDescription(error);
		NSLog(@"Failed to load font: %@", errorDescription);
		CFRelease(errorDescription);
    }
    //else
	{
		//字体名
		NSString *fontName = (__bridge NSString *)CGFontCopyFullName(customFont);
		NSLog(@"fontName=%@", fontName);
		fontObj = [UIFont fontWithName:fontName size:25];
	}
	
    CFRelease(customFont);
	CGDataProviderRelease(fontDataProvider);
	
	return fontObj;
}

//#pragma mark - UIPageViewControllerDataSource
///< 方法用于设定首页中显示的视图
- (void)setViewControllers:(NSArray *)viewControllers direction:(UIPageViewControllerNavigationDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [super setViewControllers:viewControllers direction:direction animated:animated completion:completion];
}

#pragma mark- ==UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
	if (_touchType == touchevent_prepage)
	{
		_bException = YES;
		NSLog(@"[gestureRecognizers]=%@", [pageViewController gestureRecognizers]);
		NSLog(@"异常消息，cur=%d, After ==", _currentPageIndex);
		return nil;
	}
	if (_bException)
	{
		return nil;
	}
	
	ContentViewController *newViewController =nil;
	
    ContentViewController* curViewController = (ContentViewController*)viewController;
	if (curViewController.isBackPage)
	{
		newViewController = (ContentViewController*)[self getCurrentPageViewController:_currentPageIndex with:YES];
		newViewController.isBackPage = NO;
		newViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
		NSLog(@"背面，cur=%d, After viewController = %@", _currentPageIndex, viewController);
		//[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
	else
	{
		newViewController = (ContentViewController*)[self turnToNextPage];
		NSLog(@"正面，cur=%d, After viewController = %@", _currentPageIndex, viewController);
	}
    
	return newViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController 
      viewControllerBeforeViewController:(UIViewController *)viewController
{
	if (_touchType == touchevent_nextpage)
	{
		_bException = YES;
		NSLog(@"[gestureRecognizers]=%@", [pageViewController gestureRecognizers]);
		NSLog(@"异常消息，cur=%d, Before ==", _currentPageIndex);
		return nil;
	}
	
	if (_bException)
	{
		return nil;
	}
	ContentViewController *newViewController =nil;
	
    ContentViewController* curViewController = (ContentViewController*)viewController;
	if (curViewController.isBackPage)
	{
		newViewController = (ContentViewController*)[self turnToPreviousPage];
		newViewController.isBackPage = NO;
		newViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
		
		NSLog(@"背面，cur=%d, Before viewController = %@", _currentPageIndex, viewController);
		//[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
	else
	{
		newViewController = (ContentViewController*)[self getCurrentPageViewController:_currentPageIndex with:NO];
		
		NSLog(@"正面，cur=%d, Before viewController = %@", _currentPageIndex, viewController);
	}
    
	return newViewController;
}

#pragma mark- UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
	NSLog(@"===翻页动画 【开始】====");
	//[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

///< 翻页动画完成
- (void)didFinishAnimatingPagingViewController
{
	_bException = NO;
}

- (void)pageViewController:(UIPageViewController*)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray*)previousViewControllers transitionCompleted:(BOOL)completed
{
	NSLog(@"===翻页动画==completed==%d=", completed);
	if (completed)
	{
		//NSLog(@"===翻页动画结束====");
		[self didFinishAnimatingPagingViewController];
	}
	//[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

///< 由于spineLocation属性是只读的，所以只能在这个方法中设置书脊位置，该方法可以根据屏幕旋转方向的不同来动态设定书脊的位置
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController 
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    NSArray *viewControllers = nil;
    
    UIPageViewControllerSpineLocation spine = UIPageViewControllerSpineLocationMin;
	
	UIViewController* curViewController = [self getCurrentPageViewController:_currentPageIndex with:NO];
	
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
	{
		//取出第一个视图控制器，作为PageViewController首页
		UIViewController* nextViewController = [self getCurrentPageViewController:_currentPageIndex+1 with:NO];
		viewControllers = @[curViewController, nextViewController]; // 代码NSArray *viewControllers = @[page1ViewController]相当于NSArray *viewControllers = [NSArray arrayWithObject: page1ViewController , nil]。
		
		spine = UIPageViewControllerSpineLocationMid;
		
		nextViewController.view.Frame = [self getPageViewBounds:spine];
	}
	else
	{
		//取出第一个视图控制器，作为PageViewController首页
		viewControllers = @[curViewController];
		spine = UIPageViewControllerSpineLocationMin;
	}
	curViewController.view.Frame = [self getPageViewBounds:spine];
	
	[self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
	
	// 1.双面显示，是在页面翻起的时候，偶数页面会在背面显示。图6-13右图为doubleSided设置为YES情况，图为 doubleSided设置为NO（单面显示），单面显示在页面翻起的时候，能够看到页面的背面，背面的内容是当前页面透过去的，与当前内容是相反的镜像。
	self.doubleSided = YES;
	
	return spine;
}


#pragma mark - ==tap点击时的上下翻页
- (void)goToPrePageView
{
	UIViewController* currentViewController = nil;
	//currentViewController = [self getCurrentPageViewController:_currentPageIndex];
	
	_currentPageIndex--;
	if (_currentPageIndex < 0)
	{
		_currentPageIndex = 0;
	}
	else
	{
		currentViewController = [self getCurrentPageViewController:_currentPageIndex with:NO];
		currentViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
		
		UIViewController* preViewController = nil;
		preViewController = [self getCurrentPageViewController:_currentPageIndex with:YES];
		
		[self goToPrePageViewController:preViewController backViewController:currentViewController];
	}
}

- (void)goToNextPageView
{
	UIViewController* currentViewController = nil;
//	currentViewController = [self getCurrentPageViewController:_currentPageIndex];
	currentViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
	
	_currentPageIndex++;
	if (_currentPageIndex > 13)
	{
		_currentPageIndex = 0;
	}
	else
	{
		currentViewController = [self getCurrentPageViewController:_currentPageIndex with:YES];
		currentViewController.view.transform = CGAffineTransformMakeScale(-1, 1);
		
		UIViewController* nextViewController = nil;
		nextViewController = [self getCurrentPageViewController:_currentPageIndex with:NO];
		[self goToNextPageViewController:currentViewController nextViewController:nextViewController];
	}
}

- (void)goToPrePageViewController:(UIViewController*)preViewController backViewController:(UIViewController*)backViewController
{
    if (preViewController == nil || backViewController == nil)
    {
        return;
    }
	
    NSArray *viewControllers = nil;
//	viewControllers = [NSArray arrayWithObject:preViewController];
	viewControllers = [NSArray arrayWithObjects:preViewController, backViewController, nil];
    
    [self setViewControllers:viewControllers
				   direction:UIPageViewControllerNavigationDirectionReverse
					animated:YES
				  completion:NULL];
}

- (void)goToNextPageViewController:(UIViewController*)currentViewController nextViewController:(UIViewController*)nextViewController
{
    if (currentViewController == nil || nextViewController == nil)
    {
        return;
    }
    
    NSArray *viewControllers = nil;
//	viewControllers = [NSArray arrayWithObject:nextViewController];
	viewControllers = [NSArray arrayWithObjects:nextViewController, currentViewController, nil];
	[self setViewControllers:viewControllers
	 			   direction:UIPageViewControllerNavigationDirectionForward
					animated:YES
				  completion:NULL];
}

- (BOOL)touchedMenuRect:(CGPoint)point
{
    CGRect rect = self.view.bounds;
    CGRect menuRect = CGRectMake(rect.size.width / 5, rect.size.height / 3, rect.size.width * 3 / 5, rect.size.height / 3);
    
    return CGRectContainsPoint(menuRect, point);
}

- (BOOL)touchedNextRect:(CGPoint)point
{
    CGRect rect = self.view.bounds;
    CGRect nextRightRect = CGRectMake(rect.size.width * 4 / 5, 0, rect.size.width / 5, rect.size.height * 2 / 3);
    CGRect nextBottomRect = CGRectMake(rect.size.width / 5, rect.size.height * 2 / 3, rect.size.width * 4 / 5, rect.size.height / 3);
    
    return CGRectContainsPoint(nextRightRect, point) || CGRectContainsPoint(nextBottomRect, point);
}

- (BOOL)touchedPrevRect:(CGPoint)point
{
    CGRect rect = self.view.bounds;
    CGRect preLeftRect = CGRectMake(0, rect.size.height / 3, rect.size.width / 5, rect.size.height * 2 / 3);
    CGRect preTopRect = CGRectMake(0, 0, rect.size.width * 4 / 5, rect.size.height / 3);
    
    return CGRectContainsPoint(preLeftRect, point) || CGRectContainsPoint(preTopRect, point);
}

- (TOUCHEVENT_TYPE)touchTypeWithPoint:(CGPoint)point
{
    TOUCHEVENT_TYPE type = touchevent_error;
    if ([self touchedMenuRect:point])
    {
        type = touchevent_menu;
    }
    else if ([self touchedNextRect:point])
    {
        type = touchevent_nextpage;
    }
    else if ([self touchedPrevRect:point])
    {
        type = touchevent_prepage;
    }
    
    return type;
}

- (BOOL)isIgnoreTouchEvent
{
    BOOL ignore = NO;
    double time = [[NSDate date] timeIntervalSince1970];
    if (time - _lastTimeTap >= 0.2)
    {
        _lastTimeTap = time;
    }
    else
    {
        ignore = YES;
    }
    
    return ignore;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
	if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        CGPoint pointOne = [touch locationInView:self.view];
        self.touchType = [self touchTypeWithPoint:pointOne];
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    BOOL shouldBegin = YES;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        if (!_isTurnPage)
        {
            shouldBegin = NO;
        }
        else
        {
//            if (![_nbDelegate isUseInteractionEnable])
//            {
//                shouldBegin = NO;
//            }
//            else
            {
                if (fabsf(point.y - _itemBeginPoint.y) / fabsf(point.x - _itemBeginPoint.x) > 1.5)
                {
                    [self lockGesture];
                    shouldBegin = NO;
                }
                else
                {
                    if (_isMenuShow)
                    {
                        //[_nbDelegate hideMenu];
                        _isMenuShow = NO;
                        shouldBegin = NO;
                    }
                    else
                    {
                        shouldBegin = [self isIgnoreTouchEvent] ? NO :YES;
                    }
                }
            }
        }
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (!_isTurnPage)
        {
            shouldBegin = NO;
        }
        else
        {
            if (self.touchType == touchevent_menu
				//|| ![_nbDelegate isUseInteractionEnable]
				)
            {
                if (_isMenuShow)
                {
                    //[_nbDelegate hideMenu];
                    _isMenuShow = NO;
                }
                else
                {
                    //[_nbDelegate showMenu];
                    _isMenuShow = YES;
                }
            }
            else
            {
                if (_isMenuShow)
                {
                    //[_nbDelegate hideMenu];
                    _isMenuShow = NO;
                }
                else
                {
                    if (self.touchType == touchevent_nextpage)
                    {
                        if (![self isIgnoreTouchEvent])
                        {
                            [self goToNextPageView];
                        }
                    }
                    else if (self.touchType == touchevent_prepage)
                    {
                        if (![self isIgnoreTouchEvent])
                        {
                            [self goToPrePageView];
                        }
                    }
                }
            }
            
            shouldBegin = NO;
        }
    }
    
    return shouldBegin;
}

#pragma mark - ContentViewControllerDelegate
- (void)beginTouch:(CGPoint)begin
{
    self.itemBeginPoint = begin;
	_bException = NO;
}

- (void)lockGesture
{
    self.isTurnPage = NO;
}

- (BOOL)isLocked
{
    return !self.isTurnPage;
}

- (void)releaseGesture
{
    self.isTurnPage = YES;
}



@end
