//
//  WiFiMACViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/8.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "WiFiMACViewController.h"
#import "Common.h"
#import "OUIModel.h"
#import "OUIInfoCell.h"
#import "MACTableHeaderView.h"
#import "CompanyWebsiteViewController.h"
#import "CompanyLocationViewController.h"
#import "FeedbackViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface WiFiMACViewController () <NetworkManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *scanView;
@property (nonatomic, weak) IBOutlet UIImageView *scanIcon;
@property (nonatomic, weak) IBOutlet UILabel *scanHintLabel;
@property (nonatomic, strong) MACTableHeaderView *tableHeaderView;

@property (nonatomic, assign) BOOL WiFiAvailable; // WiFi连接是否可用
@property (nonatomic, copy) NSString *wifiName; // WiFi的名称
@property (nonatomic, copy) NSString *wifiMACAddress; // WiFi的MAC地址
@property (nonatomic, strong) OUIModel *resultOUI; // 搜索到的OUI

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation WiFiMACViewController

- (void)dealloc {
    // 注销网络状态发生变化的代理
    [NetworkManagerInstance removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self loadUI];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"WiFi Network Card Address", nil);
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
    self.tableView.hidden = YES;
    
    self.scanView.hidden = NO;
    self.scanHintLabel.text = BTSLocalizedString(@"Click to get the network card address of native connected WiFi", nil);
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
    
    if (@available(iOS 13.0, *)) {
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        // 适配iOS 13: 判断定位权限,如果未授权,则提示用户去授权定位,以便获取WiFi名称
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) { // 未决定时,去请求定位权限
            [self.locationManager requestWhenInUseAuthorization];
        } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) { // 拒绝或受限制时,弹窗提示
            [self showLocationAuthorizationAlert];
        } else { // 已允许定位
            
        }
    }
    
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
    
    // 获取WiFi的名称和MAC地址
    self.wifiName = [WiFiManagerInstance wifiName];
    self.wifiMACAddress = [WiFiManagerInstance wifiMacAddress];
    self.wifiName = @"CMCC-BTStudio";
    self.wifiMACAddress = @"D4:40:F0:9A:02:A8";
    if (IS_NULL_STRING(self.wifiMACAddress)) {
        self.scanHintLabel.text = BTSLocalizedString(@"Failed to get WiFi network card address", nil);
        return;
    }
    
    // 解析MAC地址的OUI
    NSString *ouiCode = [self.wifiMACAddress substringWithRange:NSMakeRange(0, 8)];
    OUIModel *ouiModel = [DatabaseManagerInstance queryOUIWithOUICode:ouiCode];
    self.resultOUI = ouiModel;
    
    BOOL success = NO;
    if (!IS_NULL_STRING(self.wifiMACAddress) || self.resultOUI) {
        success = YES;
    }
    if (success) {
        self.scanView.hidden = YES;
        self.tableView.hidden = NO;
        
        self.tableHeaderView.wiFiName = self.wifiName;
        self.tableHeaderView.macAddress = self.wifiMACAddress;
        
        if (!self.resultOUI) {
            [self.tableHeaderView updateHintDisplayWithHint:BTSLocalizedString(@"Query network card manufacturer information failed according to network card address", nil)];

            // 搜索不到时,提示用户去反馈
            BTS_WEAK_SELF;
            [UIAlertController showAlertWithTitle:nil message:BTSLocalizedString(@"Find network card address failed and feedback", nil) firstTitle:BTSLocalizedString(@"Feedback2", nil) firstHandler:^(UIAlertAction *action) {
                FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                vc.macAddress = self.wifiMACAddress.uppercaseString; // 转成大写字母
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } cancelHandler:nil toController:weakSelf];
        }
        
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

// 显示位置授权提示窗
- (void)showLocationAuthorizationAlert {
    [UIAlertController showAlertWithTitle:BTSLocalizedString(@"Tips", nil)
                                  message:BTSLocalizedString(@"Please allow your location information to be used to get information about wiFi connected to your machine.", nil)
                               firstTitle:BTSLocalizedString(@"OK", nil)
                             firstHandler:^(UIAlertAction *action) {
                                 [BTSUtil jumpToApplicationSettingPage];
                             }
                            cancelHandler:nil
                             toController:self];
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


#pragma mark - CLLocationManagerDelegate

// 定位授权状态发生改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    /// iOS 13 之前:
    /// kCLAuthorizationStatusAuthorizedAlways :  始终允许
    /// kCLAuthorizationStatusAuthorizedWhenInUse :  仅在使用应用期间
    /// kCLAuthorizationStatusDenied :  不允许
    ///
    /// iOS 13 及之后:
    /// kCLAuthorizationStatusAuthorizedAlways :  使用App时允许
    /// kCLAuthorizationStatusAuthorizedWhenInUse :  允许一次
    /// kCLAuthorizationStatusDenied :  不允许
    if (kCLAuthorizationStatusNotDetermined == status) { // 正在请求权限,未决定
            
    } else if (kCLAuthorizationStatusRestricted == status || kCLAuthorizationStatusDenied == status) { // 拒绝定位
        // 用户拒绝时,则弹窗提示
        [self showLocationAuthorizationAlert];
    } else { // 允许定位
        
    }
}


#pragma mark - Notification

/** 进入前台时调用此函数 */
- (void)applicationWillEnterForeground {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) { // 未决定时,去请求定位权限
        [self.locationManager requestWhenInUseAuthorization];
    }
}


#pragma mark - Getters

- (MACTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MACTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, BTSWIDTH, MACTableHeaderViewH_WiFi) viewType:MACTableHeaderViewWiFi];
    }
    return _tableHeaderView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
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
