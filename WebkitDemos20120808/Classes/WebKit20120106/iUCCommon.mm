
//#include "stdafx.h"
//#import "iStdafxMM.h"

#import <UIKit/UIKit.h>
#import "iUCCommon.h"

// 一天多少秒
#define SECONDS_ONE_DAY     (24*60*60)


typedef	unsigned char 	BYTE;
#define GetBValueX(rgb)  ((BYTE)(rgb))
#define GetGValueX(rgb)  ((BYTE)(((unsigned short)(rgb)) >> 8))
#define GetRValueX(rgb)  ((BYTE)((rgb) >> 16))

//获取系统版本
float iUCCommon::iGetSystemVersion()
{
	static float versionValue = -1.0;
	if(versionValue < 0)
	{
		NSString *os_verson = [[UIDevice currentDevice] systemVersion];
		versionValue = [os_verson floatValue];
	}
	return versionValue;
}

iUCCommon::PLATFORM_TYPE iUCCommon::GetPlatform()
{
	static PLATFORM_TYPE platform = PLATFORM_UNKNOW;
	if(platform == PLATFORM_UNKNOW)
	{
		float version = iUCCommon::iGetSystemVersion();
		if(version < 2.0)
		{
			platform = PLATFORM_IPOHNE1;
		}
		else if(version < 3.0)
		{
			platform = PLATFORM_IPOHNE2;
		}
		else if(version < 4.0)
		{
			platform = PLATFORM_IPOHNE3;	
		}
		else if(version < 5.0)
		{
			platform = PLATFORM_IPOHNE4;	
		}
		else
		{
			platform = PLATFORM_IPOHNE5;	
		}
	}
	return platform;
}

// 获取当前年月日, 格林标准时间
void  iUCCommon::getCurDate(int& year,int& month, int& day)
{
//	tm *gmTime = gmtime(&tmNow);
	// 格林标准时间 gmTime 所对应的结构参数
//	int tm_sec;     /* seconds (0 - 60) */
//	int tm_min;     /* minutes (0 - 59) */
//	int tm_hour;    /* hours (0 - 23) */
//	int tm_mday;    /* day of month (1 - 31) */
//	int tm_mon;     /* month of year (0 - 11) */
//	int tm_year;    /* year - 1900 */
//	int tm_wday;    /* day of week (Sunday = 0) */
//	int tm_yday;    /* day of year (0 - 365) */
//	int tm_isdst;   /* is summer time in effect? */
//	char *tm_zone;  /* abbreviation of timezone name */
//	long tm_gmtoff; /* offset from UTC in seconds */
	
	time_t tmNow;
	time(&tmNow);
	//tm *sysTime = localtime(&tmNow); // 本地时间
	tm *gmTime = gmtime(&tmNow); // 使用世界标准时间
	if (gmTime != nil)
	{
		year = gmTime->tm_year + 1900;
		month = gmTime->tm_mon + 1;
		day = gmTime->tm_mday;
	}
}

// 判断是否为闰年
int iUCCommon::isLeap(int year)
{
	return ( (year%400==0) || (year%4==0 && year%100!=0));
}

// 从指定年月日到当前的秒数
// year: 指定年份不大于当前年份
unsigned int iUCCommon::getDaysFromYMD(int year, int month, int day)
{
	int nNowYear, nNowMonth, nNowDay;
	//iGetCurDate(&nNowYear, &nNowMonth, &nNowDay);
	iUCCommon::getCurDate(nNowYear, nNowMonth, nNowDay);
	
	//=====================================================
	// 参数修正
	
	if(year > nNowYear)
	{
		year = 1970;
	}
	// 调整月份
	if(month <1 || month >12)
	{
		month = 1;
	}
	
	int month_day[13] = {0, 31,28,31,30,31,30,31,31,30,31,30,31};
	
	if (isLeap(year))
	{
		month_day[2] = 29;
	}
	// 调整日期
	if (day < 1 || day > month_day[month])
	{
		day = 1;
	}
	
	//=====================================================
	// 计算天数
	// 当前年份中二月份天数
	if (isLeap(nNowYear))
	{
		month_day[2] = 29;
	}
	
	unsigned int nDays = 0;
	int i=0;
	for (i = year; i<nNowYear; i++)
	{
		nDays += isLeap(i) ? 366 : 365;
	}
	for (i = month; i< nNowMonth; i++)
	{
		nDays += month_day[i];
	}
	nDays += nNowDay-1;
	
	return nDays;
}

// 从指定年月日到当前的秒数
//unsigned long iUCCommon::getSecondsFromYMD(int year, int month, int day)
//{
//	unsigned int nDays = iUCCommon::getDaysFromYMD(year, month, day);
//	unsigned long nSeconds = SECONDS_ONE_DAY*nDays;
//	
//	time_t tmNow;
//	time(&tmNow);
//	//tm *sysTime = localtime(&tmNow); // 本地时间
//	tm *gmTime = gmtime(&tmNow); // 使用世界标准时间
//	nSeconds = nSeconds+gmTime->tm_hour*60*60
//	+gmTime->tm_min*60
//	+gmTime->tm_sec;
//	return nSeconds;
//}

// 获取从1970年1月1日0点到现在的秒数
unsigned long iUCCommon::getSecondsFrom19700101()
{
	time_t tmNow;
	time(&tmNow);
	
	return tmNow;
}

//==========================================================
// add by yangfs 2011-08-09 for RQ008322 多窗口改造
//#define GetBValueX(rgb)  ((BYTE)(rgb))
//#define GetGValueX(rgb)  ((BYTE)(((WORD)(rgb)) >> 8))
//#define GetRValueX(rgb)  ((BYTE)((rgb) >> 16))
// fAlpha:[0.0f, 1.0f]
void iUCCommon::setColor(float pColol[4], unsigned int nRGB, float fAlpha)
{
	pColol[0] = GetRValueX(nRGB)/255.0f;
	pColol[1] = GetGValueX(nRGB)/255.0f;
	pColol[2] = GetBValueX(nRGB)/255.0f;
	pColol[3] = fAlpha;//GetBValue
}

void iUCCommon::testMCDAD(void*adlist, unsigned long nSeconds)
{//
//#define COM_AD_TEST_MACRO
//#ifdef COM_AD_TEST_MACRO
//	MCDADList *pList = (MCDADList *)adlist;
//	NSDate* pNowDate = [NSDate date];
//	COM_LOG_NSLOG(@"pNowDate=%@", pNowDate);
//	NSTimeInterval nTempTime = [pNowDate timeIntervalSince1970];
//	
//	NSDate* pDate = [NSDate dateWithTimeIntervalSince1970:nSeconds];
//	COM_LOG_NSLOG(@"pDate=%@", pDate);
//	
//	unsigned long nTestSeconds = iUCCommon::getSecondsFrom19700101();
//	pDate = [NSDate dateWithTimeIntervalSince1970:nTestSeconds];
//	COM_LOG_NSLOG(@"pDate=%@", pDate);
//	
//	pDate = [NSDate dateWithTimeIntervalSince1970:1315477674];
//	COM_LOG_NSLOG(@"pDate=%@", pDate);
//	
//	
//	
//	//MCDADList *adlist;
//	if (pList != NULL)
//	{
//		NSDate* pDate = nil;
//		NSMutableString* pStrTemp = [[NSMutableString alloc] initWithFormat:@"=="];
//		MCDADListItem *al = NULL;
//		int nCount = pList->count();
//		int i=0;
//		for (i=0; i<nCount; i++)
//		{
//			al=pList->get(i);
//			// 这里会有一个时间差:世界时间与本地时间相差8小时
//			pDate = [NSDate dateWithTimeIntervalSince1970:al->offTime];
//			[pStrTemp setString:@"off date="];
//			[pStrTemp appendFormat:@"%@", pDate];
//			CString strTemp = MEncode::A2U([pStrTemp UTF8String]);
//			
//			COM_LOG_LOGW(L"\n[%d] name=%s\nurl=%s\noffTime=%d\n %s\n\n", i+1, (LPCTSTR)al->name, (LPCTSTR)al->url, al->offTime, (LPCTSTR)strTemp);
//			
//			COM_LOG_NSLOG(@"pDate=%@\n\n", pDate);
//		}
//		[pStrTemp release];
//	}
//#endif // #ifdef COM_AD_TEST_MACRO
}

// 由buffer提供图片数据创建UIImage图片
// 需要由调用者来release创建的对象
void* iUCCommon::CreadNewImage(const void *bytes, unsigned int length)
{
	UIImage *image=nil;
	if(bytes != nil && length > 0)
	{
		//anthzhu modifies for 2x engine icon display
		UIScreen* screen = [UIScreen mainScreen];
		screen = nil;
		NSData* data = [NSData dataWithBytes:bytes length:length];
#ifdef UC_VER_IPHONE_4			
		if([screen respondsToSelector:@selector(scale)]&&([screen scale]>1.0 ))
		{
			UIImage* origImage;
			origImage = [[UIImage alloc] initWithData:data];
			image = [[UIImage alloc] initWithCGImage:origImage.CGImage scale:[screen scale] orientation:UIImageOrientationUp];
			[origImage release];
		}
		else
#endif				
		{
			image = [[UIImage alloc] initWithData:data];
		}
	}
	
	return (void*)image;
}
