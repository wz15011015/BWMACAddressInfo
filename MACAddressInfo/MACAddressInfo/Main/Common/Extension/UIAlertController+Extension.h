//
//  UIAlertController+Extension.h
//  MACAddressInfo
//
//  Created by 王志 on 2019/1/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertHandler)(UIAlertAction *action);


@interface UIAlertController (Extension)

/**
 Alert 1种选择
 
 @param title 标题
 @param message 描述
 @param firstTitle 按钮标题
 @param firstHandler 按钮事件
 @param controller 控制器
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                firstTitle:(NSString *)firstTitle
              firstHandler:(AlertHandler)firstHandler
              toController:(UIViewController *)controller;

/**
 Alert 1种选择+取消

 @param title 标题
 @param message 描述
 @param firstTitle 按钮标题
 @param firstHandler 按钮事件
 @param cancelHandler 取消事件
 @param controller 控制器
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                firstTitle:(NSString *)firstTitle
              firstHandler:(AlertHandler)firstHandler
             cancelHandler:(AlertHandler)cancelHandler
              toController:(UIViewController *)controller;

/**
 ActionSheet 2种选择+取消
 
 @param title 标题
 @param message 描述
 @param firstTitle 第一个按钮标题
 @param firstHandler 第一个按钮事件
 @param secondTitle 第二个按钮标题
 @param secondHandler 第二个按钮事件
 @param cancelHandler 取消事件
 @param controller 控制器
 */
+ (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                      firstTitle:(NSString *)firstTitle
                    firstHandler:(AlertHandler)firstHandler
                     secondTitle:(NSString *)secondTitle
                   secondHandler:(AlertHandler)secondHandler
                   cancelHandler:(AlertHandler)cancelHandler
                    toController:(UIViewController *)controller;

@end
