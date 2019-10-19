//
//  BTSBaseViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSBaseViewController.h"

@interface BTSBaseViewController ()

@end

@implementation BTSBaseViewController

- (void)dealloc {
    NSLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customBackBarButtonItem];
}

/** 自定义导航栏返回按钮(backBarButtonItem) */
- (void)customBackBarButtonItem {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
//    [backBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: THEME_COLOR} forState:UIControlStateNormal];
    backBarButtonItem.tintColor = THEME_COLOR;
    backBarButtonItem.title = BTSLocalizedString(@"Back", nil);
//    backBarButtonItem.image = [UIImage imageNamed:@""];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
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
