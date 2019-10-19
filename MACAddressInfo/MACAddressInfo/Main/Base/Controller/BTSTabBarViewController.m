//
//  BTSTabBarViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSTabBarViewController.h"
#import "BTSBaseNavigationViewController.h"
#import "MACViewController.h"
#import "StatisticsViewController.h"
#import "MoreViewController.h"

@interface BTSTabBarViewController ()

@end

@implementation BTSTabBarViewController

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建导航控制器
    MACViewController *macVC = [[MACViewController alloc] init];
    [self addChildViewController:macVC tabBarTitle:BTSLocalizedString(@"Network Card Address", nil) navBarTitle:BTSLocalizedString(@"Network Card Address", nil) imageName:@"tab_bar_network_card" selectedImageName:@"tab_bar_network_card_selected"];
    
    StatisticsViewController *statisticsVC = [[StatisticsViewController alloc] init];
    [self addChildViewController:statisticsVC tabBarTitle:BTSLocalizedString(@"Statistics", nil) navBarTitle:BTSLocalizedString(@"Statistics", nil) imageName:@"tab_bar_statistics" selectedImageName:@"tab_bar_statistics_selected"];
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self addChildViewController:moreVC tabBarTitle:BTSLocalizedString(@"More", nil) navBarTitle:BTSLocalizedString(@"More", nil) imageName:@"tab_bar_more" selectedImageName:@"tab_bar_more_selected"];
}

- (void)addChildViewController:(UIViewController *)childController tabBarTitle:(NSString *)tabBarTitle navBarTitle:(NSString *)navBarTitle imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    BTSBaseNavigationViewController *nav = [[BTSBaseNavigationViewController alloc] initWithRootViewController:childController];
    nav.title = navBarTitle;
    // navigationBar设置
//    nav.navigationBar.translucent = NO;
//    nav.navigationBar.tintColor = THEME_COLOR;
//    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : THEME_COLOR}];
//    nav.navigationBar.barTintColor = THEME_COLOR;
    
    // tabBarItem设置
    nav.tabBarItem.title = tabBarTitle;
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字颜色
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(164, 164, 164)} forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: THEME_COLOR} forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
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
