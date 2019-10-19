//
//  CompanyInfoViewController.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

@class CompanyModel;

NS_ASSUME_NONNULL_BEGIN

/**
 公司信息 页面
 */
@interface CompanyInfoViewController : BTSBaseViewController

/** 公司对象 */
@property (nonatomic, strong) CompanyModel *company;

@end

NS_ASSUME_NONNULL_END
