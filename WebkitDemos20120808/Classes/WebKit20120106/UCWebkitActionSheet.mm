//
//  UCWebkitActionSheet.mm
//  iUCWEB
//
//  Created by lixianfeng on 2011-12-21.
//  Copyright 2009 UCWEB. All rights reserved.
//

//#import "iStdafxMM.h"
#import "iUCCommon.h"
#import "UCWebkitActionSheet.h"
#import "SDURLCache.h"
#import "iUIWebKitMacroDefine.h"
//#import "iUCCommon.h"
#ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW
#import <objc/runtime.h>
#endif // #ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW

#define STR_VIEW_LPM_NEW_OPEN			@"新窗口打开"
#define STR_VIEW_LPM_BK_OPEN				@"后台打开"
#define STR_VIEW_LPM_COPY				@"拷贝"
#define STR_VIEW_LPEM_SAVE_IMG			@"保存图片"
#define STR_MENU_CANCEAL                             @"取消"

// title显示行数的默认URL, 用来初始化显示行数据, 以便获取 titleLabel的frame
// 横/竖屏1行显示
#define   kStrOneLinePortraitURL          @"http://3g.sina.com.cn/?vt=3&wm=4007"

#ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW
// C 语言方法
void investigateClassConstructInside (const char* strClassName);
#endif // #ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW

@interface UCWebkitActionSheet(UCWebkitActionSheet_Protocol_UC)
- (void)addTitleLabel:(NSString*)pTitleText;

- (void)setNewTitleLabel:(CGRect)rect;
- (UILabel*)getTitleLabel;
#ifdef WKMD_PRINT_TEST_LOG
- (void)printSubview:(UIView*)pParentView;
#endif
@end

// =================================================================
#pragma mark -
#pragma mark  UCWebkitActionSheet实现

@implementation UCWebkitActionSheet

@synthesize hrefURL = m_pHrefURL;
@synthesize tagName = m_tagName;


-(id)initWithTagName:(NSString*)tagName ImgSrcURL:(NSString*)pImageSrcURL href:(NSString*)pHrefURL
{
	self = [super initWithTitle:kStrOneLinePortraitURL delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	if (self)
	{
		//CGRect frame = [self frame];
		self.tagName = tagName;
		
		NSString* pTitleText = nil;
		if ([[tagName uppercaseString] isEqualToString:@"IMG"])
		{
			if (pImageSrcURL != nil && [pImageSrcURL length] > 1)
			{
				[self setImageSrc:pImageSrcURL];
				pTitleText = pImageSrcURL;
			}
		}
		else
		{
			// 文字链接
			if (pHrefURL != nil && [pHrefURL length] > 1)
			{
				pTitleText = pHrefURL;
			}
		}
		
		if (pHrefURL != nil && [pHrefURL length] > 1)
		{
			m_pHrefURL = [[NSString alloc] initWithFormat:@"%@", pHrefURL];
			[self addTitleLabel:pTitleText];
		}
		else
		{
			// pHrefURL 非空但长度小于2
			self.title = nil;
			pHrefURL = nil;
		}
		
		[self addLPMenuButtons:tagName URL:pHrefURL];
	}
	
	return self;
}

- (void)setImageSrc:(NSString*)pImageSrcURL
{
	m_pImageSrcURL = [[NSString alloc] initWithFormat:@"%@", pImageSrcURL];
}


// 添加长按菜单按钮
- (void)addLPMenuButtons:(NSString*)tagName URL:(NSString*)pHrefURL
{
	NSString* pBtnTitle = nil;
	if ([[tagName uppercaseString] isEqualToString:@"IMG"])
	{
		// 保存图片长按菜单
		//pBtnTitle =  U2NS(STR_VIEW_LPEM_SAVE_IMG);
		pBtnTitle =  STR_VIEW_LPEM_SAVE_IMG;
		[self addButtonWithTitle:NSLocalizedString(pBtnTitle, @"")];
		[pBtnTitle release];
		
		if (pHrefURL != nil && [pHrefURL length] > 0)
		{
			// "后台打开"
			//pBtnTitle =  U2NS(STR_VIEW_LPM_BK_OPEN);
			pBtnTitle =  STR_VIEW_LPM_BK_OPEN;
			[self addButtonWithTitle:NSLocalizedString(pBtnTitle, @"")];
			[pBtnTitle release];
			
			// "拷贝"
			//pBtnTitle =  U2NS(STR_VIEW_LPM_COPY);
			pBtnTitle =  STR_VIEW_LPM_COPY;
			[self addButtonWithTitle:NSLocalizedString(pBtnTitle, @"")];
			[pBtnTitle release];
		}
	}
	else if ([[tagName uppercaseString] isEqualToString:@"A"])
	{
		// 链接长按菜单
		// "后台打开"
		//pBtnTitle =  U2NS(STR_VIEW_LPM_BK_OPEN);
		pBtnTitle =  STR_VIEW_LPM_BK_OPEN;
		[self addButtonWithTitle:NSLocalizedString(pBtnTitle, @"")];
		[pBtnTitle release];
		
		// "拷贝"
		//pBtnTitle =  U2NS(STR_VIEW_LPM_COPY);
		pBtnTitle =  STR_VIEW_LPM_COPY;
		[self addButtonWithTitle:NSLocalizedString(pBtnTitle, @"")];
		[pBtnTitle release];
	}
	
	NSString* strCancel = nil;
	//strCancel = U2NS(STR_MENU_CANCEAL);
	strCancel = STR_MENU_CANCEAL;
	self.cancelButtonIndex = [self addButtonWithTitle:NSLocalizedString(strCancel, @"")];
	[strCancel release];
}

// 长按菜单事件处理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UCWebkitActionSheet* pWebAction = (UCWebkitActionSheet*)actionSheet;
	NSString* pCurBtnTitle = [pWebAction buttonTitleAtIndex:buttonIndex];
	
	if([[pWebAction.tagName uppercaseString] isEqualToString:@"IMG"] ||
	   [[pWebAction.tagName uppercaseString] isEqualToString:@"A"]
		)
	{
		[self actionSheetBtnEvent: pCurBtnTitle];
		//[self performSelectorOnMainThread:@selector(actionSheetBtnEvent:) withObject:pCurBtnTitle waitUntilDone:true];
	}
}

-(void)dealloc
{
	WKMD_LOG_NSLOG(@"=====UCWebkitActionSheet=-(void)dealloc===========");
	[m_pTitleLabel removeFromSuperview];
	[m_pTitleLabel release];
	m_pTitleLabel = nil;
	[m_pImageSrcURL release];
	m_pImageSrcURL = nil;
	
	self.hrefURL = nil;
	self.tagName = nil;
	[super dealloc];
}

// =================================================================
#pragma mark -
#pragma mark  菜单事件响应

// 响应长按菜单上按钮点击事件
- (void)actionSheetBtnEvent:(NSString*)pCurBtnTitle
{
	[self onBtnEvent:pCurBtnTitle];
}

// 按钮事件处理
- (void)onBtnEvent:(NSString*)pCurBtnTitle
{
	BOOL bCancel = NO;
	NSString* pCancelBtnTitle = nil;
	//pCancelBtnTitle = U2NS(STR_MENU_CANCEAL);
	pCancelBtnTitle = STR_MENU_CANCEAL;
	bCancel = [pCurBtnTitle isEqualToString: pCancelBtnTitle];
	[pCancelBtnTitle release];
	// 被"取消"
	if (bCancel == YES)
	{
		return;
	}
	
	WKMD_LOG_NSLOG(@"=====cur RUL = %@", self.hrefURL);
	NSString* pSaveBtnTitle = nil;
	//pSaveBtnTitle = U2NS(STR_VIEW_LPEM_SAVE_IMG);
	pSaveBtnTitle = STR_VIEW_LPEM_SAVE_IMG;
	if ([pCurBtnTitle isEqualToString:pSaveBtnTitle] == YES)
	{
		[self saveImage:pCurBtnTitle image:m_pImageSrcURL];
	}
	else
	{
		if (nil == self.hrefURL || [self.hrefURL length] < 1)
		{
			return;
		}
		
		// "后台打开"
		NSString* pBkOpenBtnTitle = nil;
		//pBkOpenBtnTitle =  U2NS(STR_VIEW_LPM_BK_OPEN);
		pBkOpenBtnTitle =  STR_VIEW_LPM_BK_OPEN;
		if ([pCurBtnTitle isEqualToString:pBkOpenBtnTitle] == YES)
		{
			// "后台打开"
			[self performSelector:@selector(openNewWindowOnBg:) withObject:m_pHrefURL afterDelay:0.0];
		}
		else// if ([pCurBtnTitle isEqualToString:pCopyBtnTitle] == YES)
		{
			// "拷贝"
			NSString* copyURL = m_pHrefURL;
			if (m_pImageSrcURL)
			{
				copyURL = m_pImageSrcURL;
			}
			[self performSelector:@selector(copyLinkURL:) withObject:copyURL afterDelay:0.0];
		}
		
		[pBkOpenBtnTitle release];
	}
	
	[pSaveBtnTitle release];
}

// 长按菜单, 响应图片保存
- (void)saveImage:(NSString*)pCurBtnTitle image:(NSString*)pImageSrcURL
{
	NSString* pSaveBtnTitle = nil;
	//pSaveBtnTitle =  U2NS(STR_VIEW_LPEM_SAVE_IMG);
	pSaveBtnTitle =  STR_VIEW_LPEM_SAVE_IMG;
	
	//保存图片
	if([pCurBtnTitle isEqualToString:pSaveBtnTitle] && (nil != pImageSrcURL && [pImageSrcURL length] > 1))
	{
		if ([[NSURLCache sharedURLCache] isKindOfClass:[SDURLCache class]])
		{
			NSURL* imageUrl = [NSURL URLWithString: pImageSrcURL];
			NSString* strFilePath = [(SDURLCache *)[NSURLCache sharedURLCache] getFilePathUseUrl:imageUrl];
			
			//如果缓存的文件不存在则重新下载
			if(nil == strFilePath)
			{
				[self performSelector:@selector(saveImageToAlbumFromURL:) withObject:pImageSrcURL afterDelay:0.0];
			}
			else//如果缓存的文件存在则直接将文件移到相册
			{
				[self performSelector:@selector(saveImageToAlbum:) withObject:strFilePath afterDelay:0.0];
			}
		}
	}
}

- (void)saveImageToAlbumFromURL:(NSString*)pImageSrcURL
{
	if (nil != pImageSrcURL && [pImageSrcURL length] > 0)
	{
//		CString csUrl = MEncode::A2U([pImageSrcURL UTF8String]);
//		MUISubmitCmd(UC_CMD_IPHONE_ADD_IMG_FROM_URL, (void*)(LPCTSTR)csUrl, NULL);
		iExportPicToAlbumFormUrl(pImageSrcURL);
	}
}

// 将图片保存到相册
- (void)saveImageToAlbum:(NSString*)pStrFilePath
{
	if (nil != pStrFilePath && [pStrFilePath length] > 0)
	{
//		CString csFilePath = MEncode::A2U([pStrFilePath UTF8String]);
//		MUISubmitCmd(UC_CMD_IPHONE_ADD_IMG_FROM_WEBKIT_FILE, (void*)(LPCTSTR)csFilePath, NULL);
		//iExportPicToAlbum(pStrFilePath);
		iExportPicToAlbumFormWebkitFile(pStrFilePath);
	}
}

// 长按菜单, 响应后台打开窗口
//- (void)openNewWindowOnBg:(NSString*)pCurBtnTitle href:(NSString*)pHrefURL
- (void)openNewWindowOnBg:(NSString*)pHrefURL
{
//	CString bkURL = MEncode::A2U((LPCSTR)[pHrefURL UTF8String]);
//	
//	// fixbug:0109515: 【后台打开】webkit页面后台打开网址变为了U2直连打开
//	// 先判断当前获取到的URL是否有"ext:es:", "ext:as:", "ext:webkit:"等特殊字符(有可能是业务需要在url前面设置的)
//	if (!MStringTools::StringStartOf(bkURL,L"ext:"))
//	{
//		bkURL.Insert(0, L"ext:webkit:"); // 强制使用webkit
//	}
//	
//	// "后台打开"
//	MUISubmitCmd(UC_CMD_WINDOW_NEW_OPEN_BK, (void*)(LPCTSTR)bkURL, nil);
}

// 长按菜单, 响应拷贝URL
- (void)copyLinkURL:(NSString*)pHrefURL
{
//	CString bkURL = MEncode::A2U((LPCSTR)[pHrefURL UTF8String]);
//	// "拷贝"
//	MUISubmitCmd(UC_CMD_UI_ADD_CLIPBORAD, (void*)(LPCTSTR)bkURL,NULL);
	
#ifdef WKMD_PRINT_TEST_LOG
	[self printSubview:self];
#endif
}

// =================================================================
#pragma mark -
#pragma mark  菜单title label的布局
- (void)layoutSubviews
{
	[self setNewTitleLabel:[self frame]];
}

- (void)addTitleLabel:(NSString*)pTitleText
{
	m_pTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	m_pTitleLabel.text = pTitleText;
	
	// 设置显示属性
	//m_pTitleLabel.font = pLabel.font;
	m_pTitleLabel.font = [UIFont systemFontOfSize:14.0f];
	m_pTitleLabel.numberOfLines = 1;
	m_pTitleLabel.textAlignment = UITextAlignmentCenter;
	m_pTitleLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	m_pTitleLabel.shadowOffset = CGSizeMake(0, -1);
	m_pTitleLabel.backgroundColor = [UIColor clearColor];
	
	// 颜色
	float colorTitleText[4] =   {1.0f};
	float* pColor = nil;
	UIColor *titleColor = nil;
	iUCCommon::setColor(colorTitleText, 0xffffff, 1);
	pColor = colorTitleText;
	titleColor = [UIColor colorWithRed:pColor[0] green:pColor[1] blue:pColor[2] alpha:pColor[3]];
	m_pTitleLabel.textColor = titleColor;
	
	iUCCommon::setColor(colorTitleText, 0x1b1c1e, 1);
	pColor = colorTitleText;
	titleColor = [UIColor colorWithRed:pColor[0] green:pColor[1] blue:pColor[2] alpha:pColor[3]];
	m_pTitleLabel.shadowColor = titleColor;
	
	[self addSubview:m_pTitleLabel];
}

- (void)setNewTitleLabel:(CGRect)rect
{
	if (m_pTitleLabel)
	{
		UILabel* pLabel = [self getTitleLabel];
		if (pLabel == nil)
		{
			return;
		}
		
		CGRect frame = [pLabel frame];
		[m_pTitleLabel setFrame:frame];
		
		pLabel.hidden = YES;
		pLabel.backgroundColor = [UIColor clearColor];
	}
}

// 获取 title label 
- (UILabel*)getTitleLabel
{
	UILabel* pLabel = nil;
	int nCount = [[self subviews] count];
	UIView* subView = nil;
	int i = 0;
	for(; i < nCount; ++i)
	{
		subView = [[self subviews] objectAtIndex:i];
		if ([subView isKindOfClass:[UILabel class]])
		{
			pLabel = (UILabel*)subView;
			break;
		}
	}
	return pLabel;
}

//=====================================================================
#ifdef WKMD_PRINT_TEST_LOG
- (void)printSubview:(UIView*)pParentView
{
	WKMD_LOG_NSLOG(@"\n\n[pParentView =] %@", pParentView);
	
//	int nCount = [[pParentView subviews] count];
//	UIView* subView = nil;
//	int i = 0;
//	for(; i < nCount; ++i)
//	{
//		subView = [[pParentView subviews] objectAtIndex:i];
//		WKMD_LOG_NSLOG(@"\n\n[i=%d] ==%@", i, subView);
//#ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW
//		investigateClassConstructInside([[[subView class] description] UTF8String]);
//#endif // #ifdef investigateClassConstructInside
//	}
	
#ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW
	investigateClassConstructInside("UIWebView");
	investigateClassConstructInside("UIWebDocumentView");
	investigateClassConstructInside("UIWebBrowserView");
#endif // #ifdef investigateClassConstructInside
}
#endif // #ifdef WKMD_PRINT_TEST_LOG

@end


// =================================================================
#pragma mark -
#pragma mark  UIWebView_Protocol_UC实现
@implementation UIWebView(UIWebView_Protocol_UC)

- (CGSize)webViewWindowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)webViewScrollOffset
{
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}

@end
// =================================================================

// C 语言方法
#ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW
void investigateClassConstructInside (const char* strClassName)
{
	//id cls = objc_getClass ("UIWebView");
	id cls = objc_getClass (strClassName);
    
	if (cls == nil)
	{
		printf ("nil cls\n");
		return;
	}
	
	unsigned int count;
	Method *method = class_copyMethodList (cls, &count);
    
	printf ("\n// ============================");
	printf ("\n [%s] class method list: count = [%d]\n", strClassName, count);
	for (int i=0; i<count; ++i)
	{
		printf ("[i=%d], %s\n", i, sel_getName (method_getName (method[i])));
		//printf ("%s\n", sel_getName (method_getName (method[i])));
		//objc_method_description *method_getDescription(method[i]) 
	}
	
	free (method);
	method = NULL;
    
	Ivar *ivar = class_copyIvarList (cls, &count);
	
	printf ("\n [%s] class instance variable list: count = [%d]\n", strClassName, count);
	for (int i=0; i<count; ++i)
	{
		//printf ("%s\n", ivar_getName (ivar[i]));
		printf ("[i=%d], %s\n", i, ivar_getName (ivar[i]));
	}
	
	free (ivar);
	ivar = NULL;
	
	objc_property_t *property = class_copyPropertyList (cls, &count);
	
	printf ("\n [%s] class  property list: count = [%d]\n", strClassName, count);
	for (int i=0; i<count; ++i) {
		//printf ("%s\n", property_getName (property[i]));
		printf ("[i=%d], %s\n", i, property_getName (property[i]));
	}
	
	free (property);
	property = NULL;
	
	printf ("\n\n\n");
}

#endif // #ifdef WKMD_PRINT_TEST_LOG_FOR_SUBVIEW


// =================================================================
#pragma mark -
#pragma mark  长按菜单图片保存

// U2内核页面长按"保存图片"
bool iExportPicToAlbum(NSString *path)
{
	bool bRet = false;
	//NSString *path = U2NS(filepath);
	if(!path)
	{
		return false;
	}
	//use initWithContentsOfFile_custom to fix bug#103386 (by jungle 2011/12/17)
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
	[path release];
	
	NSData *pngData =  UIImagePNGRepresentation (image);
	[image release];
	if(pngData)
	{
		bRet = iExportPicToAlbumFormNSDate((void*)pngData);
	}
	return bRet;
}

//把webkit缓存的plist数据里面的图片，保存到相册
//这里为什么有这么多NSMutableDictionary和NSArray的操作，看下webkit缓存的plist文件就知道了
bool iExportPicToAlbumFormWebkitFile(NSString *strFilePath)
{
    bool bRet = false;
    //NSString *strFilePath = U2NS(filepath);
    if(!strFilePath)
	{
		return false;
	}
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:strFilePath];
    if(!dict)
    {
        [dict release];
        return false;
    }
    NSArray* dataArray = [dict objectForKey:@"$objects"];
    if(dataArray && ([dataArray count] >= 3))
    {
        NSMutableDictionary* dictData = [dataArray objectAtIndex:2];
        if(!dictData)
        {
            [dict release];
            return false;
        }
        NSData* data = [dictData objectForKey:@"NS.data"];
        if(!data)
        {
            [dict release];
            return false;
        }
        
        bRet = iExportPicToAlbumFormNSDate((void*)data);
    }
    
    [dict release];
    
    return bRet;
}

//把一个图片的url，下载下来保存到相册
bool iExportPicToAlbumFormUrl(NSString *strUrl)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    bool bRet = false;
    do
    {
	//NSString *strUrl = U2NS(url);
        if(!strUrl)
        {
            bRet = false;
            break;
        }
        NSURL* imageUrl = [NSURL URLWithString:strUrl];
        NSData* data = [NSData dataWithContentsOfURL:imageUrl];
        if(!data)
        {
            bRet = false;
            break;
        }
        bRet = iExportPicToAlbumFormNSDate((void*)data);
    }while(false);
    
    [pool release];
    return bRet;
}

//把图片格式的data数据保存到相册
bool iExportPicToAlbumFormNSDate(void* data)
{
    bool bRet = false;
    NSData* nsdata = (NSData*)data;
    if(!nsdata)
    {
        return false;
    }
    UIImage* dataImage = [[UIImage alloc] initWithData:nsdata];
    if(dataImage)
    {
        UIImageWriteToSavedPhotosAlbum( dataImage,nil,nil,nil);
        bRet = true;
    }
    [dataImage release];
    
    return bRet;
}

// =================================================================
#pragma mark -
#pragma mark file_end

