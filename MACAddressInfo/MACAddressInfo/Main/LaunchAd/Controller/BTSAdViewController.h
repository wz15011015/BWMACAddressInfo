//
//  BTSAdViewController.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/9.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

/**
 广告关闭的类型
 
 - BTSADCloseTypeSkip: 用户跳过了广告
 - BTSADCloseTypeClick: 用户点击了广告
 - BTSADCloseTypeWait: 用户等待广告展示完成,自动关闭了广告
 */
typedef NS_ENUM(NSUInteger, BTSADCloseType) {
    BTSADCloseTypeSkip,
    BTSADCloseTypeClick,
    BTSADCloseTypeWait,
};

/**
 关闭广告的回调Block
 
 @param closeType 广告关闭的类型
 */
typedef void(^BTSADCloseBlock)(BTSADCloseType closeType);


NS_ASSUME_NONNULL_BEGIN

/**
 启动广告 控制器
 */
@interface BTSAdViewController : BTSBaseViewController

/**
 关闭广告的回调
 */
@property (nonatomic, copy) BTSADCloseBlock adCloseBlock;

@end

NS_ASSUME_NONNULL_END
