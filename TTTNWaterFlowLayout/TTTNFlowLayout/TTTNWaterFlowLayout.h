//
//  TTTNWaterFlowLayout.h
//  NT_XiaoJingLing
//
//  Created by jiudun on 2020/4/14.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTTNWaterFlowLayoutStyle) {
    TTTNWaterFlowVerticalEqualHeight = 1,   ///< 竖向瀑布流 item等高不等宽
    TTTNWaterFlowVerticalEqualWidth = 2,    ///< 竖向瀑布流 item等宽不等高
    TTTNWaterFlowHorizontalEqualHeight = 3, ///< 水平瀑布流 item等高不等宽
    TTTNWaterFlowHorizontalEqualWidth = 4,  ///< 水平瀑布流 item等宽不等高
};

@class TTTNWaterFlowLayout;
@protocol TTTNWaterFlowLayoutDelegate <NSObject>

@required
/// 返回item的大小
/// 注意：根据当前的瀑布流样式需知的事项： \
/// 当样式为TTTNWaterFlowVerticalEqualHeight 传入的size宽高都有效,切记高度记得保持一致\
/// TTTNWaterFlowVerticalEqualWidth 传入的size.width无效,所以可以是任意值,因为内部会根据样式自己计算布局\
/// TTTNWaterFlowHorizontalEqualHeight 传入的size.height无效,所以可以是任意值 ,因为内部会根据样式自己计算布局
/// @param layout 布局对象
/// @param indexPath 索引
- (CGSize)tttn_waterFlowLayout:(TTTNWaterFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/// 头视图Size
/// @param layout 布局对象
/// @param section 列数
- (CGSize)tttn_waterFlowLayout:(TTTNWaterFlowLayout *)layout sizeForHeaderViewInSection:(NSInteger)section;
/// 脚视图Size
/// @param layout 布局对象
/// @param section 列数
- (CGSize)tttn_waterFlowLayout:(TTTNWaterFlowLayout *)layout sizeForFooterViewInSection:(NSInteger)section;

@end

@interface TTTNWaterFlowLayout : UICollectionViewFlowLayout

/** 代理对象 */
@property (nonatomic, weak) id<TTTNWaterFlowLayoutDelegate> tttn_delegate;

/** 样式 */
@property (nonatomic, assign) TTTNWaterFlowLayoutStyle flowLayoutStyle;
/** 列数或行数 */
@property (nonatomic, assign) NSInteger lineOrRowCount;
/** 是否重新计算 */
@property (nonatomic, assign) BOOL layoutForBoundsChange;

@end

NS_ASSUME_NONNULL_END
