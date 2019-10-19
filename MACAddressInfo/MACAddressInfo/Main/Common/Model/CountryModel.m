//
//  CountryModel.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CountryModel.h"
#import "Common.h"

@implementation CountryModel

- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"{\n    code: %@,\n    name: %@,\n    name_zh: %@,\n    companyCount: %ld\n}\n", self.code, self.name, self.name_zh, self.companyCount];
    return description;
}


#pragma mark - Getters

// MARK: 国际化
- (NSString *)name_local {
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        return self.name_zh;
    } else {
        return self.name;
    }
}

@end
