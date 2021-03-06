//
//  MACTableHeaderView.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/10.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "MACTableHeaderView.h"
#import "Common.h"

@interface MACTableHeaderView ()

/** 提示Label */
@property (nonatomic, strong) UILabel *hintLabel;

/** MAC地址Label */
@property (nonatomic, strong) UILabel *macAddressLabel;

/** 提示Label2 */
@property (nonatomic, strong) UILabel *hintLabel2;

@end

@implementation MACTableHeaderView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(249, 249, 249);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewType:(MACTableHeaderViewType)viewType {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(249, 249, 249);
        _viewType = viewType;
        
        // 添加控件
        [self addSubview:self.hintLabel];
        [self addSubview:self.macAddressLabel];
        [self addSubview:self.hintLabel2];
    }
    return self;
}

- (void)updateHintDisplayWithHint:(NSString *)hintStr {
    self.hintLabel2.text = hintStr;
}


#pragma mark - Setters

- (void)setWiFiName:(NSString *)wiFiName {
    _wiFiName = wiFiName;
    
    NSString *hintStr = [NSString stringWithFormat:BTSLocalizedString(@"The network card address of native connected WiFi [%@] is:", nil), wiFiName];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:hintStr];
    [attriStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:[hintStr rangeOfString:wiFiName]];
    self.hintLabel.attributedText = attriStr;
}

- (void)setMacAddress:(NSString *)macAddress {
    _macAddress = macAddress;
    
    // 转成大写字母
    macAddress = macAddress.uppercaseString;
    self.macAddressLabel.text = macAddress;
}


#pragma mark - Getters

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        CGFloat x = 15;
        CGFloat w = BTSWIDTH - 2 * x;
        CGFloat y = 8;
        CGFloat h = 30;
        if (_viewType == MACTableHeaderViewDevice) {
            h = 30;
        } else {
            h = 50;
        }
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _hintLabel.textColor = RGB(60, 60, 60);
        _hintLabel.font = [UIFont systemFontOfSize:16];
        _hintLabel.numberOfLines = 0;
        _hintLabel.text = BTSLocalizedString(@"The network card address of this device is:", nil);
    }
    return _hintLabel;
}

- (UILabel *)macAddressLabel {
    if (!_macAddressLabel) {
        CGFloat y = CGRectGetMaxY(self.hintLabel.frame);
        CGFloat x = 48;
        CGFloat w = BTSWIDTH - x - 15;
        _macAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 30)];
        _macAddressLabel.textColor = THEME_COLOR;
        _macAddressLabel.font = [UIFont boldSystemFontOfSize:18];
        _macAddressLabel.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pasteEvent:)];
        [_macAddressLabel addGestureRecognizer:tapGestureRecognizer];
    }
    return _macAddressLabel;
}

- (UILabel *)hintLabel2 {
    if (!_hintLabel2) {
        CGFloat x = 15;
        CGFloat w = BTSWIDTH - 2 * x;
        CGFloat y = CGRectGetMaxY(self.macAddressLabel.frame) + 5;
        _hintLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 40)];
        _hintLabel2.textColor = RGB(160, 160, 160);
        _hintLabel2.font = [UIFont italicSystemFontOfSize:13];
        _hintLabel2.numberOfLines = 0;
        _hintLabel2.text = BTSLocalizedString(@"According to the network card address query to the network card manufacturer information is as follows:", nil);
    }
    return _hintLabel2;
}


#pragma mark - Event

- (void)pasteEvent:(UIGestureRecognizer *)gestureRecognizer {
    UIView *view = gestureRecognizer.view;
    
    // 一定要调用这个方法
    [self becomeFirstResponder];
    
    // 创建菜单控制器
    UIMenuController *menuvc = [UIMenuController sharedMenuController];
    if (menuvc.menuVisible) { // 如果菜单控制器已经显示,则不再次去显示
        return;
    }
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:BTSLocalizedString(@"Copy", nil) action:@selector(firstItemAction:)];
    menuvc.menuItems = @[menuItem1];
    menuvc.arrowDirection = UIMenuControllerArrowDown;
    [menuvc setTargetRect:CGRectMake(CGRectGetMidX(view.frame), CGRectGetMinY(view.frame) + 10, 0, 0) inView:self];
    [menuvc setMenuVisible:YES animated:YES];
}

- (void)firstItemAction:(UIMenuItem *)item {
    NSString *macAddress = self.macAddressLabel.text;
    
    // 通过系统的粘贴板,记录下需要传递的数据
    [UIPasteboard generalPasteboard].string = macAddress;
}


#pragma mark - 创建 UIMenuController 必须实现的关键方法

// 自己能否成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// 能否处理Action事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(firstItemAction:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
