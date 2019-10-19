//
//  CompanyOUIsCell.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyOUIsCell.h"
#import "Common.h"
#import <CoreMotion/CoreMotion.h>
#import <Lottie/Lottie.h>

NSString *const CompanyOUIsCellID = @"CompanyOUIsCellIdentifier";

static NSUInteger BallCountPerPage = 16; // 每次显示小球的数量

@interface CompanyOUIsCell ()

@property (nonatomic, weak) IBOutlet UIView *infoView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, weak) IBOutlet UIView *dynamicAnimatorView;

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, assign) NSUInteger maxPageNum; // 小球最多可以显示几次
@property (nonatomic, assign) NSUInteger currentPageNum; // 当前显示第几页(从第0页开始)
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator; // 物理仿真器(动画器)
@property (nonatomic, strong) CMMotionManager *motionManager; // 运动管理者
@property (nonatomic, strong) UIPushBehavior *pushBehavior; // 推动特性

@end

@implementation CompanyOUIsCell

- (void)dealloc {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToList)];
    [self.infoView addGestureRecognizer:tapGestureRecognizer];
    
//    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushBallEvent:)];
//    [self.dynamicAnimatorView addGestureRecognizer:tapGestureRecognizer2];
    
    // 添加Lottie动画
    LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"animation_jump"];
    animationView.frame = CGRectMake(0, 0, 90, 90);
    animationView.contentMode = UIViewContentModeScaleToFill;
    animationView.loopAnimation = YES;
    animationView.userInteractionEnabled = NO;
    [self.refreshButton addSubview:animationView];
    [animationView play];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)startAnimation {
//    if (self.dynamicAnimator.isRunning) { // 动画器正在执行动画中,则返回
//        return;
//    }
    
    // 添加触感反馈
    [BTSUtil generateImpactFeedbackWithStyle:UIImpactFeedbackStyleMedium];
    
    // 1. 小球数据的处理
    // 1.1 小球数据的清空处理
    [self endAnimation];
    
    // 1.2 小球数据的添加
    NSUInteger ouiCount = self.company.ouiList.count;
    
    CGFloat ballW = 36.0;
    // 根据小球大小和屏幕宽度,计算最多可显示几列
    NSUInteger column = (NSUInteger)floor(BTSWIDTH / ballW);
    NSUInteger startIndex = self.currentPageNum * BallCountPerPage;
    NSUInteger endIndex = (self.currentPageNum + 1) * BallCountPerPage;
    endIndex = endIndex > ouiCount ? ouiCount : endIndex;

    for (int i = (int)startIndex; i < endIndex; i++) {
        NSString *ouiCode = self.company.ouiList[i];

        CGFloat x = (i % column) * ballW;
        CGFloat y = (i / (column - (self.currentPageNum * BallCountPerPage))) * ballW;
        UILabel *ball = [[UILabel alloc] initWithFrame:CGRectMake(x, y, ballW, ballW)];
        ball.textColor = [UIColor whiteColor];
        ball.font = [UIFont boldSystemFontOfSize:8];
        ball.textAlignment = NSTextAlignmentCenter;
        ball.backgroundColor = THEME_COLOR;
        ball.layer.cornerRadius = ballW / 2.0;
        ball.layer.masksToBounds = YES;
        ball.text = ouiCode;
        [self.dynamicAnimatorView addSubview:ball];

        [self.balls addObject:ball];
    }

    // 2. 动画效果实现
    // 2.1 初始化物理仿真器(动画器),已懒加载实现
    // 2.2 添加物理仿真特性
    // 2.2.1 重力特性
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.balls];
    [self.dynamicAnimator addBehavior:gravityBehavior];
    // 2.2.2 碰撞特性
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.balls];
    // 设置碰撞效果
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeEverything];
    // 设置边界为动画器参考view的视图范围
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:collisionBehavior];
    // 2.2.3 弹性特性
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.balls];
    // 允许旋转
    dynamicItemBehavior.allowsRotation = YES;
    // 弹性
    dynamicItemBehavior.elasticity = 0.5;
    [self.dynamicAnimator addBehavior:dynamicItemBehavior];
    // 2.2.4 推动特性
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:self.balls mode:UIPushBehaviorModeContinuous];
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    // 2.3 运动管理者,监听手机的运动状态来更新小球的运动
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        // 姿态角: http://www.cnblogs.com/xiaoxiaoqingyi/p/6932008.html
        // 姿态角
//        CMAttitude *attitude = motion.attitude;
//        double yaw = attitude.yaw; // 偏航角ψ（yaw）：围绕Z轴旋转的角度
//        double pitch = attitude.pitch; // 俯仰角θ（pitch）：围绕Y轴旋转的
//        double roll = attitude.roll; // 滚转角Φ（roll）：围绕X轴旋转的角度
//        NSLog(@"yaw:%.6f pitch:%.6f roll:%.6f", yaw, pitch, roll);

        double rotation = atan2(motion.attitude.pitch, motion.attitude.roll);
        // 重力特性的角度
        gravityBehavior.angle = rotation;
    }];
}

- (void)endAnimation {
    [self.motionManager stopDeviceMotionUpdates];
    [self.dynamicAnimator removeAllBehaviors];
    
    // 小球数据的清空处理
    for (UIView *ball in self.balls) {
        [ball removeFromSuperview];
    }
    [self.balls removeAllObjects];
}


#pragma mark - Events

/** 跳转到OUI列表页面 */
- (void)jumpToList {
    if (self.jumpToListBlock) {
        self.jumpToListBlock();
    }
}

/** 刷新动画器的显示 */
- (IBAction)refreshAnimatorDisplay {
    self.currentPageNum++;
    if (self.currentPageNum > (self.maxPageNum - 1)) {
        self.currentPageNum = 0;
    }
    
    [self startAnimation];
}

//- (void)pushBallEvent:(UITapGestureRecognizer *)gestureRecognizer {
////    if (!self.dynamicAnimator.isRunning) { // 如果动画器未执行动画,则返回
////        return;
////    }
//
//    CGPoint offset = CGPointMake(0, 50);
//
//    CGFloat angle = -atan2f(offset.y, -offset.x);
//    CGFloat magnitude = sqrtf(offset.x * offset.x + offset.y * offset.y) / 50;
//    // 角度,默认是0,如果要配置力矢量UIPushBehavior，必须要设置magnitude和angle两个属性
//    self.pushBehavior.angle = angle;
//    // 推动特性的力矢量的大小,默认是nil,若为负则是力的反方向
//    self.pushBehavior.magnitude = magnitude;
//}


#pragma mark - Setters

- (void)setCompany:(CompanyModel *)company {
    _company = company;
    
    self.infoLabel.text = [NSString stringWithFormat:BTSLocalizedString(@"The company has applied for a total of %ld OUI", nil), company.ouiCount];
    
    NSUInteger ouiCount = self.company.ouiList.count;
    // 计算最多显示几页
    self.maxPageNum = (NSUInteger)ceil(ouiCount / (BallCountPerPage * 1.0));
    // 从第0页开始
    self.currentPageNum = 0;
    
    [self startAnimation];
}


#pragma mark - Getters

- (NSMutableArray *)balls {
    if (!_balls) {
        _balls = [NSMutableArray array];
    }
    return _balls;
}

- (UIDynamicAnimator *)dynamicAnimator {
    if (!_dynamicAnimator) {
        // 初始化物理仿真器(动画器)
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.dynamicAnimatorView];
    }
    return _dynamicAnimator;
}

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.01;
    }
    return _motionManager;
}

@end
