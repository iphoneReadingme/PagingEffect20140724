
#import <AddressBook/AddressBook.h>
#import "DemoIphoneNumberHelper.h"


const NSString* kKeyPersonName = @"PersonName";
const NSString* kKeyPersonFirst = @"PersonFirst";
const NSString* kKeyPersonLast = @"PersonLast";
const NSString* kKeyTelphone = @"telphone";
const NSString* kKeyNote = @"note"; ///< 备注
const NSString* kKeyCreationDate = @"CreationDate"; ///< 创建时间





NSString* g_pPersonNumber[][2] =
{
	// 2011-2-7
	@"陈泓坤", @"13556101008",
	@"陈老根", @"18662528956",
	@"陈勇生", @"18720090592",
	@"W陈能发", @"13697445769",
	@"W陈士彪", @"13688967176",
	@"W陈晓芬", @"13651915686",
	@"W陈夏洋", @"13826022299",
	@"W陈业达", @"13580451518",
	@"W陈有军", @"13879787290",
	@"大  姐", @"15170679622",
	@"戴家宝", @"13580542999",
	@"W丁金明", @"13767003527",
	@"W高  洁", @"13631437442",
	@"W郭  凤", @"13570982898",
	@"郭伟红", @"13910060679",
	@"洪先生", @"13560392594",
	@"胡师傅", @"13212670256",
	@"候  亮", @"13560446038",
	@"胡晶晶", @"13570203686",
	@"胡琼艳", @"13423633152",
	@"胡琼艳2", @"13410799112",
	@"胡永祥", @"15970233745",
	@"黄传坤", @"18296942899",
	@"黄春林", @"13675985926",
	@"黄道生", @"18907063270",
	@"黄海军", @"13802432764",
	@"晋冬冬", @"113632257428",
	@"江锋权", @"13610273181",
	@"姜来胜", @"13967423073",
	@"菊  根", @"13736270816",
	@"康  珍", @"13928878061",
	@"黎春兰", @"13767709619",
	@"李贱苟", @"13538424765",
	@"李桑子", @"13617966379",
	@"李小勇", @"18970746948",
	@"李头勇", @"13957184045",
	@"李玉娟", @"13450232358",
	@"李小群", @"15179621024",
	@"李高红", @"13659763332",
	@"李胤霆", @"13178839061",
	@"李  莹", @"13580503639",
	@"梁  飞", @"13326469906",
	@"梁  坚", @"13907066961",
	@"梁  坚", @"3529367",
	@"梁  坚", @"3534179",
	@"梁  明", @"13928843221",
	@"梁  明", @"18926128852",
	@"梁细英", @"07963303492",
	@"梁细英", @"3520395",
	@"梁  霞", @"07968876250",
	@"梁  勇", @"15949678962",
	@"林  宇", @"18620879394",
	@"廖远见", @"13585209949",
	@"林日根", @"13826152648",
	@"刘爱平", @"18688723932",
	@"刘爱平", @"15002081426",
	@"刘  俊", @"13042005118",
	@"刘秋华", @"13517068740",
	@"刘秋华", @"07963511142",
	@"刘秋芸", @"13710901503",
	@"刘秋芸", @"13590251873",
	@"刘  强", @"13979641605",
	@"娄底汽车1", @"15079699588",
	@"娄底汽车2", @"13879622211",
	@"柳  根", @"13676649795",
	@"罗红平", @"13534851317",
	@"罗红平", @"13970623632",
	@"罗伟伟", @"15264955923",
	@"三女表姐", @"3251138",
	@"上  官", @"13794303390",
	@"佘君霞", @"13538757433",
	@"杨四仔姑妈", @"3467173",
	@"宋小龙", @"18620073029",
	@"孙联刚", @"13879687947",
	@"谭小刚", @"13570234607",
	@"唐建雄", @"13636461668",
	@"王文丽", @"13631439380",
	@"王显锋", @"13650767850",
	@"韦佩丛", @"15977161953",
	@"韦佩丛", @"13725170181",
	@"温南城", @"13416188668",
	@"吴  君", @"13761095951",
	@"吴细平", @"13450228453",
	@"肖  玲", @"13725173157",
	@"肖清花", @"13117977149",
	@"肖夏荣", @"13970684142",
	@"谢继成", @"15919989775",
	@"谢继成", @"15919989775",
	@"谢小姐", @"13807059388",
	@"谢房东", @"13168894075",
	@"谢房东", @"13640257070",
	@"谢桂冠", @"13710692627",
	@"严宗清", @"13414835720",
	@"严英洲", @"13751168163",
	@"尹显用", @"13710985633",
	@"杨春蓉", @"13970497586",
	@"杨冬生", @"13552379850",
	@"杨二生", @"13479616375",
	@"杨发根", @"13755421111",
	@"杨凤生", @"13710375386",
	@"杨福康", @"07963536267",
	@"杨桂喜", @"18779647882",
	@"杨金平", @"13416963298",
	@"杨  坤", @"13751754615",
	@"杨木根", @"13428517178",
	@"杨清香", @"15070692416",
	@"杨生苟", @"18664816881",
	@"杨圣生", @"15079696491",
	@"杨书记", @"13755402958",
	@"杨淑明", @"15861148011",
	@"杨苏英", @"13427810998",
	@"杨头生", @"13805976978",
	@"杨  家", @"07963465073",
	@"杨  家1", @"15949676723",
	@"杨二生", @"13576614175",
	@"杨头水", @"13602345108",
	@"杨伟1", @"13827244360",
	@"杨伟2", @"13636977073",
	@"杨晓军", @"13767656257",
	@"杨艳根", @"15914132819",
	@"袁  家", @"13437068451",
	@"袁丈人", @"18270966793",
	@"袁崇武", @"15970000085",
	@"袁苹苹", @"13873166803",
	@"袁苹苹娄底", @"18679731903",
	@"袁苹苹2", @"15197816630",
	@"袁蓉蓉", @"15919749006",
	@"袁三喜", @"13718814327",
	@"袁玉兰", @"13979689616",
	@"五花", @"15859526159",
	@"曾东明", @"15819342177",
	@"曾东明", @"13544503168",
	@"曾建莉", @"13907918469",
	@"曾建勇", @"13970465767",
	@"曾勇忠", @"13766294927",
	@"张  叔", @"15013339368",
	@"张军2", @"13922408084",
	@"张  巍", @"13421618697",
	@"张颖泉", @"13826189768",
	@"张遇仙", @"13642636190",
	@"张德顺", @"13824465620",
	@"赵永彬", @"15920885850",
	@"郑洁纯", @"13427533880",
	@"周玲平", @"13766298067",
	@"周留井", @"15913162935",
	@"周小姐", @"15674604750",
	@"朱小华", @"13719029665",
	@"朱玉凤", @"13119517716",
	@"朱  伟", @"13822152168",
	@"朱 伟X", @"15914545585",
	@"祝讨平", @"13925237432",
	nil, nil,
};

///< 私有方法
@interface DemoIphoneNumberHelper()


@end

@implementation DemoIphoneNumberHelper


+ (NSString *)displayName {
	return @"2015-03-11读写电话号码 demo";
}

// =================================================================
#pragma mark -
#pragma mark 子视图对象
+ (ABAddressBookRef)getAddressBook
{
	ABAddressBookRef addressBook = nil;
	
//	if (addressBook)
//	{
//		return addressBook;
//	}
	// 如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
	{
		addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
		//等待同意后向下执行
		dispatch_semaphore_t sema = dispatch_semaphore_create(0);
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
												 {
													 dispatch_semaphore_signal(sema);
												 });
		dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
		dispatch_release(sema);
	}
	else
	{
		addressBook = ABAddressBookCreateWithOptions(nil, nil);
	}
	
	return addressBook;
}

+ (void)clearAllPersons
{
	ABAddressBookRef addressBook = [self getAddressBook];
	
	if (addressBook)
	{
		CFErrorRef error;
		CFArrayRef records = nil;
		
		// 获取通讯录中全部联系人
		records = ABAddressBookCopyArrayOfAllPeople(addressBook);
		NSInteger nCount = (NSInteger)CFArrayGetCount(records);
		
		for(int i = 0; i < nCount; i++)
		{
			ABRecordRef person = CFArrayGetValueAtIndex(records, i);
			
			BOOL success = (BOOL)ABAddressBookRemoveRecord(addressBook, person, &error);
			if (success)
			{
				NSMutableDictionary* dict = [DemoIphoneNumberHelper getOnePersonInfo:person];
				if (dict)
				{
#ifdef DEBUG
					NSLog(@"%@, %@", [dict objectForKey:kKeyPersonName], [dict objectForKey:kKeyTelphone]);
#endif
				}
			}
		}
		ABAddressBookSave(addressBook, &error);
		
		if (records)
		{
			CFRelease(records);//new
		}
		CFRelease(addressBook);//new
	}
}

+ (void)addPersons
{
	ABAddressBookRef addressBook = [self getAddressBook];
	if (addressBook)
	{
		NSInteger i = 0;
		while (g_pPersonNumber[i][0] != nil)
		{
			NSString* name = g_pPersonNumber[i][0];
			NSString* phoneNumber = g_pPersonNumber[i][1];
			NSString* iphoneLabel=  @"手机";
			[DemoIphoneNumberHelper addContactName:name phoneNum:phoneNumber withLabel:iphoneLabel with:addressBook];
			
			i++;
		}
		
		// 如果添加记录成功，保存更新到通讯录数据库中
		CFErrorRef error;
		ABAddressBookSave(addressBook, &error);
		
		CFRelease(addressBook);//new
	}
}

#pragma  mark 添加联系人
// 添加联系人（联系人名称、号码、号码备注标签）
+ (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)phoneNum withLabel:(NSString*)label with:(ABAddressBookRef)addressBook
{
	// 创建一条空的联系人
	ABRecordRef personSecord = ABPersonCreate();
	CFErrorRef error;
	
	// 设置联系人的名字
	ABRecordSetValue(personSecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
	[DemoIphoneNumberHelper addValueAndLabel:personSecord value:phoneNum  withLabel:label with:kABPersonPhoneProperty];
	
	NSString* textNote=  @"2015-03-11 添加";
	ABRecordSetValue(personSecord, kABPersonNoteProperty, (__bridge CFTypeRef)textNote, &error);
	
	// 将新建联系人记录添加入通讯录中
	BOOL success = (BOOL)ABAddressBookAddRecord(addressBook, personSecord, &error);
	if (!success)
	{
		return NO;
	}
	else
	{
		// 如果添加记录成功，保存更新到通讯录数据库中
//		success = (BOOL)ABAddressBookSave(addressBook, &error);
	}
	
	if (personSecord)
	{
		CFRelease(personSecord);//new
	}
	
	return success;
}

///< 多信息添加接口
+ (void)addValueAndLabel:(ABRecordRef)personSecord value:(NSString*)value withLabel:(NSString*)label with:(ABPropertyID)property
{
	// 添加联系人电话号码以及该号码对应的标签名
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(property);
	if (multi)
	{
		bool bAdd = ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)value, (__bridge CFStringRef)label, NULL);
		if (bAdd)
		{
			CFErrorRef error;
			///< Generic phone number - kABMultiStringPropertyType
			ABRecordSetValue(personSecord, kABPersonPhoneProperty, multi, &error);
		}
		
		CFRelease(multi);//new
	}
}

// =================================================================
#pragma mark - ==
+ (NSMutableArray*)readPersons
{
	NSMutableArray* personArray = [NSMutableArray arrayWithCapacity:1];
	
	ABAddressBookRef addressBook = [self getAddressBook];
	
	if (addressBook)
	{
		CFArrayRef records = nil;
		
		// 获取通讯录中全部联系人
		records = ABAddressBookCopyArrayOfAllPeople(addressBook);
		NSInteger nCount = (NSInteger)CFArrayGetCount(records);
		
		for(int i = 0; i < nCount; i++)
		{
			ABRecordRef person = CFArrayGetValueAtIndex(records, i);
			NSMutableDictionary* dict = [DemoIphoneNumberHelper getOnePersonInfo:person];
			if ([dict count] > 0)
			{
				[personArray addObject:dict];
			}
		}
		
		if (records)
		{
			CFRelease(records);//new
		}
		CFRelease(addressBook);//new
	}
	else
	{
#ifdef DEBUG
		NSLog(@"can not connect to address book");
#endif
	}
	
	return personArray;
}

+ (NSMutableDictionary*)getOnePersonInfo:(ABRecordRef)recordPerson
{
//	NSMutableDictionary* personDict = [NSMutableDictionary dictionaryWithObject:nil forKey:nil];
	NSMutableDictionary *personDict = [NSMutableDictionary dictionaryWithCapacity:0];
	//读取firstname
	NSString *first = (NSString*)ABRecordCopyValue(recordPerson, kABPersonFirstNameProperty);
	if (first==nil) {
		first = @" ";
	}
	[personDict setObject:first forKey:kKeyPersonFirst];
	
	NSString *last = (NSString *)ABRecordCopyValue(recordPerson, kABPersonLastNameProperty);
	if (last == nil) {
		last = @" ";
	}
	[personDict setObject:last forKey:kKeyPersonLast];
	
	NSString* personName = [NSString stringWithFormat:@"%@ %@", first, last];
	[personDict setObject:personName forKey:kKeyPersonName];
	
	ABMultiValueRef tmlphone =  ABRecordCopyValue(recordPerson, kABPersonPhoneProperty);
	NSString* telphone = (NSString*)ABMultiValueCopyValueAtIndex(tmlphone, 0);
	if (telphone == nil) {
		telphone = @" ";
	}
	[personDict setObject:telphone forKey:kKeyTelphone];
	CFRelease(tmlphone);
	
	//读取note备忘录
	NSString *note = (NSString*)ABRecordCopyValue(recordPerson, kABPersonNoteProperty);
	if(note != nil)
	{
		[personDict setObject:note forKey:kKeyNote];
	}
	//第一次添加该条记录的时间
	NSString *firstknow = (NSString*)ABRecordCopyValue(recordPerson, kABPersonCreationDateProperty);
	if(firstknow != nil)
	{
		//NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
		[personDict setObject:firstknow forKey:kKeyCreationDate];
	}
	//最后一次修改該条记录的时间
	
	if ([personDict count] < 1)
	{
		personDict = nil;
	}
	
	return personDict;
}

@end

