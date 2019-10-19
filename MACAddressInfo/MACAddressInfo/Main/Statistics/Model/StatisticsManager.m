//
//  StatisticsManager.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "StatisticsManager.h"
#import "Common.h"
#import "CountryModel.h"

@interface StatisticsManager ()

/** OUI数量排名靠前的公司 */
@property (nonatomic, strong) NSArray *topCompanys;

@end

@implementation StatisticsManager

+ (instancetype)sharedInstance {
    static StatisticsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


#pragma mark - Company

/** OUI数量排名前20的公司 */
- (NSArray *)top20Companys {
    return self.topCompanys;
}


#pragma mark - Getters

- (NSArray *)topCompanys {
    if (!_topCompanys) {
        // 因为前20名中有"Private"特例,需要剔除,所以多查询1名
        NSMutableArray *companys = [NSMutableArray arrayWithArray:[DatabaseManagerInstance queryCompanyWithTopOUICount:21]];
        for (CompanyModel *company in companys) {
            if ([company.name isEqualToString:CompanyPrivateName]) {
                [companys removeObject:company];
                break;
            }
        }
        _topCompanys = companys;
    }
    return _topCompanys;
}

- (NSArray *)countriesOfCompanyRank {
    if (!_countriesOfCompanyRank) {
        NSArray *countries = [DatabaseManagerInstance countCountryRankWithCompanyCount];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (CountryModel *model in countries) {
            if (IS_NULL_STRING(model.code)) {
                continue;
            }
            [tempArr addObject:model];
        }
        _countriesOfCompanyRank = tempArr;
    }
    return _countriesOfCompanyRank;
}

@end
