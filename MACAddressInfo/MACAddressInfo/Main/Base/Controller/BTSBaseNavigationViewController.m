//
//  BTSBaseNavigationViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseNavigationViewController.h"

@interface BTSBaseNavigationViewController ()

@end

@implementation BTSBaseNavigationViewController

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    [self setupUI];
}


#pragma mark - Data

- (void)setupData {
    
}


#pragma mark - UI

- (void)setupUI {
    [self setupNavBarAppearance];
}

/// 设置导航栏显示效果
- (void)setupNavBarAppearance {
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor whiteColor];
//        appearance.backgroundImage = [UIImage imageNamed:@"xxx"];
//        appearance.shadowColor = [UIColor clearColor];
//        appearance.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: RGB(164, 164, 164)};
//        [appearance setBackIndicatorImage:[UIImage imageNamed:@"xx"] transitionMaskImage:[UIImage imageNamed:@"xxx"]];
        // 常规页面
        self.navigationBar.standardAppearance = appearance;
        // 带Scroll滑动的页面
        self.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        // 设置导航栏 颜色 及 是否半透明
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTintColor:RGB(164, 164, 164)];
    //    [[UINavigationBar appearance] setTranslucent:NO];
        
        // 设置导航栏标题的 字体 和 颜色
//        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: RGB(164, 164, 164)}];

        // 隐藏分割线
//        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//
//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_icon_back_black"]];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_icon_back_black"]];
    }
}


#pragma mark - Override

// Push时隐藏TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
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
