//
//  MACViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "MACViewController.h"
#import "CommonFile.h"
#import "OUIInfoCell.h"
#import "OUIModel.h"
#import "JMDropMenu.h"
#import "MACSearchBarView.h"
#import "DeviceMACViewController.h"
#import "WiFiMACViewController.h"
#import "CompanyWebsiteViewController.h"
#import "FeedbackViewController.h"
#import <Lottie/Lottie.h>
#import "OUIDataTest.h"

@interface MACViewController () <UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, JMDropMenuDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property (nonatomic, strong) LOTAnimationView *rightBarAnimationView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MACSearchBarView *searchBarView;

@property (nonatomic, strong) OUIModel *resultOUI; // 搜索到的OUI

@end

@implementation MACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    
//    [OUIDataTest loadOUIDataFromTxt];
//    [OUIDataTest loadOUIDataStatisticsFromTxt];
//    [OUIDataTest OUIDataDebugForCompany];
//    [OUIDataTest OUIDataCountEachCompanyOUIList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.rightBarAnimationView.isAnimationPlaying) {
        [self.rightBarAnimationView play];
    }
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"Network Card Address", nil);
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    self.searchBarView = [[MACSearchBarView alloc] initWithFrame:CGRectMake(0, 0, BTSWIDTH, MACSearchBarViewH)];
    self.searchBarView.searchTextField.delegate = self;
    self.tableView.tableHeaderView = self.searchBarView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
}


#pragma mark - Events

- (void)clickRightBarButton {
    [self.view endEditing:YES];
    
    NSArray *menuTitles = @[BTSLocalizedString(@"Device Network Card Address", nil), BTSLocalizedString(@"WiFi Network Card Address", nil)];
    NSArray *menuImages = @[@"mac_device", @"mac_wifi"];
    
    CGFloat menuRowHeight = 45.0;
    CGFloat rightMargin = 8;
    if (IS_IPHONE_6P || IS_IPHONE_XS_MAX) {
        rightMargin = 12;
    }
    CGFloat menuW = 155;
    CGFloat menuH = menuTitles.count * menuRowHeight + 7;
    CGFloat menuX = BTSWIDTH - rightMargin - menuW;
    CGFloat menuY = BTSMultiScreenY(66);
    CGFloat arrowOffset = ANCHOR_POINT_OFFSET_RATIO * menuW;
    [JMDropMenu showDropMenuFrame:CGRectMake(menuX, menuY, menuW, menuH) ArrowOffset:arrowOffset TitleArr:menuTitles ImageArr:menuImages Type:JMDropMenuTypeQQ LayoutType:JMDropMenuLayoutTypeNormal RowHeight:menuRowHeight Delegate:self];
}

// MARK: JMDropMenuDelegate
- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    switch (index) {
        case 0: // 查看本机MAC地址信息
            [self jumpToDeviceMACViewController];
            break;
        case 1: // 查看本机连接WiFi的MAC地址信息
            [self jumpToWiFiMACViewController];
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)jumpToDeviceMACViewController {
    DeviceMACViewController *vc = [[DeviceMACViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToWiFiMACViewController {
    WiFiMACViewController *vc = [[WiFiMACViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Data

- (void)queryOUIWithText:(NSString *)text {
    // 解析MAC地址的OUI
    NSString *ouiCode = text;
    if ([text containsString:@":"] || [text containsString:@"-"]) {
        if (text.length >= 8) {
            ouiCode = [text substringWithRange:NSMakeRange(0, 8)];
        }
    } else {
        if (text.length >= 6) {
            ouiCode = [text substringWithRange:NSMakeRange(0, 6)];
        }
    }
    OUIModel *ouiModel = [DatabaseManagerInstance queryOUIWithOUICode:ouiCode];
    NSLog(@"OUI:%@", ouiModel.description);
    self.resultOUI = ouiModel;
    
    [self.tableView reloadData];

    // 搜索不到时,提示用户去反馈
    if (!ouiModel) {
        BTS_WEAK_SELF;
        [UIAlertController showAlertWithTitle:nil message:BTSLocalizedString(@"Find network card address failed and feedback", nil) firstTitle:BTSLocalizedString(@"Feedback2", nil) firstHandler:^(UIAlertAction *action) {
            FeedbackViewController *vc = [[FeedbackViewController alloc] init];
            vc.macAddress = text;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } cancelHandler:nil toController:weakSelf];
    }
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.resultOUI) {
        return 7;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OUIInfoCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OUIInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OUIInfoCellID];
    cell.infoType = [OUIInfoCell infoTypeForOUIInfoWihtIndex:indexPath.row];
    cell.ouiModel = self.resultOUI;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    OUIInfoType infoType = [OUIInfoCell infoTypeForOUIInfoWihtIndex:indexPath.row];
    if (infoType == OUIInfoCompany) {
        CompanyWebsiteViewController *vc = [[CompanyWebsiteViewController alloc] init];
        vc.company = self.resultOUI.company;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self queryOUIWithText:textField.text];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Getters

- (UIBarButtonItem *)rightBarButton {
    if (!_rightBarButton) {
//    _rightBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(clickRightBarButton)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button addTarget:self action:@selector(clickRightBarButton) forControlEvents:UIControlEventTouchUpInside];
        
        LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"animation_scan_2"];
        animationView.frame = CGRectMake(7, 7, 30, 30);
        animationView.contentMode = UIViewContentModeScaleToFill;
        animationView.loopAnimation = YES;
        animationView.userInteractionEnabled = NO;
        [button addSubview:animationView];
        self.rightBarAnimationView = animationView;
        [animationView play];
        
        _rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _rightBarButton;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
