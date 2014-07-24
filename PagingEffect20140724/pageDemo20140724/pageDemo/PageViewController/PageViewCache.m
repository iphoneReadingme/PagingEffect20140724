/**
 *****************************************************************************
 * Copyright    :  (C) 2008-2013 UC Mobile Limited. All Rights Reserved
 * File         :  PageViewCache.m
 * Description	:  PageView缓存
 * Author       :  yuping@ucweb.com
 * History      :  Creation, 2013/11/23, yuping, Create the file
 ******************************************************************************
 **/


#import "PageViewCache.h"
#import "PageView.h"
//#import "NovelBoxMacroDefine.h"


#define PAGECACHE_MAX   3

@interface PageViewCache ()

@property (readonly) NSMutableArray* pageCache;

@end

@implementation PageViewCache

- (id)initWithPageSize:(CGSize)aPageSize
{
	if (self = [super init])
    {
		_pageSize = aPageSize;
		_pageCache = [[NSMutableArray alloc] init];
	}
    
	return self;
}

- (void)dealloc
{
	[_pageCache release];
    _pageCache = nil;
    
	[super dealloc];
}

- (CGImageRef)imageForPageIndex:(NSUInteger)pageIndex chapterIndex:(NSInteger)chapterIndex
{
    if (CGSizeEqualToSize(self.pageSize, CGSizeZero))
    {
        return NULL;
    }
    
    float scale = 1;
	UIScreen* screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
	{
		scale = [screen scale];
	}
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, 
												 ceilf(self.pageSize.width * scale),
												 ceilf(self.pageSize.height * scale),
												 8,
												 0,
												 colorSpace, 
												 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
	CGColorSpaceRelease(colorSpace);
    
    ///< 和很多底层API一样，CoreText使用Y翻转坐标系统，需要使用这三行代码完成坐标系转换
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextScaleCTM(context, 1.0 * scale, -1.0 * scale);
    CGContextTranslateCTM(context, 0, -self.pageSize.height);
	BOOL renderSuccess = [self.dataSource renderPageAtIndex:pageIndex atChapterIndex:chapterIndex inContext:context];
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	[UIImage imageWithCGImage:image];
	CGImageRelease(image);
	
	return renderSuccess ? image : nil;
}

- (CGImageRef)cachedImageForPageIndex:(NSUInteger)pageIndex chapterIndex:(NSUInteger)chapterIndex
{
    NSString* keyString = [NSString stringWithFormat:@"%d/%d", chapterIndex, pageIndex];
	UIImage* pageImage = [self getPageImageForKey:keyString];
    
	if (!pageImage)
    {
		CGImageRef pageCGImage = [self imageForPageIndex:pageIndex chapterIndex:chapterIndex];
        if (pageCGImage)
        {
            pageImage = [UIImage imageWithCGImage:pageCGImage];
            @synchronized (self.pageCache)
            {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:pageImage, keyString, nil];
                [self.pageCache addObject:dict];
                [self minimizePageImageCache];
            }
        }
	}
    
	return pageImage.CGImage;
}

- (void)precacheImageForPageIndexNumber:(NSDictionary*)dict
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSNumber* chapterNumber = [dict objectForKey:CHAPTERINDEX_KEY];
    NSNumber* pageNumber = [dict objectForKey:PAGEINDEX_KEY];
	[self cachedImageForPageIndex:[pageNumber intValue] chapterIndex:[chapterNumber intValue]];
	[pool release];
}

- (void)precacheImageForPageIndex:(NSUInteger)pageIndex chapterIndex:(NSUInteger)chapterIndex
{
    NSNumber* chapterNumber = [NSNumber numberWithInt:chapterIndex];
    NSNumber* pageNumber = [NSNumber numberWithInt:pageIndex];
	[self performSelectorInBackground:@selector(precacheImageForPageIndexNumber:)
                           withObject:[NSDictionary dictionaryWithObjectsAndKeys:chapterNumber, CHAPTERINDEX_KEY, pageNumber, PAGEINDEX_KEY, nil]];
}

- (UIImage*)getPageImageForKey:(NSString*)keyString
{
    UIImage* image = nil;
    if (!keyString || _pageCache.count <= 0)
    {
        return nil;
    }
    
    for (NSDictionary* dict in _pageCache)
    {
        image = [dict objectForKey:keyString];
        if (image)
        {
            break;
        }
    }
    
    return image;
}

- (void)minimizePageImageCache
{
    if (_pageCache.count > 3)
    {
        [_pageCache removeObjectAtIndex:0];
    }
}

#pragma mark - accessors
- (void)setPageSize:(CGSize)value
{
//	NBMD_LOG_NSLOG(@" ==PageViewCache pageSize = [%@]", NSStringFromCGSize(value));
	_pageSize = value;
}

@end
