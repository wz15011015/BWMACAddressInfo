//
//  OUIInfoCell.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "OUIInfoCell.h"
#import "Common.h"

NSString *const OUIInfoCellID = @"OUIInfoCellIdentifier";

@interface OUIInfoCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;

@end

@implementation OUIInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Setters

- (void)setOuiModel:(OUIModel *)ouiModel {
    _ouiModel = ouiModel;
    
    CompanyModel *company = ouiModel.company;
    UIImage *iconImage = [UIImage imageNamed:@"oui_code"];
    NSString *info = @"";
    if (self.infoType == OUIInfoOUICode) {
        iconImage = [UIImage imageNamed:@"oui_code"];
        info = ouiModel.oui;
    } else if (self.infoType == OUIInfoCompany) {
        iconImage = [UIImage imageNamed:@"oui_company"];
        info = company.name_local;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (self.infoType == OUIInfoStreet) {
        iconImage = [UIImage imageNamed:@"oui_street"];
        info = company.street_local;
    } else if (self.infoType == OUIInfoCity) {
        iconImage = [UIImage imageNamed:@"oui_city"];
        info = company.city_local;
    } else if (self.infoType == OUIInfoProvince) {
        iconImage = [UIImage imageNamed:@"oui_address"];
        info = company.province_local;
    } else if (self.infoType == OUIInfoPostCode) {
        iconImage = [UIImage imageNamed:@"oui_postCode"];
        info = company.postCode;
    } else if (self.infoType == OUIInfoCountryCode) {
        iconImage = [UIImage imageNamed:@"oui_countryCode"];
        info = company.country_local;
    }
    self.iconImageView.image = iconImage;
    self.infoLabel.text = info;
}

- (void)setCompany:(CompanyModel *)company {
    _company = company;
    
//    self.iconImageView.image = [UIImage imageNamed:@"oui_company"];
//    self.infoLabel.text = company.name_local;
    
    UIImage *iconImage = [UIImage imageNamed:@"oui_code"];
    NSString *info = @"";
    if (self.infoType == OUIInfoOUICode) {
        iconImage = [UIImage imageNamed:@"oui_code"];
//        info = ouiModel.oui;
    } else if (self.infoType == OUIInfoCompany) {
        iconImage = [UIImage imageNamed:@"oui_company"];
        info = company.name_local;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (self.infoType == OUIInfoStreet) {
        iconImage = [UIImage imageNamed:@"oui_street"];
        info = company.street_local;
    } else if (self.infoType == OUIInfoCity) {
        iconImage = [UIImage imageNamed:@"oui_city"];
        info = company.city_local;
    } else if (self.infoType == OUIInfoProvince) {
        iconImage = [UIImage imageNamed:@"oui_address"];
        info = company.province_local;
    } else if (self.infoType == OUIInfoPostCode) {
        iconImage = [UIImage imageNamed:@"oui_postCode"];
        info = company.postCode;
    } else if (self.infoType == OUIInfoCountryCode) {
        iconImage = [UIImage imageNamed:@"oui_countryCode"];
        info = company.country_local;
    }
    self.iconImageView.image = iconImage;
    self.infoLabel.text = info;
}

- (void)setCountry:(CountryModel *)country {
    _country = country;
    
    NSString *code = country.code;
    if ([code isEqualToString:@"TW"]) {
        code = @"CN";
    }
    NSString *iconName = [NSString stringWithFormat:@"country_icon_%@", code];
    self.iconImageView.image = [UIImage imageNamed:iconName];
    self.infoLabel.text = country.name_local;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", country.companyCount];
}


#pragma mark - Public Methods

/** 根据索引值返回Cell的显示类型 (OUI信息页面) */
+ (OUIInfoType)infoTypeForOUIInfoWihtIndex:(NSInteger)index {
    OUIInfoType type = OUIInfoOUICode;
    
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        switch (index) {
            case 0:
                type = OUIInfoOUICode;
                break;
            case 1:
                type = OUIInfoCompany;
                break;
            case 2:
                type = OUIInfoCountryCode;
                break;
            case 3:
                type = OUIInfoProvince;
                break;
            case 4:
                type = OUIInfoCity;
                break;
            case 5:
                type = OUIInfoStreet;
                break;
            case 6:
                type = OUIInfoPostCode;
                break;
            default:
                break;
        }
    } else {
        switch (index) {
            case 0:
                type = OUIInfoOUICode;
                break;
            case 1:
                type = OUIInfoCompany;
                break;
            case 2:
                type = OUIInfoStreet;
                break;
            case 3:
                type = OUIInfoCity;
                break;
            case 4:
                type = OUIInfoProvince;
                break;
            case 5:
                type = OUIInfoPostCode;
                break;
            case 6:
                type = OUIInfoCountryCode;
                break;
            default:
                break;
        }
    }
    return type;
}

/** 根据索引值返回Cell的显示类型 (公司信息页面) */
+ (OUIInfoType)infoTypeForCompanyInfoWihtIndex:(NSInteger)index {
    OUIInfoType type = OUIInfoCompany;
    
    NSString *appLanguageCode = [BTSUtil appCurrentLanguageCode];
    if ([appLanguageCode isEqualToString:@"zh"]) {
        switch (index) {
                case 0:
                type = OUIInfoCompany;
                break;
                case 1:
                type = OUIInfoCountryCode;
                break;
                case 2:
                type = OUIInfoProvince;
                break;
                case 3:
                type = OUIInfoCity;
                break;
                case 4:
                type = OUIInfoStreet;
                break;
                case 5:
                type = OUIInfoPostCode;
                break;
                case 6:
                type = OUIInfoOUICode;
                break;
            default:
                break;
        }
    } else {
        switch (index) {
                case 0:
                type = OUIInfoCompany;
                break;
                case 1:
                type = OUIInfoStreet;
                break;
                case 2:
                type = OUIInfoCity;
                break;
                case 3:
                type = OUIInfoProvince;
                break;
                case 4:
                type = OUIInfoPostCode;
                break;
                case 5:
                type = OUIInfoCountryCode;
                break;
                case 6:
                type = OUIInfoOUICode;
                break;
            default:
                break;
        }
    }
    return type;
}

@end
