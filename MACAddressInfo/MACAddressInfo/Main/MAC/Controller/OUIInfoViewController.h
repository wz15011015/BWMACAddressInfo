//
//  OUIInfoViewController.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

@class OUIModel;

NS_ASSUME_NONNULL_BEGIN

/**
 OUI信息 页面
 */
@interface OUIInfoViewController : BTSBaseViewController

/** OUIModel */
@property (nonatomic, strong) OUIModel *oui;

@end

NS_ASSUME_NONNULL_END
