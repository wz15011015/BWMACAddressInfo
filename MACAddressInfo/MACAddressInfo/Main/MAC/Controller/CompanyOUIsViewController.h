//
//  CompanyOUIsViewController.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 公司OUI列表 页面
 */
@interface CompanyOUIsViewController : BTSBaseViewController

/** 公司OUI列表 */
@property (nonatomic, strong) NSArray <NSString *>*ouiList;

@end

NS_ASSUME_NONNULL_END
