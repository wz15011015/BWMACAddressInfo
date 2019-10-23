//
//  CompanyLocationViewController.m
//  MACAddressInfo
//
//  Created by hadlinks on 2019/10/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CompanyAnnotation.h"
#import "CompanyAnnotationView.h"

@interface CompanyLocationViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation CompanyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 标题
    self.title = self.company.name_local;
    
    // MKMapView相关设置
    self.mapView.delegate = self;
    self.mapView.showsBuildings = YES;
    
    
    if ([self.company.name_local isEqualToString:@"苹果公司"] ||
        [self.company.name_local isEqualToString:@"Apple, Inc."]) { // Apple
        CLLocation *location = [[CLLocation alloc] initWithLatitude:37.33233141 longitude:-122.03121860];
        [self updateMapViewDisplayWithLocation:location];
        [self addCompanyAnnotationWithLocation:location];
        
    } else {
        // 地理编码获取经纬度
        NSString *address = @"";
        if ([self.company.countryCode isEqualToString:@"CN"] ||
            [self.company.countryCode isEqualToString:@"TW"] ||
            [self.company.countryCode isEqualToString:@"HK"]) { // 中国
            address = [NSString stringWithFormat:@"%@%@%@%@", self.company.country_zh, self.company.province_zh, self.company.city_zh, self.company.street_zh];
        } else {
    //        address = [NSString stringWithFormat:@"%@ %@ %@", self.company.city, self.company.province, self.company.country];
            address = [NSString stringWithFormat:@"%@ %@ %@", self.company.country, self.company.province, self.company.city];

        }
        NSLog(@"地理编码_地址: %@", address);
        [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count < 1) { // 失败
                NSLog(@"地理编码_失败,error: %@", error.localizedDescription);
                return;
            }
            
            CLPlacemark *placemark = placemarks.firstObject;
            // 地址信息
            NSString *country = placemark.country; // 国家
            NSString *province = placemark.administrativeArea; // 行政区/省
            NSString *city = placemark.locality; // 城市
            NSString *district = placemark.subLocality; // 区
            NSString *streetName = placemark.thoroughfare; // 街道名称
            NSString *streetNumber = placemark.subThoroughfare; // 街道编号
            NSString *street = placemark.name; // 街道名称 + 街道编号
            // 位置信息
            CLLocation *location = placemark.location;
            NSLog(@"地理编码_结果: %@-%@-%@-%@-%@(%@-%@) (%f, %f)", country, province, city, district, street, streetName, streetNumber, location.coordinate.longitude, location.coordinate.latitude);
            
            // 添加大头针
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateMapViewDisplayWithLocation:location];
                [self addCompanyAnnotationWithLocation:location];
            });
        }];
    }
}

- (void)updateMapViewDisplayWithLocation:(CLLocation *)location {
    /// 首先参考一个标准: 纬度是平行的,相邻的1度,其距离约等于111km.其次,经度是不平行的,
    /// 但是在0度纬线上的经度间隔是最远的.我们为了方便计算,直接使用0度纬线上的距离计算
    /// 经度间隔距离,也可以认为1度约等于111km.
    /// 因此,我们可以换算下小数点后第六位最大可以表示的实际距离是多少?
    /// 1度 ≈ 111000 m
    /// 0.000001度 ≈ 0.111 m
    /// 对于在线地图经纬度的读数,精确到小数点后第六位已经足够当前GPS精度下的使用.
    
    // 经纬度的跨度
    double delta = 0.2;
    MKCoordinateSpan span = MKCoordinateSpanMake(delta, delta);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    // 设置地图的显示区域
    [self.mapView setRegion:region animated:YES];
}

- (void)addCompanyAnnotationWithLocation:(CLLocation *)location {
    NSString *addressInfo = @"";
    if ([self.company.countryCode isEqualToString:@"CN"] ||
        [self.company.countryCode isEqualToString:@"TW"] ||
        [self.company.countryCode isEqualToString:@"HK"]) { // 中国
        addressInfo = [NSString stringWithFormat:@"%@%@%@", self.company.province_local, self.company.city_local, self.company.street_local];
    } else {
        addressInfo = [NSString stringWithFormat:@"%@ %@ %@", self.company.street_local, self.company.city_local, self.company.province_local];
    }
    
    CompanyAnnotation *annotation = [[CompanyAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    annotation.title = self.company.name_local;
    annotation.subtitle = addressInfo;
    [self.mapView addAnnotation:annotation];
}


#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    if (views.count == 1) {
        CompanyAnnotationView *annotationView = (CompanyAnnotationView *)views.firstObject;
        [mapView selectAnnotation:annotationView.annotation animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // 判断是否为用户当前位置大头针模型
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        CompanyAnnotationView *annotationView = (CompanyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:CompanyAnnotationID];
        if (!annotationView) {
            annotationView = [[CompanyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:CompanyAnnotationID];
        }
        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
}


#pragma mark - Getters

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
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
