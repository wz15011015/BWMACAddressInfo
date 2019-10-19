//
//  MoreCell.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "MoreCell.h"
#import "Common.h"

NSString * _Nonnull const MoreCellID = @"MoreCellIdentifier";

@interface MoreCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation MoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
