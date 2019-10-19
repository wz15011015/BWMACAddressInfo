//
//  OUICollectionCell.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "OUICollectionCell.h"

NSString *const OUICollectionCellID = @"OUICollectionCellIdentifier";

@interface OUICollectionCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *ouiLabel;

@end

@implementation OUICollectionCell

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.borderWidth = 1.0;
    self.iconImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.iconImageView.layer.cornerRadius = 5.0;
    self.iconImageView.layer.masksToBounds = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


#pragma mark - Setters

- (void)setOuiCode:(NSString *)ouiCode {
    _ouiCode = ouiCode;
    
    self.ouiLabel.text = ouiCode;
}

@end
