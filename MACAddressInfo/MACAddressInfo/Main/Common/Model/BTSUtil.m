//
//  BTSUtil.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSUtil.h"
#import "Common.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation BTSUtil

#pragma mark - 多语言

/** 系统当前的语言类型 */
+ (NSString *)systemCurrentLanguageCode {
    /**
     在"设置->通用->语言与地区->iPhone 语言"中更改语言后,获取的语言代码如下:
     en: 英文
     zh: 中文
     ja: 日文
     de: 德文
     fr: 法文
     ...
     */
    NSString *languageCode = nil; // 获取系统语言
    if (@available(iOS 10.0, *)) {
        languageCode = [NSLocale currentLocale].languageCode;
    } else {
        languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    }
#warning 暂时只显示中文版
    languageCode = @"zh";
    return languageCode;
}

/** App当前的语言类型 */
+ (NSString *)appCurrentLanguageCode {
    // 1. 读取本地存储的languageCode
    NSString *languageCode = [BTSUserDefaults objectForKey:UserDefaultsAppLanguageCodeKey];
#warning 暂时只显示中文版
    languageCode = @"zh";
    // 2. 如果本地存储的languageCode为nil,则表示跟随系统语言
    if (IS_NULL_STRING(languageCode)) {
        // 去获取系统当前的语言类型,作为App当前的语言类型
        languageCode = [self systemCurrentLanguageCode];
//        NSLog(@"系统当前的语言类型: %@", languageCode);
    }
    return languageCode;
}

/** 获取key对应的本地化字符串 */
+ (NSString *)localizedStringWithKey:(NSString *)key {
    NSString *appLanguageCode = [self appCurrentLanguageCode];
    NSString *stringsFileName = @"en";
    if ([appLanguageCode isEqualToString:@"en"]) {
        stringsFileName = @"en";
    } else if ([appLanguageCode isEqualToString:@"zh"]) {
        stringsFileName = @"zh-Hans";
    }

    NSString *stringsFilePath = [[NSBundle mainBundle] pathForResource:stringsFileName ofType:@"lproj"];
    NSString *localizedString = [[NSBundle bundleWithPath:stringsFilePath] localizedStringForKey:key value:nil table:@"BTSLocalizable"];
    return localizedString;
}


/**
 跳转到应用的系统设置页面
 */
+ (void)jumpToApplicationSettingPage {
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) { // iOS 10及其以后系统运行
        [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:settingURL];
    }
}


#pragma mark - 3D Touch

/** 检测3D Touch功能是否可用 */
+ (BOOL)check3DTouchAvailableWithObject:(id<UITraitEnvironment>)object {
    if (@available(iOS 9.0, *)) {
        if (object.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}


#pragma mark - 添加触感反馈

/**
 产生触感反馈效果
 
 @param style 触感反馈类型
 */
+ (void)generateImpactFeedbackWithStyle:(UIImpactFeedbackStyle)style {
    if (@available(iOS 10.0, *)) {
        // 触感反馈
        UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
        [feedbackGenerator prepare];
        [feedbackGenerator impactOccurred];
    }
}

/**
 产生触感反馈效果
 */
+ (void)generateImpactFeedback {
    [self generateImpactFeedbackWithStyle:UIImpactFeedbackStyleLight];
}


#pragma mark - 添加音效

/**
 使用系统声音服务播放指定的声音文件
 
 @param name 声音文件名称
 @param type 声音文件类型
 */
+ (void)playSoundEffect:(NSString *)name type:(NSString *)type {
    if (@available(iOS 9.0, *)) {
        // 1. 获取声音文件的路径
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
        // 将地址字符串转换成url
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        // 2. 生成系统音效ID
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFileURL, &soundID);
        // 3. 通过音效ID播放声音
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        });
    }
}

/**
 播放音效(七个基本音效)
 
 @param number 音效序号 (1~7对应:Do Re Mi Fa Sol La Si)
 */
+ (void)playMusicalNoteWithNumber:(NSInteger)number {
    if (number < 1 || number > 7) {
        return;
    }
    NSString *noteName = @"1_C_do";
    switch (number) {
            case 1:
            noteName = @"1_C_do";
            break;
            case 2:
            noteName = @"2_D_re";
            break;
            case 3:
            noteName = @"3_E_mi";
            break;
            case 4:
            noteName = @"4_F_fa";
            break;
            case 5:
            noteName = @"5_G_sol";
            break;
            case 6:
            noteName = @"6_A_la";
            break;
            case 7:
            noteName = @"7_B_si";
            break;
        default:
            break;
    }
    [BTSUtil playSoundEffect:noteName type:@"mp3"];
}


/** 从.txt文件中解析OUI数据 */
+ (void)loadOUIDataFromTxt {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"oui" ofType:@"txt"];
    NSString *txtContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [txtContent componentsSeparatedByString:@"\r\n"];
    if (arr.count < 4) {
        return;
    }
    
    // 从第四行开始为有效数据
    int lineOne = 1;
    int lineTwo = 2;
    int lineThree = 3;
    int lineFour = 4;
    
    int oui_id = 0;
    NSString *oui = nil;
    NSString *company = nil;
    NSString *street = nil;
    NSString *city = nil;
    NSString *province = nil;
    NSString *postCode = nil;
    NSString *countryCode = nil;
    
    NSArray *ouiArr = [arr subarrayWithRange:NSMakeRange(4, arr.count - 4)];
    for (int i = 0; i < ouiArr.count; i++) {
        NSString *text = ouiArr[i];
        
        NSString *lineOneStr = nil;
        NSString *lineTwoStr = nil;
        NSString *lineThreeStr = nil;
        NSString *lineFourStr = nil;
        
        if (i == lineOne) {
            lineOneStr = text;
            oui_id++;
            
            oui = [lineOneStr substringWithRange:NSMakeRange(0, 6)];
            company = [lineOneStr substringWithRange:NSMakeRange(22, lineOneStr.length - 22)];
            
            if ([company isEqualToString:@"Private"]) { // 特殊情况
                lineOne += 3;
                lineTwo = lineOne + 1;
                lineThree = lineOne + 2;
                lineFour = lineOne + 3;
                
//                NSLog(@"Private:: oui_id:%d oui:%@ company:%@ street:%@ city:%@ province:%@ postCode:%@ countryCode:%@", oui_id, oui, company, street, city, province, postCode, countryCode);
                
                // 先存储公司数据,再存储OUI数据,分两次执行
                NSString *company_id = [NSString stringWithFormat:@"BTS_%@", company].MD5.lowercaseString;
                
                // Company
//                CompanyModel *companyModel = [[CompanyModel alloc] init];
//                companyModel.company_id = company_id;
//                companyModel.name = company;
//                companyModel.street = street;
//                companyModel.city = city;
//                companyModel.province = province;
//                companyModel.country = countryCode;
//                companyModel.postCode = postCode;
//                companyModel.countryCode = countryCode;
//
//                companyModel.name_zh = company;
//                companyModel.street_zh = street;
//                companyModel.city_zh = city;
//                companyModel.province_zh = province;
//                companyModel.country_zh = countryCode;
//                [DatabaseManagerInstance addOUICompany:companyModel];
                
                // OUI
                OUIModel *ouiModel = [[OUIModel alloc] init];
                ouiModel.oui = oui;
                ouiModel.company_id = company_id;
                [DatabaseManagerInstance addOUI:ouiModel];
                
                
                oui = nil;
                company = nil;
                street = nil;
                city = nil;
                province = nil;
                postCode = nil;
                countryCode = nil;
            } else {
                lineOne += 6;
            }
            
        } else if (i == lineTwo) {
            lineTwoStr = text;
            
            lineTwo += 6;
            
            street = [lineTwoStr substringWithRange:NSMakeRange(4, lineTwoStr.length - 4)];
            
        } else if (i == lineThree) {
            lineThreeStr = text;
            
            lineThree += 6;
            
            NSString *addressInfo = [lineThreeStr substringWithRange:NSMakeRange(4, lineThreeStr.length - 4)];
            NSArray *infoArr = [addressInfo componentsSeparatedByString:@"  "];
            if (infoArr.count == 2) {
                city = infoArr[0];
                postCode = infoArr[1];
            } else if (infoArr.count == 3) {
                city = infoArr[0];
                province = infoArr[1];
                postCode = infoArr[2];
            }
            
        } else if (i == lineFour) {
            lineFourStr = text;
            
            lineFour += 6;
            
            countryCode = [lineFourStr substringWithRange:NSMakeRange(4, lineFourStr.length - 4)];
            
//            NSLog(@"Normal:: oui_id:%d oui:%@ company:%@ street:%@ city:%@ province:%@ postCode:%@ countryCode:%@", oui_id, oui, company, street, city, province, postCode, countryCode);
            
            // 先存储公司数据,再存储OUI数据,分两次执行
            NSString *company_id = [NSString stringWithFormat:@"BTS_%@", company].MD5.lowercaseString;
            
            // Company
//            CompanyModel *companyModel = [[CompanyModel alloc] init];
//            companyModel.company_id = company_id;
//            companyModel.name = company;
//            companyModel.street = street;
//            companyModel.city = city;
//            companyModel.province = province;
//            companyModel.country = countryCode;
//            companyModel.postCode = postCode;
//            companyModel.countryCode = countryCode;
//
//            companyModel.name_zh = company;
//            companyModel.street_zh = street;
//            companyModel.city_zh = city;
//            companyModel.province_zh = province;
//            companyModel.country_zh = countryCode;
//            [DatabaseManagerInstance addOUICompany:companyModel];
            
            // OUI
            OUIModel *ouiModel = [[OUIModel alloc] init];
            ouiModel.oui = oui;
            ouiModel.company_id = company_id;
            [DatabaseManagerInstance addOUI:ouiModel];
            
            
            oui = nil;
            company = nil;
            street = nil;
            city = nil;
            province = nil;
            postCode = nil;
            countryCode = nil;
        }
    }
}

/** 从.txt文件中统计OUI数据 */
+ (void)loadOUIDataStatisticsFromTxt {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"oui" ofType:@"txt"];
    NSString *txtContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [txtContent componentsSeparatedByString:@"\r\n"];
    if (arr.count < 4) {
        return;
    }
    
    // 从第四行开始为有效数据
    int lineOne = 1;
    int lineTwo = 2;
    int lineThree = 3;
    int lineFour = 4;
    
    int oui_id = 0;
    NSString *oui = nil;
    NSString *company = nil;
    NSString *street = nil;
    NSString *city = nil;
    NSString *province = nil;
    NSString *postCode = nil;
    NSString *countryCode = nil;
    
    // 数据统计(公司/国家/省份(州)/城市)
    NSMutableDictionary *companysDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *countryCodesDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *provincesDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *citiesDic = [NSMutableDictionary dictionary];
    
    NSArray *ouiArr = [arr subarrayWithRange:NSMakeRange(4, arr.count - 4)];
    for (int i = 0; i < ouiArr.count; i++) {
        NSString *text = ouiArr[i];
        
        NSString *lineOneStr = nil;
        NSString *lineTwoStr = nil;
        NSString *lineThreeStr = nil;
        NSString *lineFourStr = nil;
        
        if (i == lineOne) {
            lineOneStr = text;
            oui_id++;
            
            oui = [lineOneStr substringWithRange:NSMakeRange(0, 6)];
            company = [lineOneStr substringWithRange:NSMakeRange(22, lineOneStr.length - 22)];
            
            if ([company isEqualToString:@"Private"]) { // 特殊情况
                lineOne += 3;
                lineTwo = lineOne + 1;
                lineThree = lineOne + 2;
                lineFour = lineOne + 3;
                
//                NSLog(@"Private:: oui_id:%d oui:%@ company:%@ street:%@ city:%@ province:%@ postCode:%@ countryCode:%@", oui_id, oui, company, street, city, province, postCode, countryCode);
                
                // 数据统计
                company = IS_NULL_STRING(company) ? [NSString stringWithFormat:@"Private_company_null_%@", oui] : company;
                countryCode = IS_NULL_STRING(countryCode) ? [NSString stringWithFormat:@"Private_%@", oui] : countryCode;
                province = IS_NULL_STRING(province) ? @"province_null" : province;
                city = IS_NULL_STRING(city) ? @"city_null" : city;
                
                [companysDic setValue:company forKey:company];
                [countryCodesDic setValue:countryCode forKey:countryCode];
                [provincesDic setValue:province forKey:province];
                [citiesDic setValue:city forKey:city];
                
                
                oui = nil;
                company = nil;
                street = nil;
                city = nil;
                province = nil;
                postCode = nil;
                countryCode = nil;
            } else {
                lineOne += 6;
            }
            
        } else if (i == lineTwo) {
            lineTwoStr = text;
            
            lineTwo += 6;
            
            street = [lineTwoStr substringWithRange:NSMakeRange(4, lineTwoStr.length - 4)];
            
        } else if (i == lineThree) {
            lineThreeStr = text;
            
            lineThree += 6;
            
            NSString *addressInfo = [lineThreeStr substringWithRange:NSMakeRange(4, lineThreeStr.length - 4)];
            NSArray *infoArr = [addressInfo componentsSeparatedByString:@"  "];
            if (infoArr.count == 2) {
                city = infoArr[0];
                postCode = infoArr[1];
            } else if (infoArr.count == 3) {
                city = infoArr[0];
                province = infoArr[1];
                postCode = infoArr[2];
            }
            
        } else if (i == lineFour) {
            lineFourStr = text;
            
            lineFour += 6;
            
            countryCode = [lineFourStr substringWithRange:NSMakeRange(4, lineFourStr.length - 4)];
            
//            NSLog(@"Normal:: oui_id:%d oui:%@ company:%@ street:%@ city:%@ province:%@ postCode:%@ countryCode:%@", oui_id, oui, company, street, city, province, postCode, countryCode);
            
            // 数据统计
            company = IS_NULL_STRING(company) ? [NSString stringWithFormat:@"Normal_company_null_%@", oui] : company;
            countryCode = IS_NULL_STRING(countryCode) ? [NSString stringWithFormat:@"Normal_%@", oui] : countryCode;
            province = IS_NULL_STRING(province) ? @"province_null" : province;
            city = IS_NULL_STRING(city) ? @"city_null" : city;
            
            [companysDic setValue:company forKey:company];
            [countryCodesDic setValue:countryCode forKey:countryCode];
            [provincesDic setValue:province forKey:province];
            [citiesDic setValue:city forKey:city];
            
            
            oui = nil;
            company = nil;
            street = nil;
            city = nil;
            province = nil;
            postCode = nil;
            countryCode = nil;
        }
    }
    
    // 公司: 17437 (17438 = 17437 + 1(无效数据:Private))
//    for (int i = 0; i < companysDic.allKeys.count; i++) {
//        NSLog(@"company_\"%@\"", companysDic.allKeys[i]);
//    }
    // 国家代码: 87 (222 = 87 + 135(无效数据))
//    for (int i = 0; i < countryCodesDic.allKeys.count; i++) {
//        NSLog(@"countryCode_%@", countryCodesDic.allKeys[i]);
//    }
    // 省份(州): 2196 (8472 = 2196 + 6276(无效数据))
//    for (int i = 0; i < provincesDic.allKeys.count; i++) {
//        NSLog(@"province_\"%@\"", provincesDic.allKeys[i]);
//    }
    // 城市: 6405 (8280 = 6405 + 1875(无效数据))
//    for (int i = 0; i < citiesDic.allKeys.count; i++) {
//        NSLog(@"city_\"%@\"", citiesDic.allKeys[i]);
//    }
}

+ (void)OUIDataDebug {
    // 1. OUI
//    NSArray *ouiArr = [DatabaseManagerInstance queryAllOUI];
//    for (int i = 0; i < 10; i++) {
//        OUIModel *oui = ouiArr[i];
//        NSLog(@"oui: %@", oui.oui);
//    }
    
    // 更新
//    [DatabaseManagerInstance updateOUIWithKey:@"company_id" value:@"3fc8046ed76cc214ce7c5dfda51987bd" whereKey:@"oui" whereValue:@"0001C8"];
    
    // 查询
//    OUIModel *ouiModel = [DatabaseManagerInstance queryOUIWithOUICode:@"3C3556"];
//    NSLog(@"%@", ouiModel.description);
    
    
    
    // 2. Company
//    NSArray *companyArr = [DatabaseManagerInstance queryAllOUICompany];
//    NSInteger companyCount = companyArr.count;
////    companyCount = 50;
//    for (int i = 0; i < companyCount; i++) {
//        CompanyModel *company = companyArr[i];
//        if (company.ouiCount == 1) {
//            NSLog(@"%@-%@", company.company_id, company.name);
//        }
//    }
    
    // 更新
//    [DatabaseManagerInstance updateOUICompanyWithKey:@"city_zh" value:@"" whereKey:@"name_zh" whereValue:@""];
    NSString *company_id = @"";
    if (!IS_NULL_STRING(company_id)) {
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"name_zh" value:@""];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"company_url" value:@""];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"street" value:@""];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"street_zh" value:@""];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"city" value:@"Shenzhen"];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"city_zh" value:@""];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"province" value:@""];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company_id key:@"province_zh" value:@""];
    }

    // 查询
    NSArray *companys = [DatabaseManagerInstance selectOUICompanyWithKey:@"name" value:@"Lupine Lighting Systems GmbH"];
    for (CompanyModel *company in companys) {
        NSLog(@"%@", company.description);
    }

    
//    NSArray *topTenArr = [DatabaseManagerInstance queryCompanyWithTopOUICount:21];
//    for (CompanyModel *company in topTenArr) {
//        NSLog(@"%@-%@ (%ld-%@)", company.name, company.name_zh, company.ouiCount, company.ouiRank);
//    }
    
    
//    [DatabaseManagerInstance countCountryRankWithCompanyCount];
}

/** 统计每个公司的OUI列表 */
+ (void)OUIDataCountEachCompanyOUIList {
    // 1. 从plist文件中加载国家代码数据
//    NSArray *countryCodeList = [NSArray array];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"OUI_CountryCode" ofType:@"plist"];
//    if (@available(iOS 11.0, *)) {
//        NSError *error = nil;
//        countryCodeList = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
//        if (error) {
//            NSLog(@"加载OUI_CountryCode.plist失败,error:%@", error.description);
//        } else {
//            NSLog(@"加载OUI_CountryCode.plist成功!");
//        }
//    } else {
//        countryCodeList = [NSArray arrayWithContentsOfFile:filePath];
//    }
//    NSMutableDictionary *countryNameEnDic = [NSMutableDictionary dictionary];
//    NSMutableDictionary *countryNameZhDic = [NSMutableDictionary dictionary];
//    for (NSDictionary *countryCodeDic in countryCodeList) {
//        NSString *code = countryCodeDic[@"code"];
//        NSString *name_en = countryCodeDic[@"name_en"];
//        NSString *name_zh = countryCodeDic[@"name_zh"];
//        [countryNameEnDic setValue:name_en forKey:code];
//        [countryNameZhDic setValue:name_zh forKey:code];
//    }
    
    
    
//    NSArray *companyArr = [DatabaseManagerInstance queryAllOUICompany];
//    NSInteger companyCount = companyArr.count;
//    companyCount = 1;
//    for (int i = 0; i < companyCount; i++) {
//        CompanyModel *company = companyArr[i];
    
        // 更新ouiList/ouiCount
//        NSArray *ouis = [DatabaseManagerInstance countCompanyOUIListWithCompanyID:company.company_id];
//        NSMutableArray *ouiListArr = [NSMutableArray array];
//        for (int j = 0; j < ouis.count; j++) {
//            OUIModel *ouiModel = ouis[j];
//            [ouiListArr addObject:ouiModel.oui];
//        }
//
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company.company_id key:@"ouiList" value:ouiListArr];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company.company_id key:@"ouiCount" value:[NSNumber numberWithInteger:ouiListArr.count]];
//    }
    
    
    // 根据ouiCount进行排序(降序)(对ouiRank赋值)
//    NSSortDescriptor *ouiCountSortDes = [NSSortDescriptor sortDescriptorWithKey:@"ouiCount" ascending:NO];
//    companyArr = [companyArr sortedArrayUsingDescriptors:@[ouiCountSortDes]];
//    for (int i = 0; i < companyCount; i++) {
//        CompanyModel *company = companyArr[i];
//        [DatabaseManagerInstance updateOUICompanyWithCompanyID:company.company_id key:@"ouiRank" value:[NSString stringWithFormat:@"%05d", i + 1]];
//    }
}

@end
