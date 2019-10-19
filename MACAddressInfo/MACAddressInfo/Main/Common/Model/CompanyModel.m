//
//  CompanyModel.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/11.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyModel.h"
#import "CommonFile.h"

@implementation CompanyModel

- (instancetype)init {
    if (self = [super init]) {
        _ouiCount = 0;
    }
    return self;
}

- (NSString *)description {
    NSString *ouiList = @"";
    for (int i = 0; i < self.ouiList.count; i++) {
        NSString *oui = self.ouiList[i];
        if (i == self.ouiList.count - 1) {
            ouiList = [ouiList stringByAppendingString:oui];
        } else {
            ouiList = [ouiList stringByAppendingString:[NSString stringWithFormat:@"%@,", oui]];
        }
    }
    NSString *description = [NSString stringWithFormat:@"{\n    company_id: %@,\n    name: %@,\n    street: %@,\n    city: %@,\n    province: %@,\n    country: %@,\n    postCode: %@,\n    countryCode: %@,\n    name_zh: %@,\n    street_zh: %@,\n    city_zh: %@,\n    province_zh: %@,\n    country_zh: %@,\n    ouiList: [%@],\n    ouiCount: %ld,\n    ouiRank: %@\n    company_url: %@\n}\n",
                             self.company_id, self.name, self.street, self.city, self.province, self.country,
                             self.postCode, self.countryCode,
                             self.name_zh, self.street_zh, self.city_zh, self.province_zh, self.country_zh,
                             ouiList, self.ouiCount, self.ouiRank, self.company_url];
    return description;
}


#pragma mark - Coding

// 编码(归档)
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_company_id forKey:@"company_id"];
    
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_street forKey:@"street"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_postCode forKey:@"postCode"];
    [aCoder encodeObject:_countryCode forKey:@"countryCode"];
    
    [aCoder encodeObject:_name_zh forKey:@"name_zh"];
    [aCoder encodeObject:_street_zh forKey:@"street_zh"];
    [aCoder encodeObject:_city_zh forKey:@"city_zh"];
    [aCoder encodeObject:_province_zh forKey:@"province_zh"];
    [aCoder encodeObject:_country_zh forKey:@"country_zh"];
    
    [aCoder encodeObject:_ouiList forKey:@"ouiList"];
    [aCoder encodeInteger:_ouiCount forKey:@"ouiCount"];
    [aCoder encodeObject:_ouiRank forKey:@"ouiRank"];
    [aCoder encodeObject:_ouiRank forKey:@"company_url"];
}

// 解码(解档)
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _company_id = [aDecoder decodeObjectForKey:@"company_id"];
        
        _name = [aDecoder decodeObjectForKey:@"name"];
        _street = [aDecoder decodeObjectForKey:@"street"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _province = [aDecoder decodeObjectForKey:@"province"];
        _country = [aDecoder decodeObjectForKey:@"country"];
        _postCode = [aDecoder decodeObjectForKey:@"postCode"];
        _countryCode = [aDecoder decodeObjectForKey:@"countryCode"];
        
        _name_zh = [aDecoder decodeObjectForKey:@"name_zh"];
        _street_zh = [aDecoder decodeObjectForKey:@"street_zh"];
        _city_zh = [aDecoder decodeObjectForKey:@"city_zh"];
        _province_zh = [aDecoder decodeObjectForKey:@"province_zh"];
        _country_zh = [aDecoder decodeObjectForKey:@"country_zh"];
        
        _ouiList = [aDecoder decodeObjectForKey:@"ouiList"];
        _ouiCount = [aDecoder decodeIntegerForKey:@"ouiCount"];
        _ouiRank = [aDecoder decodeObjectForKey:@"ouiRank"];
        _ouiRank = [aDecoder decodeObjectForKey:@"company_url"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
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

- (NSString *)street_local {
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        return self.street_zh;
    } else {
        return self.street;
    }
}

- (NSString *)city_local {
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        return self.city_zh;
    } else {
        return self.city;
    }
}

- (NSString *)province_local {
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        return self.province_zh;
    } else {
        return self.province;
    }
}

- (NSString *)country_local {
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        return self.country_zh;
    } else {
        return self.country;
    }
}

@end
