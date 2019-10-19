//
//  OUIModel.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/5.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CompanyModel;


NS_ASSUME_NONNULL_BEGIN

/**
 OUI模型 (组织唯一标识符 Organizationally Unique Identifier)
 */
@interface OUIModel : NSObject

/** OUI ID */
@property (nonatomic, assign) NSInteger oui_id;

/** OUI (格式: F0FE6B) */
@property (nonatomic, copy) NSString *oui;

/** OUI所属公司ID */
@property (nonatomic, copy) NSString *company_id;

/** OUI所属公司 */
@property (nonatomic, strong) CompanyModel *company;

@end

NS_ASSUME_NONNULL_END
