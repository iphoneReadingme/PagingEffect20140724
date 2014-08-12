
#import "iUCCommon.h"
#import "iUIWebKitMacroDefine.h"
#import "iUIWebView.h"
#import "iUIWebViewJavaScript.h"
#import "UCWebkitActionSheet.h"



// =================================================================
@implementation UIWebView (UIWebView_JavaScript)


// =================================================================
#pragma mark -
#pragma mark 页面截图

// 页面截图
- (void)pageSnapshot
{
	UIView* pImageView = nil;
	UIScrollView *theScrollView = (UIScrollView *)[self findWebViewScrollView:self];
	//theScrollView.showsHorizontalScrollIndicator = YES;
	//theScrollView.showsVerticalScrollIndicator = YES;

	UIView* pDocumentView = [self findWebViewDocumentView:self];
	
	pImageView = pDocumentView;
	CGRect frame = [pImageView frame];
	WKMD_LOG_NSLOG(@"theScrollView=%@", theScrollView);
	CGSize pageSize=CGSizeMake(1024,1100);
	pageSize = frame.size;
	
	UIGraphicsBeginImageContext(pageSize);
	[pImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *imageData = UIImagePNGRepresentation(viewImage);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	WKMD_LOG_NSLOG(@"documentsDirectory=%@", documentsDirectory);
	NSString *pathFloder = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",@"new.png"]];
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:pathFloder];
	[imageData writeToFile:defaultDBPath atomically:YES];
	
	if(nil != imageData)
	{
		UIImage* dataImage = [[UIImage alloc] initWithData:imageData];
		if(dataImage)
		{
			UIImageWriteToSavedPhotosAlbum( dataImage,nil,nil,nil);
		}
		[dataImage release];
	}
}

-(void)dumpSubViewClass:(UIView*)view
{
	NSString *desc = [view description];
	NSLog(@"class name[%s] description[%@]", object_getClassName(view), desc);
	
	int count = [view.subviews count];
	NSLog(@"Subview begin");
	for (NSUInteger i = 0; i < count; i++)
	{
		UIView *subView = [view.subviews objectAtIndex:i];
		[self dumpSubViewClass:subView];
	}
	NSLog(@"Subview end");
}

//anthzhu adds iuiAdressbar on iwebview at 2010-09-02.
- (UIView*)findWebViewScrollView:(UIView*)view
{
	if ([self respondsToSelector:@selector(scrollView)])
	{
		return [(UIWebView*)view scrollView];
	}
	Class cl = [view class];
	NSString *desc = [cl description];
	//NSLog(@"class name[%s] description[%@]", object_getClassName(view), desc);
	if (([desc compare:@"UIScroller"] == NSOrderedSame) || ([desc compare:@"UIScrollView"] == NSOrderedSame))
	{
	    return view;
	}
	
	for (NSUInteger i = 0; i < [view.subviews count]; i++)
	{
		UIView *subView = [view.subviews objectAtIndex:i];
		subView = [self findWebViewScrollView:subView];
		if (subView)
		{
			
			return subView;
		}
	}
	
	return nil;
}

//anthzhu adds iuiAdressbar on iwebview at 2010-09-02.
- (UIView*)findWebViewDocumentView:(UIView*)view
{
	//[self dumpSubViewClass: view];
	Class cl = [view class];
	NSString *desc = [cl description];
	if (([desc compare:@"UIWebDocumentView"] == NSOrderedSame) || ([desc compare:@"UIWebBrowserView"] == NSOrderedSame))
	{
	    return view;
	}
	
	for (NSUInteger i = 0; i < [view.subviews count]; i++)
	{
		UIView *subView = [view.subviews objectAtIndex:i];
		subView = [self findWebViewDocumentView:subView];
		if (subView)
		{
			
			return subView;
		}
	}
	
	return nil;
}


// =================================================================
#pragma mark -
#pragma mark  添加长按手势

- (void)addLongPressGestureRecognizer
{
	{
		[self stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
		[self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = 'none'"];
//		[self stringByEvaluatingJavaScriptFromString: \
//		 @" \
//		 function stopCall() { \
//		 document.documentElement.style.webkitTouchCallout = \"none\"; \
//		 } \
//		 window.onload = stopCall; "];
	}
	//[self removeLongPressGestureRecognizer:self];
	// 添加长按手势
	UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
	if ([longPressGestureRecognizer respondsToSelector:@selector(locationInView:)])
	{
		//longPressGestureRecognizer.minimumPressDuration = 0.3;
		//longPressGestureRecognizer.numberOfTapsRequired = 1; //单击
		//longPressGestureRecognizer.allowableMovement = 1; //移动多远手势实效
		longPressGestureRecognizer.delegate = (id)self;
		longPressGestureRecognizer.cancelsTouchesInView = NO;
		//[m_webView addGestureRecognizer:longPressGestureRecognizer];
		[self addGestureRecognizer:longPressGestureRecognizer];
	}
	[longPressGestureRecognizer release];
	longPressGestureRecognizer = nil;
}

// =================================================================
#pragma mark -
#pragma mark  长按手势识别处理
- (void)openContextualMenuAt:(CGPoint)pt
{
	//[ self handleGesture];
	//[self showClassMethod];
	UIWebView* m_webView = self;
	NSString* pCurAppPath = [[NSBundle mainBundle] bundlePath];
	NSString* path = [pCurAppPath stringByAppendingPathComponent:@"UCJavaScript.js"];
	BOOL bExist = NO;
	bExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if (bExist == NO)
	{
		WKMD_LOG_NSAssert(false, @"======UCJavaScript.js no find!===");
		WKMD_LOG_NSAssert1(false, @"==path : %@",path);
		return;
	}
	
	NSString *jsHrefCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	[m_webView stringByEvaluatingJavaScriptFromString: jsHrefCode];
	// get the Tags at the touch location
	NSString * tags = nil;
	tags = [m_webView stringByEvaluatingJavaScriptFromString:
			[NSString stringWithFormat:@"UCWEBAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
	
	NSString *tagsHREF = [m_webView stringByEvaluatingJavaScriptFromString:
						  [NSString stringWithFormat:@"UCWEBAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
	
	WKMD_LOG_NSLOG(@"tags=][%@]",tags);
	WKMD_LOG_NSLOG(@"tagsHREF : %@",tagsHREF);
	NSString *tagsHREFTest = [m_webView stringByEvaluatingJavaScriptFromString:
						  [NSString stringWithFormat:@"TestUCWEBAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
	
	WKMD_LOG_NSLOG(@"TesttagsHREFTest : %@",tagsHREFTest);
	NSString *tagsGetLinkAtPoint = [m_webView stringByEvaluatingJavaScriptFromString:
							  [NSString stringWithFormat:@"UCWEBAppGetLinkAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
	
	WKMD_LOG_NSLOG(@"tagsGetLinkAtPoint : %@",tagsGetLinkAtPoint);
	
	
	//NSString *tagsSRC = [m_webView stringByEvaluatingJavaScriptFromString:
	//					 [NSString stringWithFormat:@"UCWEBAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
	//WKMD_LOG_NSLOG(@"tagsSRC : %@", tagsSRC);
	
	NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"■"];
	NSString* strTrimmingTags = [tags stringByTrimmingCharactersInSet:characterSet];
	NSArray* array = [strTrimmingTags componentsSeparatedByString:@"■"];
	
	NSString* strTagName = @"";
	NSString* pHrefURL = nil;
	NSString* pImgSrcURL = nil;
	
	if([array count] >= 1)
	{
		strTagName = [(NSString*)[array objectAtIndex:0] uppercaseString];
		WKMD_LOG_NSLOG(@"tags : %@",tags);
		bool bShowMenu = false;
		//if ([strTagName isEqualToString:@"IMG"] || [strTagName isEqualToString:@"A"])
		if ([strTagName isEqualToString:@"A"] )
		{
			// 有时得到的"A"标签href是一个javascript:void(0), 此时不显示菜单
			pHrefURL = (NSString*)[array objectAtIndex:1];
			if ([pHrefURL hasPrefix:@"javascript:"] == YES)
			{
				pHrefURL = nil;
			}
			else
			{
				bShowMenu = true;
			}
		}
		else if ([strTagName isEqualToString:@"IMG"] )
		{
			WKMD_LOG_NSLOG(@"tagsHREF : %@",tagsHREF);
			if ([tagsHREF length] > 1)
			{
				pHrefURL = tagsHREF;
			}
			bShowMenu = true;
			pImgSrcURL = (NSString*)[array objectAtIndex:1];
		}
		
		if (bShowMenu)
		{
			if([array count] >= 2)
			{
				if ([pImgSrcURL hasPrefix:@"ext:"] || [pHrefURL hasPrefix:@"ext:"])
				{
					return;
				}
				UCWebkitActionSheet *sheet = [[UCWebkitActionSheet alloc] initWithTagName:strTagName ImgSrcURL:pImgSrcURL href: pHrefURL];
				WKMD_LOG_NSLOG(@"sheet.url = %@", sheet.hrefURL);
				[sheet showInView:m_webView];
				[sheet release];
			}
		}
	}
}

- (CGPoint)caculatorHrefPointIOS4:(CGPoint)longPressPoint
{
	UIWebView* m_webView = self;
	//装换point从UCWebLongPressView到UIWebView
	//longPressPoint = [m_webView convertPoint:longPressPoint fromView:m_longPressView];
	
	// convert point from view to HTML coordinate system
	CGPoint offset  = [m_webView webViewScrollOffset];
	CGSize viewSize = [m_webView frame].size;
	CGSize windowSize = [m_webView webViewWindowSize];
	
	// 修正坐标偏移, 正确获取当前鼠标下的URL
	UIView* pDocumentView = [self findWebViewDocumentView:m_webView];
	CGPoint hrefPoint = [m_webView convertPoint:longPressPoint toView: pDocumentView];
	
	// 由于地址栏的位置不同,导致坐标的计算很复杂
	// nXFactor: 放大时, 如果地址栏有偏移则, x方向需要计算偏移
	int nXFactor = 0;
	//CGFloat fTop = 0;
	//fTop = [self scrollViewTop];
	//if (hrefPoint.y != longPressPoint.y - [self scrollViewTop])
	{
		hrefPoint = longPressPoint;
		nXFactor = 1;
	}
	
	WKMD_LOG_NSLOG(@"======longPressPoint=[%@]", NSStringFromCGPoint(longPressPoint));
	WKMD_LOG_NSLOG(@"======hrefPoint=[%@]", NSStringFromCGPoint(hrefPoint));
	WKMD_LOG_NSLOG(@"======pDocumentView=%@", pDocumentView);
	WKMD_LOG_NSLOG(@"======m_webView=%@", m_webView);
	WKMD_LOG_NSLOG(@"======offset=[%@]", NSStringFromCGPoint(offset));
	
	//CGPoint hrefPoint = CGPointMake(longPressPoint.x, longPressPoint.y - docFrame.origin.y);
	CGFloat convertValue = windowSize.width / viewSize.width;
	longPressPoint.x = hrefPoint.x * convertValue + offset.x*nXFactor;
	longPressPoint.y = hrefPoint.y * convertValue + offset.y;
	WKMD_LOG_NSLOG(@"======longPressPoint=[%@]", NSStringFromCGPoint(longPressPoint));
	WKMD_LOG_NSLOG(@"======convertValue=[%f]", convertValue);
	
	return longPressPoint;
}

- (CGPoint)caculatorHrefPointIOS5:(CGPoint)longPressPoint
{
	UIWebView* m_webView = self;
	// convert point from view to HTML coordinate system
	CGPoint offset  = [m_webView webViewScrollOffset];
	CGSize viewSize = [m_webView frame].size;
	CGSize windowSize = [m_webView webViewWindowSize];
	
	// 修正坐标偏移, 正确获取当前鼠标下的URL
	UIView* pDocumentView = [self findWebViewDocumentView:m_webView];
	CGPoint hrefPoint = [m_webView convertPoint:longPressPoint toView: pDocumentView];
	
	//longPressPoint = hrefPoint;
	//CGPoint hrefPoint = CGPointMake(longPressPoint.x, longPressPoint.y - docFrame.origin.y);
	CGFloat convertValue = windowSize.width / viewSize.width;
	
	WKMD_LOG_NSLOG(@"======longPressPoint=[%@]", NSStringFromCGPoint(longPressPoint));
	WKMD_LOG_NSLOG(@"======hrefPoint=[%@]", NSStringFromCGPoint(hrefPoint));
	WKMD_LOG_NSLOG(@"======pDocumentView=%@", pDocumentView);
	WKMD_LOG_NSLOG(@"======m_webView=%@", m_webView);
	WKMD_LOG_NSLOG(@"======offset=[%@]", NSStringFromCGPoint(offset));
	
	if (offset.y < 1)
	{
		longPressPoint.x = hrefPoint.x;
		longPressPoint.y = hrefPoint.y;
	}
	longPressPoint.x = longPressPoint.x * convertValue;
	longPressPoint.y = longPressPoint.y * convertValue;
	WKMD_LOG_NSLOG(@"======longPressPoint=[%@]", NSStringFromCGPoint(longPressPoint));
	WKMD_LOG_NSLOG(@"======convertValue=[%f]", convertValue);
	
	return longPressPoint;
}

#define   MSYSInf   iUCCommon
//长按事件被启动,处理长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *) gestureRecognizer
{
	if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
	{
		[self resignFirstResponder];
		CGPoint longPressPoint = [gestureRecognizer locationInView:self];
		
		CGPoint hrefPoint = CGPointZero;
		
		if(MSYSInf::PLATFORM_IPOHNE4 == MSYSInf::GetPlatform())
		{
			hrefPoint = [self caculatorHrefPointIOS4:longPressPoint];
		}
		else if(MSYSInf::PLATFORM_IPOHNE5 == MSYSInf::GetPlatform())
		{
			hrefPoint = [self caculatorHrefPointIOS5:longPressPoint];
		}
		
		[self openContextualMenuAt:hrefPoint];
	}
}

//- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
//    /*
//     UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//     [dialogue show];
//     [dialogue autorelease];
//     */
//}
//- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame{
//	return NO;
//}

@end
// =================================================================
#pragma mark -
#pragma mark 文件尾

