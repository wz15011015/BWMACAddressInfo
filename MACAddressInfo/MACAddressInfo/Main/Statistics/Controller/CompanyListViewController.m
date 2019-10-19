//
//  CompanyListViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyListViewController.h"
#import "Common.h"
#import "OUIInfoCell.h"
#import "CompanyInfoViewController.h"

@interface CompanyListViewController () {
    NSUInteger _pageNum;
    NSUInteger _pageSize;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation CompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    [self loadData];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"Company List", nil);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
    
    // 下拉/上拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.automaticallyChangeAlpha = YES; // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.lastUpdatedTimeLabel.hidden = YES; // 隐藏时间
    header.stateLabel.hidden = YES; // 隐藏文字
    [self.tableView setMj_header:header];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.stateLabel.hidden = YES; // 隐藏时间和文字
    [self.tableView setMj_footer:footer];
}


#pragma mark - Data

- (void)loadData {
    _pageNum = 1;
    _pageSize = 20;
    
    // 清空数组
    [self.dataArr removeAllObjects];
    
    // 加载第一页数据
    NSArray *dataArr = [DatabaseManagerInstance queryCompanyWithPageNum:_pageNum pageSize:_pageSize];
    self.dataArr = [NSMutableArray arrayWithArray:dataArr];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    _pageNum++;
    
    NSArray *dataArr = [DatabaseManagerInstance queryCompanyWithPageNum:_pageNum pageSize:_pageSize];
    [self.dataArr addObjectsFromArray:dataArr];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - Events



#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OUIInfoCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OUIInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OUIInfoCellID];
    cell.infoType = OUIInfoCompany;
    
    CompanyModel *model = self.dataArr[indexPath.row];
    cell.company = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompanyModel *model = self.dataArr[indexPath.row];
    CompanyInfoViewController *vc = [[CompanyInfoViewController alloc] init];
    vc.company = model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Getters

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
