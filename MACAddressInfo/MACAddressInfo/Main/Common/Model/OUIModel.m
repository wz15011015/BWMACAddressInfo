//
//  OUIModel.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/5.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "OUIModel.h"
#import "CompanyModel.h"

@implementation OUIModel

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)description {
    CompanyModel *company = self.company;
    NSString *description = [NSString stringWithFormat:@"{\n    oui_id: %ld,\n    oui: %@,\n    company_id: %@,\n    company: %@}\n", self.oui_id, self.oui, self.company_id, company.description];
    return description;
}

@end
