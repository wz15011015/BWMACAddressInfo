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
//#warning 暂时只显示中文版
//    languageCode = @"zh";
    return languageCode;
}

/** App当前的语言类型 */
+ (NSString *)appCurrentLanguageCode {
    // 1. 读取本地存储的languageCode
    NSString *languageCode = [BTSUserDefaults objectForKey:UserDefaultsAppLanguageCodeKey];
//#warning 暂时只显示中文版
//    languageCode = @"zh";
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

@end
