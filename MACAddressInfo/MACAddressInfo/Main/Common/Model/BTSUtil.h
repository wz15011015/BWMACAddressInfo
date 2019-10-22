//
//  BTSUtil.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTSUtil : NSObject

#pragma mark - 多语言

/** App当前的语言类型 */
+ (NSString *)appCurrentLanguageCode;

/** 获取key对应的本地化字符串 */
+ (NSString *)localizedStringWithKey:(NSString *)key;


/**
 跳转到应用的系统设置页面
 */
+ (void)jumpToApplicationSettingPage;


#pragma mark - 3D Touch

/** 检测3D Touch功能是否可用 */
+ (BOOL)check3DTouchAvailableWithObject:(id<UITraitEnvironment>)object;


#pragma mark - 添加触感反馈

/**
 产生触感反馈效果
 
 @param style 触感反馈类型
 */
+ (void)generateImpactFeedbackWithStyle:(UIImpactFeedbackStyle)style;

/**
 产生触感反馈效果
 */
+ (void)generateImpactFeedback;


#pragma mark - 添加音效

/**
 播放音效(七个基本音效)
 
 @param number 音效序号 (1~7对应:Do Re Mi Fa Sol La Si)
 */
+ (void)playMusicalNoteWithNumber:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END
