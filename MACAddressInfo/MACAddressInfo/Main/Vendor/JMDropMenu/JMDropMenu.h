//
//  JMDropMenu.h
//  JMDropMenu
//
//  Created by JM on 2017/12/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMDropMenuModel;
@class JMDropMenuCell;

typedef NS_ENUM(NSInteger, JMDropMenuLayoutType) {
    JMDropMenuLayoutTypeNormal, // 图片在左, 文字在右
    JMDropMenuLayoutTypeTitle,  // 只有文字
};

typedef NS_ENUM(NSInteger, JMDropMenuType) {
    JMDropMenuTypeWeChat, // 仿微信
    JMDropMenuTypeQQ,     // 仿QQ
};

#define ANCHOR_POINT_OFFSET_RATIO (0.81) // 锚点偏移比例 (也即箭头偏移比例,所以箭头偏移量 = 0.8 * width)


@protocol JMDropMenuDelegate<NSObject>

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image;

@end


@interface JMDropMenu : UIView

/** 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 文字颜色(不可点击时) */
@property (nonatomic, strong) UIColor *disabledTitleColor;
/** 图片颜色(不可点击时,通过添加滤镜调整其颜色) */
@property (nonatomic, strong) UIColor *disabledImageColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 箭头x偏移值 (默认为: ANCHOR_POINT_OFFSET_RATIO * width) */
@property (nonatomic, assign) CGFloat arrowOffset;
/** 布局类型 (图片再左, 文字在右) */
@property (nonatomic, assign) JMDropMenuLayoutType LayoutType;
/** 箭头的颜色(UIColor类型) */
@property (nonatomic, strong) UIColor *arrowColor;
/** 箭头的颜色(16进制类型, 传16进制值即可, 例 #ffffff) */
@property (nonatomic, copy) NSString *arrowColor16;
/** 代理 */
@property (nonatomic, weak) id <JMDropMenuDelegate>delegate;


/**
 * 显示下拉菜单
 * frame  显示的位置以及大小
 * arrowOffset  箭头的x偏移值
 * titleArr  标题数组
 * imageArr  如果不需要显示图片可穿空
 * layoutType 显示图片和文字或者只显示文字(默认显示图片和文字)
 * type 仿qq还是微信 (如果是自定义可以传任何正整数)
 * rowHeight 每一行的高度
 */
+ (instancetype)showDropMenuFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate;

- (instancetype)initWithFrame:(CGRect)frame ArrowOffset:(CGFloat)arrowOffset TitleArr:(NSArray *)titleArr ImageArr:(NSArray *)imageArr Type:(JMDropMenuType)type LayoutType:(JMDropMenuLayoutType)layoutType RowHeight:(CGFloat)rowHeight Delegate:(id<JMDropMenuDelegate>)delegate;

/** 移除下拉菜单 */
- (void)removeDropMenu;

/**
 禁用某一菜单项的点击操作
 
 @param index 菜单项索引值
 */
- (void)disableMenuItemWithIndex:(NSInteger)index;

@end



@class JMDropMenuModel;

@interface JMDropMenuCell : UITableViewCell

/** 数据模型 */
@property (nonatomic, strong) JMDropMenuModel *model;
/** 图片 */
@property (nonatomic, strong) UIImageView *imageIV;
/** 标题 */
@property (nonatomic, strong) UILabel *titleL;
/** 线条 */
@property (nonatomic, strong) UIImageView *line1;


+ (instancetype)dropMenuCellWithTableView:(UITableView *)tableView;

@end



@interface JMDropMenuModel : NSObject

/** 图片 */
@property (nonatomic, copy) NSString *image;
/** 文字 */
@property (nonatomic, copy) NSString *title;
/** type */
@property (nonatomic, assign) JMDropMenuType type;
/** layoutType */
@property (nonatomic, assign) JMDropMenuLayoutType layoutType;


- (instancetype)initWithDictonary:(NSDictionary *)dict;

+ (instancetype)dropMenuWithDictonary:(NSDictionary *)dict;

@end
