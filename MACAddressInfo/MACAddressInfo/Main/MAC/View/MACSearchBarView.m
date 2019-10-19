//
//  MACSearchBarView.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "MACSearchBarView.h"
#import "Common.h"

@interface MACSearchBarView ()

/** 提示Label */
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation MACSearchBarView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(249, 249, 249);
        
        // 添加控件
        [self addSubview:self.searchTextField];
        [self addSubview:self.hintLabel];
    }
    return self;
}


#pragma mark - Getters

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        CGFloat x = 8;
        CGFloat w = BTSWIDTH - (2 * x);
        CGFloat h = 35;
        CGFloat y = 10;
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.backgroundColor = [UIColor whiteColor];
        _searchTextField.tintColor = THEME_COLOR;
        _searchTextField.font = [UIFont systemFontOfSize:14];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSAttributedString *attriStr = [[NSAttributedString alloc] initWithString:BTSLocalizedString(@"Search network card address", nil) attributes:@{NSForegroundColorAttributeName: RGB(142, 141, 147)}];
        _searchTextField.attributedPlaceholder = attriStr;
        
        _searchTextField.layer.cornerRadius = 5.0;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.layer.borderColor = RGB(225, 225, 225).CGColor;
        _searchTextField.layer.borderWidth = 0.5;
    }
    return _searchTextField;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        CGFloat y = CGRectGetMaxY(self.searchTextField.frame) + 7;
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.searchTextField.frame), y, CGRectGetWidth(self.searchTextField.frame), 30)];
        _hintLabel.textColor = RGB(180, 180, 180);
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.numberOfLines = 0;
        _hintLabel.text = BTSLocalizedString(@"The input format of network card address:", nil);
    }
    return _hintLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
