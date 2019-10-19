//
//  Common.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#ifndef Common_h
#define Common_h


#pragma mark - 文件引用

#import "CommonFile.h"



#pragma mark - 宏定义

// MARK: 屏幕宽高/类型/适配比例/设备类型

// 屏幕宽高
#define BTSWIDTH  ([UIScreen mainScreen].bounds.size.width)
#define BTSHEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_MAX_LENGTH (MAX(BTSWIDTH, BTSHEIGHT))
#define SCREEN_MIN_LENGTH (MIN(BTSWIDTH, BTSHEIGHT))

// 设备类型
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)
#define IS_SUPER_RETINA ([[UIScreen mainScreen] scale] == 3.0)

// 屏幕类型
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X  (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define IS_IPHONE_XR (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0 && IS_RETINA)
#define IS_IPHONE_XS_MAX (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0 && IS_SUPER_RETINA)
#define IS_IPHONE_X_SERIES (IS_IPHONE_X || IS_IPHONE_XR || IS_IPHONE_XS_MAX)

// 适配比例 (UI效果图以 iPhone 6 (375x667)屏幕像素大小为尺寸基础时)
#define BTSWIDTH_SCALE  (IS_IPHONE_4_OR_LESS ? (320.0 / 375.0) : (BTSWIDTH / 375.0))
#define BTSHEIGHT_SCALE (IS_IPHONE_4_OR_LESS ? (568.0 / 667.0) : (BTSHEIGHT / 667.0))

// 是否为iPhone模拟器
#if TARGET_IPHONE_SIMULATOR
#define IS_IPHONE_SIMULATOR 1
#else
#define IS_IPHONE_SIMULATOR 0
#endif

/**
 NavigationBar增加的高度
 
 * iPhoneX系列中,NavigationBar高度增加了24
 */
#define BTSNavBarHeightAdded \
({ \
    CGFloat addedH = 0; \
    if (IS_IPHONE_X_SERIES) { \
        addedH = 24; \
    } \
    (addedH); \
}) \

/**
 TabBar增加的高度
 
 * iPhoneX系列中,TabBar高度增加了34
 */
#define BTSTabBarHeightAdded \
({ \
    CGFloat addedH = 0; \
    if (IS_IPHONE_X_SERIES) { \
        addedH = 34; \
    } \
    (addedH); \
}) \

/**
 frame中y值的适配
 
 * 有返回值的宏定义
 * 适配iPhoneX系列时,需增加24
 
 @param y frame中y值
 @return newY 适配后的y值
 */
#define BTSMultiScreenY(y) \
({ \
    CGFloat newY = y + BTSNavBarHeightAdded; \
    (newY); \
}) \

#define NAVIGATION_BAR_HEIGHT (64.0 + BTSNavBarHeightAdded)
#define TAB_BAR_HEIGHT        (49.0 + BTSTabBarHeightAdded)


// MARK: 偏好设置
#define BTSUserDefaults [NSUserDefaults standardUserDefaults]

// MARK: 通知中心
#define BTSNotificationCenter [NSNotificationCenter defaultCenter]

// MARK: 弱引用
#define BTS_WEAK_SELF __weak typeof(self) weakSelf = self

// MARK: 空值判断
#define IS_NULL(obj)           (obj == nil || [obj isKindOfClass:[NSNull class]])
#define IS_NULL_STRING(string) (string == nil || [string isKindOfClass:[NSNull class]] || [string isEqualToString:@""])
#define CONFIRM_STRING(string) (IS_NULL_STRING(string) ? @"" : string)
#define SPACE_STRING(string)   (IS_NULL_STRING(string) ? @" " : string)
#define IS_NULL_NUMBER(obj)    (obj == nil || [obj isKindOfClass:[NSNull class]])
#define CONFIRM_NUMBER(obj)    (IS_NULL_NUMBER(obj) ? @0 : obj)

// MARK: 多语言实现(封装了一个宏用来获取key对应的本地化字符串)
#define BTSLocalizedString(key, comment) [BTSUtil localizedStringWithKey:key]

// MARK: 颜色
#define THEME_COLOR RGB(223, 126, 31) // 主题颜色:(223, 126, 31) #DF7E1F
#define NAV_BAR_COLOR RGB(249, 249, 249) // 导航栏背景颜色



#endif /* Common_h */
