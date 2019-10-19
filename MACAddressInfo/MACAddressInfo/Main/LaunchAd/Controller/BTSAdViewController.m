//
//  BTSAdViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/9.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSAdViewController.h"
#import "BTSAdDetailViewController.h"
#import "AppDelegate.h"
#import "CommonFile.h"
#import <Lottie/Lottie.h>

@interface BTSAdViewController ()

@property (nonatomic, assign) BTSADCloseType closeType;
@property (nonatomic, weak) IBOutlet UIImageView *adImageView; // 广告图片
@property (nonatomic, weak) IBOutlet UIButton *skipButton; // 跳过按钮
@property (nonatomic, weak) IBOutlet UILabel *adMarkLabel; // 广告标志Label
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *skipButtonTop;

@property (nonatomic, strong) LOTAnimationView *animationView;

@property (nonatomic, strong) NSTimer *adTimer;
@property (nonatomic, assign) NSInteger adDisplayDuration;
@property (nonatomic, copy) NSString *urlString;

@end

@implementation BTSAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    [self loadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.adTimer invalidate];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - UI

- (void)loadUI {
    self.skipButtonTop.constant = 15 + BTSNavBarHeightAdded;
    
    // 添加阴影效果
    self.adMarkLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.adMarkLabel.layer.shadowOffset = CGSizeMake(0,0);
    self.adMarkLabel.layer.shadowOpacity = 0.8;
    self.adMarkLabel.layer.shadowRadius = 2;
    self.adMarkLabel.text = BTSLocalizedString(@"<AD>", nil);
    self.adMarkLabel.hidden = YES;
    
//    UIImage *adImage = [UIImage imageNamed:@"Ad_HomePod"];
//    self.adImageView.image = [adImage imageCompressEqualProportionWithSize:CGSizeMake(BTSWIDTH, BTSHEIGHT - 99)];

    // 启动时的Lottie动画
    [self loadLottieAnimation];
}


#pragma mark - Data

- (void)loadData {
    self.closeType = BTSADCloseTypeWait;
//    self.adDisplayDuration = LaunchAdDuration;
}

- (void)adDisplaying {
    self.adDisplayDuration--;
    
    if (self.adDisplayDuration >= 0) {
        NSString *title = [NSString stringWithFormat:@"%ld %@", self.adDisplayDuration, BTSLocalizedString(@"skip", nil)];
        [self.skipButton setTitle:title forState:UIControlStateNormal];
    } else {
        [self adDisplayFinish];
    }
}

- (void)loadLottieAnimation {
    // 1. 从plist文件中加载国家代码数据
    NSArray *animations = [NSArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LaunchAnimations" ofType:@"plist"];
    if (@available(iOS 11.0, *)) {
        NSError *error = nil;
        animations = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        if (error) {
            NSLog(@"加载LaunchAnimations.plist失败,error:%@", error.description);
        } else {
            NSLog(@"加载LaunchAnimations.plist成功!");
        }
    } else {
        animations = [NSArray arrayWithContentsOfFile:filePath];
    }


    // 随机显示某一个动画
    NSUInteger count = animations.count;
    NSUInteger index = arc4random() % count;
    if (count == 0) { // plist文件解析失败时,指定默认动画
        index = 0;
    }
//    index = 0;
    NSDictionary *animationDic = animations[index];


    /*********** 动画的信息 **********/
    NSString *animationName = animationDic[@"name"]; // 动画名称
    UIColor *backgroundColor = [UIColor whiteColor]; // 背景颜色(默认白色)
    CGFloat width = [animationDic[@"width"] floatValue]; // 宽
    CGFloat ratio_w_h = [animationDic[@"ratio_w_h"] floatValue]; // 宽高比
    NSUInteger duration = [animationDic[@"duration"] integerValue]; // 时长
    NSString *url = animationDic[@"url"]; // 动画详情链接

    NSString *colorString = animationDic[@"backgroundColor"];
    NSArray *rgbArr = [colorString componentsSeparatedByString:@","];
    if (rgbArr.count == 3) {
        UInt8 red = [rgbArr[0] intValue];
        UInt8 green = [rgbArr[1] intValue];
        UInt8 blue = [rgbArr[2] intValue];
        backgroundColor = RGB(red, green, blue);
    }
    self.adDisplayDuration = duration;
    self.urlString = url;

    CGFloat animationW = width == 0 ? BTSWIDTH : width;
    CGFloat animationH = animationW / ratio_w_h;
    CGFloat animationX = (BTSWIDTH - animationW) / 2.0;
    CGFloat animationY = (BTSHEIGHT - BTSNavBarHeightAdded - animationH - 99 - BTSTabBarHeightAdded) / 2.0;
    self.animationView.frame = CGRectMake(animationX, animationY, animationW, animationH);
    self.animationView.backgroundColor = backgroundColor;
    [self.animationView setAnimationNamed:animationName];
    [self.view addSubview:self.animationView];
    [self.animationView play];


    NSString *title = [NSString stringWithFormat:@"%ld %@", self.adDisplayDuration, BTSLocalizedString(@"skip", nil)];
    [self.skipButton setTitle:title forState:UIControlStateNormal];

    self.adTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(adDisplaying) userInfo:nil repeats:YES];
}


#pragma mark - Events

/** 点击了跳过广告 */
- (IBAction)clickSkipAd:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate switchToTabBarController];
}

/** 点击了广告 */
- (IBAction)clickAd:(id)sender {
//    self.closeType = BTSADCloseTypeClick;
//
//    // 1. 先切换至TabBar控制器
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate switchToTabBarController];
//
//    // 2. 再Push广告详情页面
//    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UITabBarController *tabBarVC = (UITabBarController *)rootVC;
//    UIViewController *topVC = tabBarVC.viewControllers.firstObject;
//    if ([topVC isKindOfClass:[UINavigationController class]]) {
//        UINavigationController *nav = (UINavigationController *)topVC;
//
//        BTSAdDetailViewController *vc = [[BTSAdDetailViewController alloc] init];
//        vc.urlString = self.urlString;
//        [nav pushViewController:vc animated:YES];
//    }
}

/** 广告展示完成 */
- (void)adDisplayFinish {
    if (self.closeType == BTSADCloseTypeSkip || self.closeType == BTSADCloseTypeClick) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate switchToTabBarController];
    });
}


#pragma mark - Getters

- (LOTAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [[LOTAnimationView alloc] init];
        _animationView.contentMode = UIViewContentModeScaleToFill;
        _animationView.loopAnimation = YES;
        _animationView.userInteractionEnabled = NO;
    }
    return _animationView;
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
