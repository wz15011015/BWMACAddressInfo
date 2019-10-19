//
//  UIAlertController+Extension.m
//  MACAddressInfo
//
//  Created by 王志 on 2019/1/25.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "UIAlertController+Extension.h"
#import "Common.h"

@implementation UIAlertController (Extension)

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
              toController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:firstHandler];
    [firstAction setValue:THEME_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:firstAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

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
              toController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BTSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:cancelHandler];
    [cancelAction setValue:THEME_COLOR forKey:@"_titleTextColor"];

    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:firstHandler];
    [firstAction setValue:THEME_COLOR forKey:@"_titleTextColor"];

    [alertController addAction:cancelAction];
    [alertController addAction:firstAction];

    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

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
                    toController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:firstHandler];
    [firstAction setValue:THEME_COLOR forKey:@"_titleTextColor"];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:secondHandler];
    [secondAction setValue:THEME_COLOR forKey:@"_titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BTSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:cancelHandler];
    [cancelAction setValue:THEME_COLOR forKey:@"_titleTextColor"];
    
    [alertController addAction:firstAction];
    [alertController addAction:secondAction];
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

@end
