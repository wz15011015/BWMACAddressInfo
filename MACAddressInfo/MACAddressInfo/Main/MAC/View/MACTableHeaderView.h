//
//  MACTableHeaderView.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/10.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MACTableHeaderViewType) {
    MACTableHeaderViewDevice,
    MACTableHeaderViewWiFi,
};

#define MACTableHeaderViewH_Device 115
#define MACTableHeaderViewH_WiFi 135

NS_ASSUME_NONNULL_BEGIN

/**
 MAC地址TableHeaderView
 */
@interface MACTableHeaderView : UIView

@property (nonatomic, assign) MACTableHeaderViewType viewType;

/** WiFi名称 */
@property (nonatomic, copy) NSString *wiFiName;

/** MAC地址 */
@property (nonatomic, copy) NSString *macAddress;


- (instancetype)initWithFrame:(CGRect)frame viewType:(MACTableHeaderViewType)viewType;

- (void)updateHintDisplayWithHint:(NSString *)hintStr;

@end

NS_ASSUME_NONNULL_END
