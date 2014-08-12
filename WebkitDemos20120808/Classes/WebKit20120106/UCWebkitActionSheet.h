//
//  UCWebkitActionSheet.h
//  iUCWEB
//
//  Created by lixianfeng on 2011-12-21.
//  Copyright 2009 UCWEB. All rights reserved.
//



@interface UCWebkitActionSheet : UIActionSheet<UIActionSheetDelegate>
{
	NSString* m_tagName;     //要弹出ActionSheet的tagName
	NSString* m_pHrefURL;         //从tagName获取到的url
	NSString* m_pImageSrcURL;
	UILabel* m_pTitleLabel;
}

-(id)initWithTagName:(NSString*)tagName ImgSrcURL:(NSString*)pImageSrcURL href:(NSString*)pHrefURL;
@property(nonatomic,retain) NSString* hrefURL;
@property(nonatomic,retain) NSString* tagName;



// 添加长按菜单按钮
- (void)addLPMenuButtons:(NSString*)tagName URL:(NSString*)pHrefURL;
- (void)setImageSrc:(NSString*)pImageSrcURL;

// 响应长按菜单上按钮点击事件
- (void)actionSheetBtnEvent:(NSString*)pCurBtnTitle;

// 按钮事件处理
- (void)onBtnEvent:(NSString*)pCurBtnTitle;

// 长按菜单, 响应图片保存
- (void)saveImage:(NSString*)pCurBtnTitle image:(NSString*)pImageSrcURL;
// 将图片保存到相册
- (void)saveImageToAlbum:(NSString*)pStrFilePath;
- (void)saveImageToAlbumFromURL:(NSString*)pImageSrcURL;

// 长按菜单, 响应后台打开窗口
- (void)openNewWindowOnBg:(NSString*)pHrefURL;
// 长按菜单, 响应拷贝URL
- (void)copyLinkURL:(NSString*)pHrefURL;

@end

// =================================================================
#pragma mark -
#pragma mark  UIWebView_Protocol_UC声明
@interface UIWebView(UIWebView_Protocol_UC)
- (CGSize)webViewWindowSize;
- (CGPoint)webViewScrollOffset;
@end


bool iExportPicToAlbum(NSString *path);
bool iExportPicToAlbumFormNSDate(void* data);
bool iExportPicToAlbumFormWebkitFile(NSString *strFilePath);
bool iExportPicToAlbumFormUrl(NSString *strUrl);
