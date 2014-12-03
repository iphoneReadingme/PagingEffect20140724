
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "BookLayoutConfig.h"
#import "DemoViewSimpleParagraph.h"
#import "DemoViewCoreTextDrawMacroDefine.h"
#import "PageSplitRender.h"


#define			FONTNAME			@"STHeitiSC-Light"

///< 私有方法
@interface DemoViewSimpleParagraph (/*DemoViewCALayer_Private*/)
{
	
}

- (void)addSomeViews:(CGRect)frame;
- (void)forTest;
- (void)releaseObject;

@end

// =================================================================
#pragma mark-
#pragma mark UIAppFSIconView实现

@implementation DemoViewSimpleParagraph


- (void)forTest
{
	// for test
//	self.backgroundColor = [UIColor brownColor];
	self.layer.borderWidth = 4;
	self.layer.borderColor = [UIColor colorWithRed:0.0 green:0 blue:1.0 alpha:1.0].CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
		[self forTest];
		self.backgroundColor = [UIColor grayColor];
		[self addSomeViews:[self bounds]];
		
    }
    return self;
}

- (void)dealloc
{
	[self releaseObject];
    
    [super dealloc];
}

-(void)releaseObject
{
	self.layoutConfig = nil;
}

// =================================================================
#pragma mark- == 边框圆角半径 设置层的背景颜色，层的设置圆角半径为20

- (BOOL)isPortraitScreen    ///< 是否竖屏
{
	UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationIsPortrait(statusBarOrientation);
	
	//CGRect bounds = [UIGlobal getMainBounds];
	//return (bounds.size.height > bounds.size.width);
}

// =================================================================

- (void)addSomeViews:(CGRect)frame
{
//	[self addButtons];
}


// =================================================================
#pragma mark-
#pragma mark 动画结束



// =================================================================
#pragma mark- == Core Animation之多种动画效果
// 1、把图片移到右下角变小透明
// =================================================================
#pragma mark-
#pragma mark 创建按钮

- (UIButton*)createButton:(int)nTag withName:(NSString*)pStrName withTitle:(NSString*)pTitle
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
	[button addTarget:self action:@selector(onButtonClickEvent:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = nTag;
	button.accessibilityLabel = pStrName;
	[button setTitle:pTitle forState:UIControlStateNormal];
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	
//	[self addSubview:button];
	//[button retain];
	
	return button;
}

- (void)addButtons
{
	CGRect frame = [self bounds];
	CGRect btnRect = CGRectMake(0, 0, 100, 64);
	btnRect.origin.x = frame.size.width - btnRect.size.width;
	int nIndex = 0;
	UIButton* pBtn = nil;
	
	// "把图片移到右下角变小透明"按钮
	pBtn = [self createButton:nIndex withName:@"UIButtonTest1" withTitle:@"返回"];
	[pBtn setFrame:btnRect];
	[self addSubview:pBtn];
}

- (void)onButtonClickEvent:(UIButton*)sender
{
	if ([[self superview] respondsToSelector:@selector(onButtonBack)])
	{
		[[self superview] performSelector:@selector(onButtonBack)];
	}
}

#define kChapterNameText  @"第一章节　章节标题名"
- (void)drawRect:(CGRect)rect
{
	NSString* pageText = @"2013-11-29 绘制文字 \
	2013-11-29 11:58:26.476 NovelTest[1742:1403] (\
												  \"<PageItem: 0x8937330>\",\
												  \"<PageItem: 0x8935c60>\",\
												  \"<PageItem: 0x8935a20>\",\
												  \"<PageItem: 0x8935c40>\",\
												  \"<PageItem: 0x8935a50>\",\
												  \"<PageItem: 0x8936280>\",\
												  \"<PageItem: 0x8933300>\",\
												  \"<PageItem: 0x8934180>\",\
												  \"<PageItem: 0x892f3c0>\"\
												  )";
	
	NSString* srcText =  @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 2、生成一个CTFramesetterRef对象，然后创建一个CGPath对象，这个Path对象用于表示可绘制区域坐标值、长宽。 3、使用上面生成的setter和path生成一个CTFrameRef对象，这个对象包含了这两个对象的信息（字体信息、坐标信息），它就可以使用CTFrameDraw方法绘制了。";
	NSString *src = @"据市通信管理局介绍，一些房产推销、办班培训等机构通过本地106×××××行业短信端口发送商业短信，上海移动、电信、联通手机用户今后收到这类短信，只需要回复“0000”，就可以拒收本地端口号码发出的短信。这项“一键退订”将对扰民广告短信产业链予以致命打击。\
	各类垃圾短信扰民问题令人痛恶，既侵害用户权益，也破坏电信消费环境，还消耗运营商通信网络资源。据全国12321网络不良与垃圾信息举报受理中心统计，10月份全国用户投诉垃圾短信中，“零售业推销”占比33.4%，“房地产推销”占比32.1%，“办班培训”占比11.8%。市通信管理局对症下药地实施“一键退订”，对移动、电信、联通电信运营商屏蔽垃圾短信方式作出统一规定。3家电信运营商现已承诺，只要手机用户启用“一键退订”功能，这个本地号码段短信息的屏蔽功能即刻生效，这将加大针对垃圾短信的遏制力度。例如，对上海移动公司测试数据分析，在沪测试的“一键退订”方式，已累计为用户永久屏蔽本地106×××××行业短信端口超过16万次。\
	为避免用户误将一些有用的商业短信拒收，“一键退订”拒收目标主要锁定在向用户发送短信息的最长延伸位本地106×××××行业短信端口号码，旨在精准拒收。用户在回复“0000”后，即永久拒收该号码发出的任意短信，而不影响相同端口原始号码发送的其他对账、确认等商业短信息业务的使用，完全将上海本地的行业短信息的接收选择权交给了市民。市通信管理局在实施“一键退订”的同时，将继续强化各类监管机制，使上海成为国内首个将商业短信接收选择权交给广大市民的城市。";
	pageText = [NSString stringWithFormat:@"%@\n    %@", srcText, src];
    
	int nFontSize = _layoutConfig.fontSize;
	
	// Initialize a graphics context in iOS.
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawInContext:context withRect:rect font:nFontSize withText:pageText];
}

- (CGFloat)getLineSpace
{
	CGFloat lineSpace = 4.0f;
	
	return lineSpace;
}

///< 返回当前章节显示的文本内容（上下翻页时第一页面带章节标题名）
- (NSString*)getShowTextOfChapter:(NSString *)contentStr withChapterItem:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config
{
	BOOL bShowTitle = (config.showBigTitle && [chapterName length] > 0);   ///< 文字排版时是否显示标题
	
	NSString* chapterText = contentStr;
	if (bShowTitle)
	{
		chapterText = [NSString stringWithFormat:@"%@\n\n%@", chapterName, contentStr];
	}
	
	return chapterText;
}

/*格式化绘画样式*/
- (CTFramesetterRef)formatString:(NSString *)contentStr size:(CGFloat)fontSize chapName:(NSString*)chapterName andLayoutConfig:(BookLayoutConfig*)config
{
	if (config == nil || ([contentStr length] < 1))
	{
		return nil;
	}
	CTFramesetterRef framesetter = nil;
//	framesetter = [PageSplitRender formatString:contentStr withChapterName:chapterName andLayoutConfig:self.layoutConfig];
	
	return 	framesetter;
}

- (void)drawInContext:(CGContextRef)context withRect:(CGRect)rect font:(int)fontSize withText:(NSString*)pageContent
{
	if ([pageContent length] < 1)
	{
		return;
	}
    //assert(CGSizeEqualToSize(rect.size, CGSizeMake(self.layoutConfig.pageWidth, self.layoutConfig.pageHeight)));
	
	//CGAffineTransform originTF = CGContextGetCTM(context); // for test 变换矩阵
	//originTF = CGAffineTransformIdentity;
	//翻转坐标系统（文本原来是倒的要翻转下）
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
    //originTF = CGContextGetCTM(context); // for test 变换矩阵
	// In this simple example, initialize a rectangular path.
	//CGRect bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
	//CGPathAddRect(path, &CGAffineTransformIdentity, bounds );
	
	// 由于在绘制文字时, 坐标系会沿X轴发生翻转, 故Y方向需要调换
	UIEdgeInsets edgeInsets = self.layoutConfig.contentInset;
	edgeInsets.top = self.layoutConfig.contentInset.bottom;
	edgeInsets.bottom = self.layoutConfig.contentInset.top;
	
    CGRect columnFrame = rect;
//    columnFrame.size = CGSizeMake(self.layoutConfig.pageWidth, self.layoutConfig.pageHeight);
    columnFrame.size = CGSizeMake(rect.size.width, rect.size.height);
    columnFrame = UIEdgeInsetsInsetRect(columnFrame, edgeInsets);
	
	// In this simple example, initialize a rectangular path.
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
	
    CTFramesetterRef framesetter = nil;
	framesetter = [self formatString:pageContent size:fontSize chapName:kChapterNameText andLayoutConfig:_layoutConfig];
	
    CTFrameRef contentFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), framePath, NULL);
    CTFrameDraw(contentFrame, context);
	
    CFRelease(contentFrame);
	CFRelease(framesetter);
    CFRelease(framePath);
}

//CTFrameRef contentFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), framePath, NULL);

- (void)drawRect:(CGContextRef)context withRect:(CGRect)rect
{
	//翻转坐标系统（文本原来是倒的要翻转下）
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	NSString* contentStr =  @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。…";
	
	NSMutableAttributedString *attributedString = [[[NSMutableAttributedString alloc] initWithString:contentStr] autorelease];
	
	//设置对齐方式、行间距、首行缩进
	CTTextAlignment textAlignment = kCTLeftTextAlignment;
	CGFloat lineSpace = 4.0f;
	CGFloat paragraphSpacing = 10.0f;
	CGFloat headIndent = 0.0f;
	//创建设置数组
	CTParagraphStyleSetting settings[] = {
		// 设置文本对齐方式
		{ kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment },
		// 设置文本行间距
		{ kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(lineSpace), &lineSpace },
		// 设置文本段间距
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(paragraphSpacing), &paragraphSpacing },
		// 设置段前间距
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(paragraphSpacing), &paragraphSpacing },
		// 设置首行缩进
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(headIndent), &headIndent }
	};
	// 通过设置项产生段落样式对象
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings , sizeof(settings)/sizeof(CTParagraphStyleSetting));
	CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attributedString, CFRangeMake(0, [contentStr length]), kCTParagraphStyleAttributeName, paragraphStyle);
	CFRelease(paragraphStyle);
	
	CGRect columnFrame = rect;
	columnFrame.size = CGSizeMake(self.layoutConfig.pageWidth, self.layoutConfig.pageHeight);
	//columnFrame = UIEdgeInsetsInsetRect(columnFrame, edgeInsets);
	CGMutablePathRef framePath = CGPathCreateMutable();
	CGPathAddRect(framePath, &CGAffineTransformIdentity, columnFrame);
	
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attributedString);
	CTFrameRef contentFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), framePath, NULL);
	CTFrameDraw(contentFrame, context);
	
	CFRelease(framesetter);
	CFRelease(contentFrame);
	CFRelease(framePath);
}

@end


#if 0

http://blog.csdn.net/fengsh998/article/details/8700627
http://www.padovo.com/blog/2013/01/31/study-coretext/

//CTParagraphStyleSpecifier
kCTParagraphStyleSpecifierAlignment = 0,                 //对齐属性
kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,       //首行缩进
kCTParagraphStyleSpecifierHeadIndent = 2,                //段头缩进
kCTParagraphStyleSpecifierTailIndent = 3,                //段尾缩进
kCTParagraphStyleSpecifierTabStops = 4,                  //制表符模式
kCTParagraphStyleSpecifierDefaultTabInterval = 5,        //默认tab间隔
kCTParagraphStyleSpecifierLineBreakMode = 6,             //换行模式
kCTParagraphStyleSpecifierLineHeightMultiple = 7,        //多行高
kCTParagraphStyleSpecifierMaximumLineHeight = 8,         //最大行高
kCTParagraphStyleSpecifierMinimumLineHeight = 9,         //最小行高
kCTParagraphStyleSpecifierLineSpacing = 10,              //行距
kCTParagraphStyleSpecifierParagraphSpacing = 11,         //段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,   //段落前间距 在一个段落的前面加上间隔。TOP
kCTParagraphStyleSpecifierBaseWritingDirection = 13,     //基本书写方向
kCTParagraphStyleSpecifierMaximumLineSpacing = 14,       //最大行距
kCTParagraphStyleSpecifierMinimumLineSpacing = 15,       //最小行距
kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,    //行距调整
kCTParagraphStyleSpecifierCount = 17,        //

对齐属性：
kCTLeftTextAlignment = 0,                //左对齐
kCTRightTextAlignment = 1,               //右对齐
kCTCenterTextAlignment = 2,              //居中对齐
kCTJustifiedTextAlignment = 3,           //文本对齐
kCTNaturalTextAlignment = 4              //自然文本对齐
段落默认样式为
kCTNaturalTextAlignment

kCTParagraphStyleSpecifierParagraphSpacingBefore
段前间距设置代码（段与段之间）：

基本书写方向代码：
kCTParagraphStyleSpecifierBaseWritingDirection
kCTWritingDirectionNatural = -1,            //普通书写方向，一般习惯是从左到右写
kCTWritingDirectionLeftToRight = 0,         //从左到右写
kCTWritingDirectionRightToLeft = 1          //从右到左写

#endif

