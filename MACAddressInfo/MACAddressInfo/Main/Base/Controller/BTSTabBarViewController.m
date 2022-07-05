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
    
    [self setupData];
    [self setupUI];
    
    // 创建导航控制器
    MACViewController *macVC = [[MACViewController alloc] init];
    [self addChildViewController:macVC tabBarTitle:BTSLocalizedString(@"Network Card Address", nil) navBarTitle:BTSLocalizedString(@"Network Card Address", nil) imageName:@"tab_bar_network_card" selectedImageName:@"tab_bar_network_card_selected"];
    
    StatisticsViewController *statisticsVC = [[StatisticsViewController alloc] init];
    [self addChildViewController:statisticsVC tabBarTitle:BTSLocalizedString(@"Statistics", nil) navBarTitle:BTSLocalizedString(@"Statistics", nil) imageName:@"tab_bar_statistics" selectedImageName:@"tab_bar_statistics_selected"];
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self addChildViewController:moreVC tabBarTitle:BTSLocalizedString(@"More", nil) navBarTitle:BTSLocalizedString(@"More", nil) imageName:@"tab_bar_more" selectedImageName:@"tab_bar_more_selected"];
    
    
    // 适配处理:
    // 在iOS13及以后系统中 未选中TabBar按钮 的文字显示为蓝色, 即使设置了UIControlStateNormal状态时的颜色,
    // 针对该问题,需要调用 setUnselectedItemTintColor: 方法设置未选中tabBarItem的文字颜色.
    if (@available(iOS 13.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:RGB(164, 164, 164)];
    }
}


#pragma mark - Data

- (void)setupData {
    
}


#pragma mark - UI

- (void)setupUI {
    [self setupTabBarAppearance];
}

/// 设置TabBar显示效果
- (void)setupTabBarAppearance {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, SCREEN_WIDTH, 0.5)];
//    view.backgroundColor = VCWhiteColor;
//    [[UITabBar appearance] insertSubview:view atIndex:0];
    
    if (@available(iOS 13.0, *)) {
        // 设置TabBarItem字体颜色
        UITabBarItemAppearance *itemAppearance = [[UITabBarItemAppearance alloc] init];
        itemAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : RGB(164, 164, 164)};
        itemAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName : THEME_COLOR};

        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.stackedLayoutAppearance = itemAppearance;
        appearance.backgroundColor = [UIColor whiteColor];
//        appearance.backgroundImage = [UIImage imageNamed:@"navigation_bar_white"];
//        appearance.shadowColor = [UIColor clearColor];
        // 常规页面
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            // 带Scroll滑动的页面
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    } else {
        // 设置TabBar的颜色 及 是否半透明
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setTintColor:RGB(164, 164, 164)];
        [[UITabBar appearance] setTranslucent:NO];
    
        // 设置TabBar的标题 字体 和 颜色
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(164, 164, 164)} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : THEME_COLOR} forState:UIControlStateSelected];
    }
}

- (void)addChildViewController:(UIViewController *)childController tabBarTitle:(NSString *)tabBarTitle navBarTitle:(NSString *)navBarTitle imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    BTSBaseNavigationViewController *nav = [[BTSBaseNavigationViewController alloc] initWithRootViewController:childController];
    nav.title = navBarTitle;
    
    // tabBarItem设置
    nav.tabBarItem.title = tabBarTitle;
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
