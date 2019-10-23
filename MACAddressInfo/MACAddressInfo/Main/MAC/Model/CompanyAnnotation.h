//
//  CompanyAnnotation.h
//  MACAddressInfo
//
//  Created by hadlinks on 2019/10/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 公司位置大头针模型
@interface CompanyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
