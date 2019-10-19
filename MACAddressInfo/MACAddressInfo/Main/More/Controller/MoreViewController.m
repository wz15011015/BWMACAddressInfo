//
//  MoreViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCell.h"
#import "FAQViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"

@interface MoreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *titlesDic;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    [self loadData];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"More", nil);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"MoreCell" bundle:nil] forCellReuseIdentifier:MoreCellID];
}


#pragma mark - Data

- (void)loadData {
    self.titlesDic = @{@"Section_0": @[BTSLocalizedString(@"What is network card address?", nil),
                                       BTSLocalizedString(@"What is OUI?", nil)
                                       ],
                       @"Section_1": @[BTSLocalizedString(@"Help and Feedback", nil),
                                       BTSLocalizedString(@"About", nil)
                                       ]
                       };
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = self.titlesDic.allKeys.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *titles = [self.titlesDic objectForKey:[NSString stringWithFormat:@"Section_%ld", section]];
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MoreCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = [self.titlesDic objectForKey:[NSString stringWithFormat:@"Section_%ld", indexPath.section]];
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreCellID];
    cell.title = titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *titles = [self.titlesDic objectForKey:[NSString stringWithFormat:@"Section_%ld", indexPath.section]];
    NSString *title = titles[indexPath.row];
    
    if (indexPath.section == 0) {
        NSString *htmlFileName = @"";
        if (indexPath.row == 0) {
            htmlFileName = @"FAQ_WhatIsMACAddress";
        } else if (indexPath.row == 1) {
            htmlFileName = @"FAQ_WhatIsOUI";
        }
        FAQViewController *vc = [[FAQViewController alloc] init];
        vc.title = title;
        vc.htmlFileName = htmlFileName;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FeedbackViewController *vc = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) {
            AboutViewController *vc = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - Getters

- (NSDictionary *)titlesDic {
    if (!_titlesDic) {
        _titlesDic = [NSDictionary dictionary];
    }
    return _titlesDic;
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
