

#import "BookLayoutConfig.h"
#import "DemoSettingView.h"
#import "DeviceDiskConsumeStatusView.h"
#import "DemoViewCoreTextDrawMacroDefine.h"



///< 私有方法
@interface DeviceDiskConsumeStatusView (/*DemoViewCoreTextDraw_private*/)
{
	
}


- (void)addSomeViews:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

- (void)addButtons:(CGRect)frame;


@end

// =================================================================
#pragma mark-
#pragma mark DeviceDiskConsumeStatusView实现

@implementation DeviceDiskConsumeStatusView


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
		
		[self addSomeViews:frame];
		
		[self initDeviceInfo];
    }
    return self;
}

- (void)dealloc
{
	[m_deviceData release];
	[m_titles release];
	
	[self releaseObject];
    
    [super dealloc];
}

-(void)releaseObject
{
	[self removeAppObserver];
	
}

// =================================================================
#pragma mark- == 边框圆角半径 设置层的背景颜色，层的设置圆角半径为20
#define kKeyButtonHeight        50

- (void)addSomeViews:(CGRect)frame
{
	// MARK: 添加观察者接口
	[self addAppObserver];
	
//	CGSize size = frame.size;
//	size.height = 2048;
//	self.contentSize = size;
	
	CGRect rect = CGRectMake(0, 60, frame.size.width, frame.size.height - kKeyButtonHeight -20);
	[self addSimpleParagraphView:rect];
	
	rect = CGRectMake(0, frame.size.height - kKeyButtonHeight -10, frame.size.width, kKeyButtonHeight);
	[self addButtons:rect];
}

- (void)addSimpleParagraphView:(CGRect)frame
{
}

// =================================================================
#pragma mark- == Core Animation之多种动画效果
// 1、把图片移到右下角变小透明
// =================================================================
#pragma mark-
#pragma mark 创建按钮

- (void)onButtonClickEvent:(UIButton*)button
{
	int nTag = button.tag;
	if (nTag == 1)
	{
		// 下一页
//		[self showNextPage];
	}
	else if (nTag == 2)
	{
		// 上一页
//		[self showPreviousPage];
	}
	else if (nTag == 3)
	{
		// 下一章
//		[self showNextChapter];
	}
	else if (nTag == 4)
	{
		// 上一章
//		[self showPreviousChapter];
	}
	else if (nTag == 5)
	{
		// "属性配置"按钮
		[self addSettingView];
	}
}

- (void)addButtons:(CGRect)frame
{
	UIButton* pBtn = nil;
    CGRect selfFrame = frame;
    int btnWidth = selfFrame.size.width / 5;
	int nTag = 1;
	
	btnWidth -= 5;
	CGRect btnRect = CGRectMake(0, frame.origin.y, btnWidth, frame.size.height);
//	btnRect.origin.y = selfFrame.size.height - btnRect.size.height;
	
#if 0
	// "下一页"按钮
	nTag = 1;
	btnRect.origin.x += 0;
	pBtn = [self newButton:nTag withName:nil withTitle:@"下一页"];
	[pBtn setFrame:btnRect];
	[pBtn release];
	
	// "上一页"按钮
	nTag = 2;
	btnRect.origin.x += btnWidth + 5;
	pBtn = [self newButton:nTag withName:nil withTitle:@"上一页"];
	[pBtn setFrame:btnRect];
	[pBtn release];
	
	// "下一章"按钮
	nTag = 3;
	btnRect.origin.x += btnWidth + 5;
	pBtn = [self newButton:nTag withName:nil withTitle:@"下一章"];
	[pBtn setFrame:btnRect];
	[pBtn release];
	
	// "上一章"按钮
	nTag = 4;
	btnRect.origin.x += btnWidth + 5;
	pBtn = [self newButton:nTag withName:nil withTitle:@"上一章"];
	[pBtn setFrame:btnRect];
	[pBtn release];
#endif
	// "属性配置"按钮
	nTag = 5;
	//	btnRect.origin.x = (selfFrame.size.width - btnWidth)*0.5f;
	btnRect.origin.x = selfFrame.size.width - btnWidth;
	pBtn = [self newButton:nTag withName:nil withTitle:@"属性配置"];
	[pBtn setFrame:btnRect];
	[pBtn release];
}

- (UIButton*)newButton:(int)nTag withName:(NSString*)pStrName withTitle:(NSString*)pTitle
{
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button addTarget:self action:@selector(onButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = nTag;
	button.accessibilityLabel = pStrName;
	[button setTitle:pTitle forState:UIControlStateNormal];
	button.backgroundColor = [UIColor blueColor];
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
	[self addSubview:button];
	
	return button;
}

// =================================================================
#pragma mark- ==添加观察者接口

- (void)addAppObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTextAttributes:) name:kKeyNotificationSaveTextAttributes object:nil];
}

- (void)removeAppObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKeyNotificationSaveTextAttributes object:nil];
}

#pragma mark -==文本属性设置相关
- (void)saveTextAttributes:(NSNotification*)notify
{
	if ([NSThread isMainThread])
	{
		//		[self saveTextAttributesDelay:notify];
		[self performSelector:@selector(saveTextAttributesDelay:) withObject:notify afterDelay:0.05f];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(saveTextAttributesDelay:) withObject:notify waitUntilDone:NO];
	}
}

- (void)saveTextAttributesDelay:(NSNotification*)notify
{
}

- (void)delayRedraw
{
//    [_simplePageView setNeedsDisplay];
}


- (void)addSettingView
{
	CGRect rect = [self bounds];
	rect.origin.y = 20;
}

// =================================================================
#pragma mark- ==获取设备信息接口
//
//- (float)getFreeDiskspace
//{
//	float totalSpace;
//	float totalFreeSpace;
//	NSError *error = nil;
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
//	
//	if (dictionary) {
//		NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
//		NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
//		totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
//		totalFreeSpace = [freeFileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
//		NSLog(@"Memory Capacity of %f GB with %f GB Free memory available.", totalSpace, totalFreeSpace);
//	}
//	else
//	{
//		NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
//	}
//	
//	return totalFreeSpace;
//}

- (void)initDeviceInfo
{
	CGRect frame = [self frame];
	
	self.backgroundColor = [UIColor blueColor];
	// Initialization code.
	m_frame = frame;
	m_totalSpace = [self getTotalDiskSpace];
	m_freeSpace = [self getFreeDiskSpace];
	m_directorySpace = [self getDirectorySpace:nil];
	m_otherSpace = m_totalSpace - m_freeSpace - m_directorySpace;
	NSString * totalSpace = [NSString stringWithFormat:@"%.2fG",m_totalSpace];
	NSString * freeSpace = [NSString stringWithFormat:@"%.2fG",m_freeSpace];
	NSString * directorySpace = [NSString stringWithFormat:@"%.2fG",m_directorySpace];
	NSString * otherSpace = [NSString stringWithFormat:@"%.2fG",m_otherSpace];
	
	m_deviceData = [[NSArray alloc] initWithObjects:totalSpace,directorySpace,otherSpace,freeSpace,nil];
	m_titles = [[NSArray alloc] initWithObjects:@"容量: ",@"本地影片: ",@"其他程序: ",@"剩余空间: ",nil];
	
	NSLog(@"m_totalSpace:%.1fG",[self getTotalDiskSpace]);
	NSLog(@"m_freeSpace:%.1fG",m_freeSpace);
	NSLog(@"m_directorySpace:%.1fG",m_directorySpace);
	NSLog(@"m_otherSpace:%.1fG",m_otherSpace);
	[self initlabel];
}


- (void)initlabel
{
	int height = CGRectGetHeight(m_frame)/2;
	int width = CGRectGetWidth(m_frame)/2; //200;
	int offset = 0;
	for (int i = 0; i < [m_titles count]; i++) {
		int row = i / 2;
		int col = i % 2;
		float originX = col * (width + offset);
		float originY = row * (height + offset);
		UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(originX,originY,width,height)];
		label.backgroundColor = [UIColor lightGrayColor];
		// MARK: ==
		NSString * text = [[m_titles objectAtIndex:i] stringByAppendingFormat:@"%@", [[m_deviceData objectAtIndex:i] description]];
		label.text = text;
		[self addSubview:label];
		[label release];
	}
}

- (float)getDirectorySpace:(NSString *)directoryName
{
	// if this dirctory in homedirctory then
	NSString * dirName = @"/zing1230";
	NSString * dirPath = [[self getHomeDirectory] stringByAppendingFormat:@"%@", dirName];
	NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
	int count = [fileNames count];
	float totalFileSize = 0;
	for (int i = 0; i < count; i ++) {
		NSString * fileName = [fileNames objectAtIndex:i];
		NSString * filePath = [dirPath stringByAppendingFormat:@"/%@",fileName];
//		NSDictionary * infoDic = [[NSFileManager defaultManager] fileAttributesAtPath:filePath traverseLink:YES];
		NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
		
		NSNumber * fileSizeInBytes = [infoDic objectForKey: NSFileSize];
		float size = [fileSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
		totalFileSize += size;
	}
	return totalFileSize;
}

- (float)getTotalDiskSpace
{
	float totalSpace;
	NSError * error;
	NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[self getHomeDirectory] error: &error];
	if (infoDic) {
		NSNumber * fileSystemSizeInBytes = [infoDic objectForKey: NSFileSystemSize];
		totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
		return totalSpace;
	}
	else
	{
		NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
		return 0;
	}
}

- (float)getFreeDiskSpace
{
	float totalFreeSpace;
	NSError * error;
	NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[self getHomeDirectory] error: &error];
	if (infoDic) {
		NSNumber * fileSystemSizeInBytes = [infoDic objectForKey: NSFileSystemFreeSize];
		totalFreeSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
		return totalFreeSpace;
	} else {
		NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
		return 0;
	}
}

- (NSString *)getDocumentDirectoryPath
{
	NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [path lastObject];
}

- (NSString *)getCachesDirectoryPath
{
	NSArray * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [path lastObject];
}

- (NSString *)getTemporaryDirectoryPath
{
	NSString * tmpPath = NSTemporaryDirectory();
	return tmpPath;
}

- (NSString *)getHomeDirectory
{
	NSString * homePath = NSHomeDirectory();
	return homePath;
}

//- (void)dealloc {
//	[m_deviceData release];
//	[m_titles release];
//    [super dealloc];
//}

@end


