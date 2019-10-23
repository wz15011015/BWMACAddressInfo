//
//  OUIInfoViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "OUIInfoViewController.h"
#import "Common.h"
#import "OUIInfoCell.h"
#import "CompanyWebsiteViewController.h"
#import "CompanyLocationViewController.h"

@interface OUIInfoViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation OUIInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"OUI Info", nil);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"OUIInfoCell" bundle:nil] forCellReuseIdentifier:OUIInfoCellID];
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.oui) {
        return 7;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OUIInfoCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OUIInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:OUIInfoCellID];
    cell.infoType = [OUIInfoCell infoTypeForOUIInfoWihtIndex:indexPath.row];
    cell.ouiModel = self.oui;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OUIInfoType infoType = [OUIInfoCell infoTypeForOUIInfoWihtIndex:indexPath.row];
    if (infoType == OUIInfoCompany) {
        CompanyWebsiteViewController *vc = [[CompanyWebsiteViewController alloc] init];
        vc.company = self.oui.company;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (infoType == OUIInfoStreet) {
        CompanyLocationViewController *vc = [[CompanyLocationViewController alloc] init];
        vc.company = self.oui.company;
        [self.navigationController pushViewController:vc animated:YES];
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
