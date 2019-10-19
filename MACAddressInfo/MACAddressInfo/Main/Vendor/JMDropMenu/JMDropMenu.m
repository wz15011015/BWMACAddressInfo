//
//  JMDropMenu.m
//  JMDropMenu
//
//  Created by JM on 2017/12/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "JMDropMenu.h"
#import "UIImage+Extension.h"

#define kWindow [UIApplication sharedApplication].keyWindow
#define kCellIdentifier @"cellIdentifier"
#define kDropMenuCellID @"DropMenuCellID"

@interface JMDropMenu() <UITableViewDelegate, UITableViewDataSource, CAAnimationDelegate>

/** 蒙版 */
@property (nonatomic, strong) UIView *cover;
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 存放标题和图片数组 */
@property (nonatomic, strong) NSMutableArray *titleImageArrM;
/** rowHeight */
@property (nonatomic, assign) CGFloat rowHeight;
/** rgb的可变数组 */
@property (nonatomic, strong) NSMutableArray *RGBStrValueArr;
/** 类型(qq或者微信) */
@property (nonatomic, assign) JMDropMenuType type;

/** 是否使用自定义动画 */
@property (nonatomic, assign) BOOL customAnimationEnable;
/** 不可点击Cell的indexPath数组 */
@property (nonatomic, strong) NSMutableArray *disabledIndexPathArr;

@end

@implementation JMDropMenu

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        // 初始化赋值
        _arrowOffset = arrowOffset;
        _type = type;
        _LayoutType = layoutType;
        _rowHeight = rowHeight;
        _delegate = delegate;
        
        _customAnimationEnable = YES;
        _disabledTitleColor = [UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1.0];
        _disabledImageColor = [UIColor colorWithRed:240 / 255.0 green:190 / 255.0 blue:163 / 255.0 alpha:1.0];
        
        // 类型判断
        if (type == JMDropMenuTypeWeChat) {
            self.RGBStrValueArr = [NSMutableArray arrayWithObjects:@(54), @(54), @(54), nil];
            _titleColor = [UIColor whiteColor];
            _lineColor = [UIColor whiteColor];
        } else {
            self.RGBStrValueArr = [NSMutableArray arrayWithObjects:@(255), @(255), @(255), nil];
            _titleColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1.0];
            _lineColor = [UIColor colorWithRed:210 / 255.0 green:210 / 255.0 blue:210 / 255.0 alpha:1.0];
        }
        // 字典转模型
        for (int i = 0; i < titleArr.count; i++) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setObject:titleArr[i] forKey:@"title"];
            if (i != imageArr.count) {
                [tempDict setObject:imageArr[i] forKey:@"image"];
            }
            [tempDict setObject:@(layoutType) forKey:@"layoutType"];
            [tempDict setObject:@(type) forKey:@"type"];
            
            JMDropMenuModel *model = [JMDropMenuModel dropMenuWithDictonary:tempDict];
            [self.titleImageArrM addObject:model];
        }
        
        // 通知的注册
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
        if (_customAnimationEnable) {
            // 自定义动画只适用于本App, 应用于其他地方时,需自己调整
            CGFloat width = frame.size.width;
            CGFloat height = frame.size.height;
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            self.frame = CGRectMake(x + (width / 2.0) - (width * (1.0 - ANCHOR_POINT_OFFSET_RATIO)), y - (height / 2.0), width, height);
        } else {
            self.frame = frame;
        }
        
        self.backgroundColor = [UIColor clearColor];
        // 添加子控件
        [self addSubview:self.tableView];
        
        // 1. 蒙白view添加到keyWindow上
        [kWindow addSubview:self.cover];
        
        // 2. self添加到keyWindow上
        [kWindow addSubview:self];
    }
    return self;
}

+ (instancetype)showDropMenuFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate {
    return [[self alloc] initWithFrame:frame ArrowOffset:arrowOffset TitleArr:titleArr ImageArr:imageArr Type:type LayoutType:layoutType RowHeight:rowHeight Delegate:delegate];
}

/**
 禁用某一菜单项的点击操作

 @param index 菜单项索引值
 */
- (void)disableMenuItemWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    // 判断是否已包含该indexPath,若未包含,再添加
    BOOL contains = [self containsIndexPath:indexPath];
    if (!contains) {
        [self.disabledIndexPathArr addObject:indexPath];
    }
}

/**
 判断不可响应点击事件的索引数组中是否包含indexPath
 
 @param indexPath 传入的索引值
 @return 是否包含
 */
- (BOOL)containsIndexPath:(NSIndexPath *)indexPath {
    __block BOOL contains = NO;
    NSArray *indexPaths = [NSArray arrayWithArray:self.disabledIndexPathArr];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *tempIndexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL equal = tempIndexPath.section == indexPath.section && tempIndexPath.row == indexPath.row;
        if (equal) {
            contains = YES;
            *stop = YES;
        }
    }];
    return contains;
}

/**
 判断indexPath对应的Cell是否可响应点击事件
 
 @param indexPath Cell的索引
 @return 是否可响应点击事件
 */
- (BOOL)isEnabledWithIndexPath:(NSIndexPath *)indexPath {
    // 如果包含,则不可响应点击事件;否则,可以响应.
    BOOL contains = [self containsIndexPath:indexPath];
    return !contains;
}


#pragma mark - Override

// MARK: 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect {
    // An opaque type that represents a Quartz 2D drawing environment.
    // 一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    /* 画三角形 */
    CGPoint sPoints[3]; // 坐标点
    sPoints[0] = CGPointMake(_arrowOffset, 0); // 坐标1
    sPoints[1] = CGPointMake(_arrowOffset - 8, 8); // 坐标2
    sPoints[2] = CGPointMake(_arrowOffset + 8, 8); // 坐标3
    CGContextAddLines(context, sPoints, 3); // 添加线
    // 填充色
    float r = [self.RGBStrValueArr[0] floatValue] / 255.0;
    float g = [self.RGBStrValueArr[1] floatValue] / 255.0;
    float b = [self.RGBStrValueArr[2] floatValue] / 255.0;
    UIColor *aColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);
    // 画线笔颜色
    CGContextSetRGBStrokeColor(context,r, g, b, 1.0); // 画笔线的颜色
    CGContextClosePath(context); // 封起来
    CGContextDrawPath(context, kCGPathFillStroke); // 根据坐标绘制路径
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if (_customAnimationEnable) {
        // 默认是以view的中心点为中心缩放的,如果需要自定义缩放点,可以设置锚点:中心点(0.5, 0.5)  左上角(0, 0)  左下角(0, 1)  右下角(1, 1)  右上角(1, 0)
        self.layer.anchorPoint = CGPointMake(ANCHOR_POINT_OFFSET_RATIO, 0);
        // 添加关键帧显示动画
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.25;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"]; // kCAMediaTimingFunctionEaseIn
        animation.values = values;
        [self.layer addAnimation:animation forKey:@"showAnimation"];
    } else {
        
    }
}


#pragma mark - Events
// MARK: 蒙版点击
- (void)tapCoverClick {
    if (_customAnimationEnable) {
        // 设置锚点
        self.layer.anchorPoint = CGPointMake(ANCHOR_POINT_OFFSET_RATIO, 0);
        // 添加关键帧隐藏动画
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.05, 0.05, 1.0)]];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.25;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        animation.values = values;
        [self.layer addAnimation:animation forKey:@"hideAnimation"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeDropMenu];
        });

    } else {
        [self removeDropMenu];
    }
}

// MARK: 隐藏蒙版
- (void)removeDropMenu {
    [self.tableView removeFromSuperview];
    [self.cover removeFromSuperview];
    [self removeFromSuperview];
}


#pragma mark - NSNotifications

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self removeDropMenu];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
//        [self removeDropMenu];
    }
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleImageArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMDropMenuCell *cell = [JMDropMenuCell dropMenuCellWithTableView:tableView];
    cell.model = self.titleImageArrM[indexPath.row];
    float r = [self.RGBStrValueArr[0] floatValue] / 255.0;
    float g = [self.RGBStrValueArr[1] floatValue] / 255.0;
    float b = [self.RGBStrValueArr[2] floatValue] / 255.0;
    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    cell.titleL.textColor = _titleColor;
    cell.line1.backgroundColor = _lineColor;
    
    // 判断该Cell是否可响应点击事件
    BOOL enable = [self isEnabledWithIndexPath:indexPath];
    if (!enable) { // 不可响应时,需调整图片和文字的颜色
        cell.titleL.textColor = _disabledTitleColor;
        cell.imageIV.image = [cell.imageIV.image imageWithTintColor:_disabledImageColor blendMode:kCGBlendModeColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 判断该Cell是否可响应点击事件
    BOOL enable = [self isEnabledWithIndexPath:indexPath];
    if (!enable) {
        return;
    }
    
    JMDropMenuModel *model = self.titleImageArrM[indexPath.row];
    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndex:Title:Image:)]) {
        [_delegate didSelectRowAtIndex:indexPath.row Title:model.title Image:model.image];
    }
    [self removeDropMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}


#pragma mark - Getters

- (NSMutableArray *)titleImageArrM {
    if (!_titleImageArrM) {
        _titleImageArrM = [NSMutableArray array];
    }
    return _titleImageArrM;
}

- (NSMutableArray *)RGBStrValueArr {
    if (!_RGBStrValueArr) {
        _RGBStrValueArr = [NSMutableArray array];
    }
    return _RGBStrValueArr;
}

- (NSMutableArray *)disabledIndexPathArr {
    if (!_disabledIndexPathArr) {
        _disabledIndexPathArr = [NSMutableArray array];
    }
    return _disabledIndexPathArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, self.frame.size.width, self.frame.size.height - 8) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6.f;
        if (_type == JMDropMenuTypeWeChat) {
            _tableView.backgroundColor = [UIColor colorWithRed:54 / 255.0 green:54 / 255.0 blue:54 / 255.0 alpha:1];
        } else {
            _tableView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1];
        }
    }
    return _tableView;
}

- (UIView *)cover {
    if (!_cover) {
        _cover = [[UIView alloc] initWithFrame:kWindow.bounds];
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.2;
        
        UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverClick)];
        [_cover addGestureRecognizer:tapCover];
    }
    return _cover;
}


// 将UIColor转换为RGB值
- (NSMutableArray *)changeUIColorToRGB:(UIColor *)color {
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    // 获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@", color];
    // 将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    // 获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d", r];
    [RGBStrValueArr addObject:RGBStr];
    // 获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d", g];
    [RGBStrValueArr addObject:RGBStr];
    // 获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d", b];
    [RGBStrValueArr addObject:RGBStr];
    // 返回保存RGB值的数组
    return RGBStrValueArr;
}

// 16进制颜色(html颜色值)字符串转为UIColor
- (NSMutableArray *)hexStringToColor:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
//    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
//    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [NSMutableArray arrayWithObjects:@(r),@(g),@(b), nil];
}

#pragma mark - 箭头x偏移值
- (void)setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
    [self setNeedsDisplay];
}

#pragma mark - 类型
- (void)setLayoutType:(JMDropMenuLayoutType)LayoutType {
    _LayoutType = LayoutType;
    for (JMDropMenuModel *model in self.titleImageArrM) {
        model.layoutType = LayoutType;
    }
    [self.tableView reloadData];
}

#pragma mark - 箭头颜色
- (void)setArrowColor:(UIColor *)arrowColor {
    _arrowColor = arrowColor;
    self.RGBStrValueArr = [self changeUIColorToRGB:arrowColor];
    [self setNeedsDisplay];
}

- (void)setArrowColor16:(NSString *)arrowColor16 {
    _arrowColor16 = arrowColor16;
    self.RGBStrValueArr = [self hexStringToColor:arrowColor16];
    [self setNeedsDisplay];
}

#pragma mark - 文字颜色
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.tableView reloadData];
}

#pragma mark - 线条颜色
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self.tableView reloadData];
}

@end



@interface JMDropMenuCell ()

/** 屏幕中心点 */
@property (nonatomic, assign) CGFloat screenCenter;

@end

@implementation JMDropMenuCell

+ (instancetype)dropMenuCellWithTableView:(UITableView *)tableView {
    JMDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropMenuCellID];
    if (!cell) {
        cell = [[JMDropMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDropMenuCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageIV];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = [UIColor blackColor];
        self.titleL.font = [UIFont systemFontOfSize:14.f];
        self.titleL.numberOfLines = 0;
        // 设置最小字体
//        self.titleL.minimumScaleFactor = 0.64;
//        self.titleL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.titleL];
        
        self.line1 = [[UIImageView alloc] init];
        self.line1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.line1];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.screenCenter = self.contentView.frame.size.height * 0.5;
    
    CGFloat imageIV_W = 24; // 图标宽度
    CGFloat titleL_H = 40; // titleL_H需要小于等于rowHeight
    self.imageIV.frame = CGRectMake(15, self.screenCenter - (imageIV_W / 2.0), imageIV_W, imageIV_W);
    if (self.model.layoutType == JMDropMenuLayoutTypeTitle) {
        self.titleL.frame = CGRectMake(10, self.screenCenter - (titleL_H / 2), self.frame.size.width, titleL_H);
    } else {
        self.titleL.frame = CGRectMake(CGRectGetMaxX(self.imageIV.frame) + 10, self.screenCenter - (titleL_H / 2), self.contentView.frame.size.width - 50, titleL_H);
    }
    self.line1.frame = CGRectMake(0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
}

- (void)setModel:(JMDropMenuModel *)model {
    _model = model;
    if (model.layoutType == JMDropMenuLayoutTypeTitle) {
        self.titleL.frame = CGRectMake(10, self.screenCenter - 10, self.frame.size.width, 20);
    } else {
        self.imageIV.image = [UIImage imageNamed:model.image];
    }
    if (model.type == JMDropMenuTypeQQ) {
        self.titleL.textColor = [UIColor blackColor];
        self.line1.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.titleL.textColor = [UIColor whiteColor];
        self.line1.backgroundColor = [UIColor whiteColor];
    }
    self.titleL.text = model.title;
}

@end



@interface JMDropMenuModel ()

@end

@implementation JMDropMenuModel

- (instancetype)initWithDictonary:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)dropMenuWithDictonary:(NSDictionary *)dict {
    return [[self alloc] initWithDictonary:dict];
}

@end
