//
//  CompanyInfoViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "Common.h"
#import "OUIInfoCell.h"
#import "CompanyOUIsCell.h"
#import "CompanyWebsiteViewController.h"
#import "CompanyLocationViewController.h"
#import "CompanyOUIsViewController.h"

@interface CompanyInfoViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation CompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"Company Info", nil);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanyOUIsCell" bundle:nil] forCellReuseIdentifier:CompanyOUIsCellID];
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.company) {
        return 7;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return CompanyOUIsCellH;
    } else {
        return OUIInfoCellH;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTS_WEAK_SELF;
    if (indexPath.row == 6) {
        CompanyOUIsCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyOUIsCellID];
        cell.company = self.company;
        cell.jumpToListBlock = ^{
            CompanyOUIsViewController *vc = [[CompanyOUIsViewController alloc] init];
            vc.ouiList = weakSelf.company.ouiList;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        OUIInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OUIInfoCellID];
        cell.infoType = [OUIInfoCell infoTypeForCompanyInfoWihtIndex:indexPath.row];
        cell.company = self.company;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 6) {
        
    } else {
        OUIInfoType infoType = [OUIInfoCell infoTypeForCompanyInfoWihtIndex:indexPath.row];
        if (infoType == OUIInfoCompany) {
            CompanyWebsiteViewController *vc = [[CompanyWebsiteViewController alloc] init];
            vc.company = self.company;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (infoType == OUIInfoStreet) {
            CompanyLocationViewController *vc = [[CompanyLocationViewController alloc] init];
            vc.company = self.company;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - Getters




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
