//
//  ChildViewController.m
//  TTTNWaterFlowLayout
//
//  Created by jiudun on 2020/4/23.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "ChildViewController.h"

#define TTTN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TTTN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ChildViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTTNWaterFlowLayoutDelegate>
/** 列表视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ChildViewController

#pragma mark ----- set get方法
- (UICollectionView *)collectionView {
    if (_collectionView) return _collectionView;
    TTTNWaterFlowLayout *layout = [[TTTNWaterFlowLayout alloc] init];
    layout.tttn_delegate = self;
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    if (self.layoutStyle == TTTNWaterFlowVerticalEqualWidth || self.layoutStyle == TTTNWaterFlowHorizontalEqualHeight) {
        // 需要设置行数或列数
        layout.lineOrRowCount = 3;
    }
    layout.flowLayoutStyle = self.layoutStyle;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"NTPublishControllerTestCollectionCellIndetifier"];
    // 竖向布局头脚视图才有效
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NTPublishControllerTestCollectionHeaderIndetifier"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NTPublishControllerTestCollectionFooterIndetifier"];
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    return _collectionView;
}

#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _nt_handleViewConfig];
    [self _nt_handleViewModelConfig];
}
#pragma mark ----- 处理回调
- (void)_nt_handleViewConfig {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
}
- (void)_nt_handleViewModelConfig {
    
}

#pragma mark ----- Collection DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NTPublishControllerTestCollectionCellIndetifier" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
    
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NTPublishControllerTestCollectionHeaderIndetifier" forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
                break;
            }
        }
        UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
        label.backgroundColor = [UIColor cyanColor];
        label.textColor = [UIColor yellowColor];
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = @"头视图";
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        return headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"NTPublishControllerTestCollectionFooterIndetifier" forIndexPath:indexPath];
        for (UIView *view in footerView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
                break;
            }
        }
        UILabel *label = [[UILabel alloc] initWithFrame:footerView.bounds];
        label.backgroundColor = [UIColor yellowColor];
        label.textColor = [UIColor cyanColor];
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = @"脚视图";
        label.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:label];
        return footerView;
    }
    return [UICollectionReusableView new];
}
#pragma mark ----- Collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----- TTTNWaterFlowLayout Delegate
- (CGSize)tttn_waterFlowLayout:(TTTNWaterFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger width = arc4random()%50+50;
    if (self.layoutStyle == TTTNWaterFlowVerticalEqualHeight) {
        // 竖向瀑布流 item等高不等宽(请设置高度一致)
        return CGSizeMake(width, 30.0);
    }
    else if (self.layoutStyle == TTTNWaterFlowVerticalEqualWidth || self.layoutStyle == TTTNWaterFlowHorizontalEqualHeight) {
        // 竖向瀑布流 item等宽不等高(设置宽度会无效,所有随便设置什么)
        // 水平瀑布流 item等高不等宽 不支持头脚视图(设置高度会无效,所有随便设置什么)
        return CGSizeMake(width, width);
    }
    else if (self.layoutStyle == TTTNWaterFlowHorizontalEqualWidth) {
        // 水平瀑布流 item等宽不等高 不支持头脚视图(请设置宽度一致)
        return CGSizeMake(30.0, width);
    }
    return CGSizeMake(width, width);
}
- (CGSize)tttn_waterFlowLayout:(TTTNWaterFlowLayout *)layout sizeForHeaderViewInSection:(NSInteger)section {
    if (self.layoutStyle == TTTNWaterFlowVerticalEqualHeight || self.layoutStyle == TTTNWaterFlowVerticalEqualWidth) {
        return CGSizeMake(TTTN_SCREEN_WIDTH, 50.0);
    }
    else {
        return CGSizeMake(50.0, TTTN_SCREEN_HEIGHT);
    }
}
- (CGSize)tttn_waterFlowLayout:(TTTNWaterFlowLayout *)layout sizeForFooterViewInSection:(NSInteger)section {
    if (self.layoutStyle == TTTNWaterFlowVerticalEqualHeight || self.layoutStyle == TTTNWaterFlowVerticalEqualWidth) {
        return CGSizeMake(TTTN_SCREEN_WIDTH, 50.0);
    }
    else {
        return CGSizeMake(50.0, TTTN_SCREEN_HEIGHT);
    }
}

@end
