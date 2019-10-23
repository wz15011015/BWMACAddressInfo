//
//  CompanyLocationViewController.h
//  MACAddressInfo
//
//  Created by hadlinks on 2019/10/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
公司位置 地图显示页面
*/
@interface CompanyLocationViewController : BTSBaseViewController

/** 公司对象 */
@property (nonatomic, strong) CompanyModel *company;

@end

NS_ASSUME_NONNULL_END
