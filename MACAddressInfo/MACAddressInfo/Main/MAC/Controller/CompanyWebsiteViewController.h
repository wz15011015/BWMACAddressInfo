//
//  CompanyWebsiteViewController.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/20.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

@class CompanyModel;

NS_ASSUME_NONNULL_BEGIN

/**
 公司网站 页面
 */
@interface CompanyWebsiteViewController : BTSBaseViewController

/** 公司对象 */
@property (nonatomic, strong) CompanyModel *company;

@end

NS_ASSUME_NONNULL_END
