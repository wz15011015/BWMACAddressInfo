//
//  DeviceMACViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/8.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "DeviceMACViewController.h"
#import "Common.h"
#import "OUIModel.h"
#import "OUIInfoCell.h"
#import "MACTableHeaderView.h"
#import "CompanyWebsiteViewController.h"
#import "CompanyLocationViewController.h"

@interface DeviceMACViewController () <NetworkManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *scanView;
@property (nonatomic, weak) IBOutlet UIImageView *scanIcon;
@property (nonatomic, weak) IBOutlet UILabel *scanHintLabel;
@property (nonatomic, strong) MACTableHeaderView *tableHeaderView;

@property (nonatomic, assign) BOOL WiFiAvailable; // WiFi连接是否可用
@property (nonatomic, copy) NSString *macAddress; // 设备的MAC地址
@property (nonatomic, strong) OUIModel *resultOUI; // 搜索到的OUI

@end

@implementation DeviceMACViewController

- (void)dealloc {
    // 注销网络状态发生变化的代理
    [NetworkManagerInstance removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadUI];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"Device Network Card Address", nil);
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
    self.tableView.hidden = YES;
    
    self.scanView.hidden = NO;
    self.scanHintLabel.text = BTSLocalizedString(@"Click to get this device network card address", nil);
}

- (void)startAnimationTransformRotationZ {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.4;
    animation.repeatCount = HUGE;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    [self.scanIcon.layer addAnimation:animation forKey:@"TransformRotationAnimation"];
}

- (void)stopAnimationTransformRotationZ {
    [self.scanIcon.layer removeAnimationForKey:@"TransformRotationAnimation"];
}


#pragma mark - Data

// 数据初始化
- (void)loadData {
    // 注册网络状态发生变化的代理
    [NetworkManagerInstance addDelegate:self];
    
    self.WiFiAvailable = NetworkManagerInstance.wifiAvailable;
}

- (void)scanFinish {
    // 停止旋转动画
    [self stopAnimationTransformRotationZ];
    
    // WiFi连接不可用
    if (!self.WiFiAvailable) {
        self.scanHintLabel.text = BTSLocalizedString(@"Please connect to the WiFi network and try again", nil);
        return;
    }
    
    if (IS_IPHONE_SIMULATOR) {
        NSLog(@"iPhone模拟器不可用");
        return;
    }
    
    // 获取设备的MAC地址
    self.macAddress = [MacAddressManager getMacAddressFromMDNS];
    self.macAddress = @"F0:76:6F:07:6F:CE";
    if (IS_NULL_STRING(self.macAddress)) {
        self.scanHintLabel.text = BTSLocalizedString(@"Failed to get device network card address", nil);
        return;
    }
    NSLog(@"成功获取本机MAC地址: %@", self.macAddress);
    
    // 解析MAC地址的OUI
    NSString *ouiCode = [self.macAddress substringWithRange:NSMakeRange(0, 8)];
    OUIModel *ouiModel = [DatabaseManagerInstance queryOUIWithOUICode:ouiCode];
    self.resultOUI = ouiModel;
    
    if (self.resultOUI) {
        self.scanView.hidden = YES;
        self.tableView.hidden = NO;
        
        self.tableHeaderView.macAddress = self.macAddress;
        
        [self.tableView reloadData];
    } else {
        self.scanView.hidden = NO;
        self.tableView.hidden = YES;
    }
}


#pragma mark - Events

- (IBAction)clickScanView {
    [self startAnimationTransformRotationZ];
    [self performSelector:@selector(scanFinish) withObject:nil afterDelay:1.8];
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
    } else if (infoType == OUIInfoStreet) {
        CompanyLocationViewController *vc = [[CompanyLocationViewController alloc] init];
        vc.company = self.resultOUI.company;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - NetworkUtilDelegate 用户网络连接状态发生变化

- (void)networkManager:(NetworkManager *)manager networkStatusChanged:(NetworkStatus)status {
    self.WiFiAvailable = (status == ReachableViaWiFi);
}


#pragma mark - Getters

- (MACTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MACTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, BTSWIDTH, MACTableHeaderViewH_Device) viewType:MACTableHeaderViewDevice];
    }
    return _tableHeaderView;
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
