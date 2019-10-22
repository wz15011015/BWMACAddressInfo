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
    
    [self customNavigationBar];
}

// 自定义导航栏属性
- (void)customNavigationBar {
    // 1. 导航栏背景颜色
//    [UINavigationBar appearance].barTintColor = NAV_BAR_COLOR;
    // 2. 导航栏标题的字体大小和颜色
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]}];
    // 3. 导航栏着色颜色
//    [UINavigationBar appearance].tintColor = THEME_COLOR;
    // 4. 导航栏是否为半透明效果
    [UINavigationBar appearance].translucent = NO;
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
