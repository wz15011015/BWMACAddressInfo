//
//  CountryListViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CountryListViewController.h"
#import "Common.h"
#import "OUIInfoCell.h"

@interface CountryListViewController ()

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation CountryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    [self loadData];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"Country List", nil);
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
}

- (CGFloat)accurateYForMenuVC {
    CGFloat menuVCY = NAVIGATION_BAR_HEIGHT;
    
    NSArray *visibleCells = self.tableView.visibleCells;
    // 第一个可视Cell
    OUIInfoCell *firstCell = visibleCells.firstObject;
    // 第一个可视Cell可以看见的高度
    CGFloat firstCellVisibleHeigth = CGRectGetMaxY(firstCell.frame) - self.tableView.contentOffset.y;
    // 数量label刚好可以显示的高度
    CGFloat countLabelVisibleHeight = CGRectGetHeight(firstCell.frame) * 0.6;
    if (firstCellVisibleHeigth > countLabelVisibleHeight) { // 显示在第一个Cell的countLabel位置
        menuVCY += firstCellVisibleHeigth - (CGRectGetHeight(firstCell.frame) / 2.0);
    } else { // 显示在下一个Cell的countLabel位置
        menuVCY += firstCellVisibleHeigth + (CGRectGetHeight(firstCell.frame) / 2.0);
    }
    
    return menuVCY;
}


#pragma mark - Data

- (void)loadData {
    NSArray *dataArr = [StatisticsManagerInstance countriesOfCompanyRank];
    self.dataArr = [NSMutableArray arrayWithArray:dataArr];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - Events

- (void)clickRightBarButton {
    // 一定要调用这个方法
    [self becomeFirstResponder];
    
    // 获取菜单控制器
    UIMenuController *menuvc = [UIMenuController sharedMenuController];
    if (menuvc.menuVisible) { // 如果菜单控制器已经显示,则返回
        return;
    }
    
    CGFloat menuY = NAVIGATION_BAR_HEIGHT + (OUIInfoCellH / 2.0);
    menuY = [self accurateYForMenuVC];
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:BTSLocalizedString(@"Number of Companies", nil) action:@selector(firstItemAction:)];
    menuvc.arrowDirection = UIMenuControllerArrowRight;
    menuvc.menuItems = @[menuItem1];
    [menuvc setTargetRect:CGRectMake(BTSWIDTH - 60, menuY, 0, 0) inView:self.view];
    [menuvc setMenuVisible:YES animated:YES];
}

- (void)firstItemAction:(UIMenuItem *)item {
//    // 通过系统的粘贴板,记录下需要传递的数据
//    [UIPasteboard generalPasteboard].string = companyURLStr;
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OUIInfoCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OUIInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OUIInfoCellID];
    cell.infoType = OUIInfoCountryCode;
    
    CountryModel *model = self.dataArr[indexPath.row];
    cell.country = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 创建UIMenuController 必须实现的关键方法

// 自己能否成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// 能否处理Action事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(firstItemAction:)) {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}


#pragma mark - Getters

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIBarButtonItem *)rightBarButton {
    if (!_rightBarButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button addTarget:self action:@selector(clickRightBarButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
        imageView.image = [UIImage imageNamed:@"count_icon"];
        [button addSubview:imageView];
        
        _rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _rightBarButton;
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
