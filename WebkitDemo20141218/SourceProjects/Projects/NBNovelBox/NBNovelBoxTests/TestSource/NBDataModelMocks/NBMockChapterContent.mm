


#import "NBMockChapterContent.h"


///< 文件和路径
//#define kNBSMNWUnitTestData_PATH                        @"/Library"
#define kNBSMNWUnitTestData_PATH                        @"/Library/Application Support/others"
#define kNBSMNWUnitTestData_SRCPATH                     @"/HardCodeData"
#define kNBSMNWUnitTestData_JSON_FileName               @"/testData.txt"


@interface NBMockChapterContent()

@end


@implementation NBMockChapterContent


- (void)dealloc
{
	[super dealloc];
}


- (NSString*)getChapterContent
{
	return [self getTestDataContent];
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

@end

