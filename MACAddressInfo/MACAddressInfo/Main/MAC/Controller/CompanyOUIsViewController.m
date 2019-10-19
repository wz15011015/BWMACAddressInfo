//
//  CompanyOUIsViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyOUIsViewController.h"
#import "OUICollectionCell.h"

@interface CompanyOUIsViewController ()

@property (nonatomic ,weak) IBOutlet UICollectionView *collectionView;

@end

@implementation CompanyOUIsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadUI];
}


#pragma mark - UI

- (void)loadUI {
    self.navigationItem.title = BTSLocalizedString(@"Company OUI List", nil);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"OUICollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:OUICollectionCellID];
}


#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ouiList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OUICollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:OUICollectionCellID forIndexPath:indexPath];
    NSString *ouiCode = self.ouiList[indexPath.row];
    cell.ouiCode = ouiCode;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

// MARK: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 分为5列
    NSUInteger column = 5;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        column = 4; // 小屏手机上显示4列
    }
    CGFloat itemW = (BTSWIDTH - ((column + 1) * OUI_COLLECTION_CELL_MARGIN_HOR)) / (column * 1.0);
    CGFloat itemH = itemW / OUI_COLLECTION_CELL_RATIO;
    return CGSizeMake(itemW, itemH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(OUI_COLLECTION_CELL_MARGIN_VER, OUI_COLLECTION_CELL_MARGIN_HOR, OUI_COLLECTION_CELL_MARGIN_VER, OUI_COLLECTION_CELL_MARGIN_HOR);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    // Cell在竖直方向上的最小间隔
    return OUI_COLLECTION_CELL_MARGIN_VER;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // Cell在水平方向上的最小间隔
    return OUI_COLLECTION_CELL_MARGIN_HOR;
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
