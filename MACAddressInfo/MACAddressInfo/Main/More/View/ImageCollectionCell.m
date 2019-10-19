//
//  ImageCollectionCell.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "ImageCollectionCell.h"

NSString *const ImageCollectionCellID = @"ImageCollectionCellIdentifier";

@interface ImageCollectionCell ()

@property (nonatomic, weak) IBOutlet UIButton *deleteButton;

@end

@implementation ImageCollectionCell

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


#pragma mark - Setter

- (void)setIsAddCell:(BOOL)isAddCell {
    _isAddCell = isAddCell;
    
    self.deleteButton.hidden = isAddCell;
}


#pragma mark - Event

- (IBAction)deleteEvent:(id)sender {
    if (self.deleteImageBlock) {
        self.deleteImageBlock();
    }
}

@end
