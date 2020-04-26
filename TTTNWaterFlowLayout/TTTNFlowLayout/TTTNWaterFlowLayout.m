//
//  TTTNWaterFlowLayout.m
//  NT_XiaoJingLing
//
//  Created by jiudun on 2020/4/14.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "TTTNWaterFlowLayout.h"

@interface TTTNWaterFlowLayout()
/** 获取默认值 */
/** 视图宽度 */
@property (nonatomic, assign) CGFloat collectionWidth;
/** 视图高度 */
@property (nonatomic, assign) CGFloat collectionHeight;
/** 边距 */
@property (nonatomic, assign) UIEdgeInsets spacingInset;
/** item左右间距 */
@property (nonatomic, assign) CGFloat itemSpacing;
/** item上下间距 */
@property (nonatomic, assign) CGFloat lineSpacing;

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attributeArray;

/** 存放每一列的最大y值 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 存放每一行的最大x值 */
@property (nonatomic, strong) NSMutableArray *rowWidths;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat maxColumnHeight;
/** 内容的宽度 */
@property (nonatomic, assign) CGFloat maxRowWidth;
@end

@implementation TTTNWaterFlowLayout

#pragma mark ----- set get
- (NSMutableArray *)attributeArray {
    if (_attributeArray) return _attributeArray;
    _attributeArray = [NSMutableArray array];
    return _attributeArray;
}
- (NSMutableArray *)columnHeights {
    if (_columnHeights) return _columnHeights;
    _columnHeights = [NSMutableArray array];
    return _columnHeights;
}
- (NSMutableArray *)rowWidths {
    if (_rowWidths) return _rowWidths;
    _rowWidths = [NSMutableArray array];
    return _rowWidths;
}

#pragma mark ----- 重写方法
/// 初始化 生成每个视图的布局信息
- (void)prepareLayout {
    [super prepareLayout];
    
    /** 获取设置参数 */
    self.collectionWidth = self.collectionView.frame.size.width; ///< 视图宽度
    self.collectionHeight = self.collectionView.frame.size.height; ///< 视图高度
    self.spacingInset = self.sectionInset; ///< 边距
    self.itemSpacing = self.minimumInteritemSpacing; ///< item左右间距
    self.lineSpacing = self.minimumLineSpacing; ///< item上下间距
    // 清除之前数组
    [self.attributeArray removeAllObjects];
    // 清除以前计算的所有数据
    self.maxColumnHeight = 0;
    [self.columnHeights removeAllObjects];
    self.maxRowWidth = 0;
    [self.rowWidths removeAllObjects];
    // 添加初始值
    if (self.lineOrRowCount <= 0) {
        self.lineOrRowCount = 2;
    }
    
    // 开始创建每一组cell的布局属性
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        // 获取每一组头视图header的UICollectionViewLayoutAttributes
        if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]) {
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attributeArray addObject:headerAttrs];
        }
        
        // 开始创建组内的每一个cell的布局属性
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rowCount; row++) {
            // 创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            // 获取indexPath位置cell对应的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributeArray addObject:attrs];
        }
        
        // 获取每一组脚视图footer的UICollectionViewLayoutAttributes
        if([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)]){
            UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attributeArray addObject:footerAttrs];
        }
    }
}
/// 决定一段区域所有cell和头尾视图的布局属性
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributeArray;
}
/// 返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 设置布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes  layoutAttributesForCellWithIndexPath:indexPath];
    
    if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualHeight) {
        // 竖向瀑布流 item等高不等宽
        attrs.frame = [self _tttn_getItemFrameOfVerticalEqualHeightWaterFlow:indexPath];
    }
    else if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualWidth) {
        // 竖向瀑布流 item等宽不等高
        attrs.frame = [self _tttn_getItemFrameOfVerticalEqualWidthWaterFlow:indexPath];
    }
    else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualHeight) {
        // 水平瀑布流 item等高不等宽 不支持头脚视图
        attrs.frame = [self _tttn_getItemFrameOfHorizontalEqualHeightWaterFlow:indexPath];
    }
    else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualWidth) {
        // 水平瀑布流 item等宽不等高 不支持头脚视图
        attrs.frame = [self _tttn_getItemFrameOfHorizontalEqualWidthWaterFlow:indexPath];
    }
    
    return attrs;
}
/// 返回indexPath位置头和脚视图对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attri;
    // 头视图
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualHeight) {
            attri.frame = [self _tttn_getHeaderFrameOfVerticalEqualHeightWaterFlow:indexPath];
        }
        else if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualWidth) {
            attri.frame = [self _tttn_getHeaderFrameOfVerticalEqualWidthWaterFlow:indexPath];
        }
        else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualHeight) {
            attri.frame = [self _tttn_getHeaderFrameOfHorizontalEqualHeightWaterFlow:indexPath];
        }
        else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualWidth) {
            attri.frame = [self _tttn_getHeaderFrameOfHorizontalEqualWidthWaterFlow:indexPath];
        }
        else {
            attri.frame = CGRectMake(0.0, 0.0, self.headerReferenceSize.width, self.headerReferenceSize.height);
        }
    }
    // 脚视图
    else {
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualHeight) {
            attri.frame = [self _tttn_getFooterFrameOfVerticalEqualHeightWaterFlow:indexPath];
        }
        else if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualWidth) {
            attri.frame = [self _tttn_getFooterFrameOfVerticalEqualWidthWaterFlow:indexPath];
        }
        else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualHeight) {
            attri.frame = [self _tttn_getFooterFrameOfHorizontalEqualHeightWaterFlow:indexPath];
        }
        else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualWidth) {
            attri.frame = [self _tttn_getFooterFrameOfHorizontalEqualWidthWaterFlow:indexPath];
        }
        else {
            attri.frame = CGRectMake(0.0, 0.0, self.headerReferenceSize.width, self.headerReferenceSize.height);
        }
    }
    return attri;
}
/// 返回内容高度
- (CGSize)collectionViewContentSize {
    if (self.flowLayoutStyle == TTTNWaterFlowVerticalEqualHeight || self.flowLayoutStyle == TTTNWaterFlowVerticalEqualWidth) {
        return CGSizeMake(0.0, self.maxColumnHeight);
    }
    else if (self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualHeight || self.flowLayoutStyle == TTTNWaterFlowHorizontalEqualWidth) {
        return CGSizeMake(self.maxRowWidth, 0.0);
    }
    return CGSizeMake(0.0, 0.0);
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return self.layoutForBoundsChange;
}

#pragma mark ----- Private Header Methods
/// 竖向瀑布流 item等高不等宽
- (CGRect)_tttn_getHeaderFrameOfVerticalEqualHeightWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    // 获取头部高度
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight == 0 ? 0.0 : self.maxColumnHeight;
    if (![self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)] || [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section].height == 0) {
        y = self.maxColumnHeight == 0 ? 0.0 : self.maxColumnHeight;
    }
    self.maxColumnHeight = y + size.height + _spacingInset.top;
    
    if (self.rowWidths.count <= 0) {
        [self.rowWidths addObject:@(_spacingInset.left)];
    } else {
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(_spacingInset.left)];
    }
    if (self.columnHeights.count <= 0) {
        [self.columnHeights addObject:@(self.maxColumnHeight)];
    } else {
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.maxColumnHeight)];
    }
    return CGRectMake(x , y, self.collectionWidth, size.height);
}

/// 竖向瀑布流 item等宽不等高
- (CGRect)_tttn_getHeaderFrameOfVerticalEqualWidthWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    // 获取头部高度
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight == 0 ? 0.0 : self.maxColumnHeight;
    if (![self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)] || [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section].height == 0) {
        y = self.maxColumnHeight == 0 ? 0.0 : self.maxColumnHeight;
    }
    self.maxColumnHeight = y + size.height + _spacingInset.top;
    
    if (self.columnHeights.count > 0) {
        for (NSInteger i = 0; i < self.columnHeights.count; i++) {
            CGPoint point = [[self.columnHeights objectAtIndex:i] CGPointValue];
            [self.columnHeights replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CGPointMake(point.x, self.maxColumnHeight)]];
        }
    }
    return CGRectMake(x , y, self.collectionWidth, size.height);
}

/// 水平瀑布流 item等高不等宽
- (CGRect)_tttn_getHeaderFrameOfHorizontalEqualHeightWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    // 获取头部高度
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat x = self.maxRowWidth == 0 ? 0.0 : self.maxRowWidth;
    CGFloat y = 0;
    if (![self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)] || [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section].width == 0) {
        x = self.maxRowWidth == 0 ? 0.0 : self.maxRowWidth;
    }
    self.maxRowWidth = x + size.width + _spacingInset.left;
    
    if (self.rowWidths.count > 0) {
        for (NSInteger i = 0; i < self.rowWidths.count; i++) {
            CGPoint point = [[self.rowWidths objectAtIndex:i] CGPointValue];
            [self.rowWidths replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CGPointMake(self.maxRowWidth, point.y)]];
        }
    }
    
    return CGRectMake(x , y, size.width, self.collectionHeight);
}

/// 水平瀑布流 item等宽不等高
- (CGRect)_tttn_getHeaderFrameOfHorizontalEqualWidthWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    // 获取头部高度
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat x = self.maxRowWidth == 0.0 ? 0.0 : self.maxRowWidth;
    CGFloat y = 0;
    if (![self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)] || [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section].width == 0) {
        x = self.maxRowWidth == 0 ? 0.0 : self.maxRowWidth;
    }
    self.maxRowWidth = x + size.width + _spacingInset.left;
    
    if (self.rowWidths.count <= 0) {
        [self.rowWidths addObject:@(self.maxRowWidth)];
    } else {
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.maxRowWidth)];
    }
    if (self.columnHeights.count <= 0) {
        [self.columnHeights addObject:@(_spacingInset.top)];
    } else {
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(_spacingInset.top)];
    }
    return CGRectMake(x , y, size.width, self.collectionHeight);
}

#pragma mark ----- Private Item Methods
/// 竖向瀑布流 item等高不等宽
- (CGRect)_tttn_getItemFrameOfVerticalEqualHeightWaterFlow:(NSIndexPath *)indexPath {
    // 获取每个item大小
    CGSize itemSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForItemAtIndexPath:indexPath];
    // 头部视图大小
    CGSize headViewSize = CGSizeMake(0, 0);
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        headViewSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    // 起始位置
    CGFloat x = 0, y = 0;
    
    // 不换行
    if (([[self.rowWidths firstObject] floatValue] + itemSize.width + _spacingInset.right) <= _collectionWidth) {
        // 计算x位置
        x = (self.rowWidths.count <= 0 ? _spacingInset.left : [[self.rowWidths firstObject] floatValue]);
        // 计算y位置
        y = (self.columnHeights.count <= 0 ? (_spacingInset.top + headViewSize.height) : [[self.columnHeights firstObject] floatValue]);
        // 存下一个位置的值
        if (self.rowWidths.count <= 0) {
            [self.rowWidths addObject:@(x + itemSize.width + _itemSpacing)];
        } else {
            [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + itemSize.width + _itemSpacing)];
        }
    }
    // 换行
    else {
        // 计算x位置
        x = _spacingInset.left;
        // 计算y位置
        y = (self.columnHeights.count <= 0 ? (_spacingInset.top + headViewSize.height) : [[self.columnHeights firstObject] floatValue]);
        y = y + itemSize.height + _lineSpacing;
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + itemSize.width + _itemSpacing)];
        // 存下一个位置的值
        if (self.columnHeights.count <= 0) {
            [self.columnHeights addObject:@(y)];
        } else {
            [self.columnHeights replaceObjectAtIndex:0 withObject:@(y)];
        }
    }
    
    // 记录内容的高度
    self.maxColumnHeight = [[self.columnHeights firstObject] floatValue] + _spacingInset.bottom + itemSize.height;
    // 返回的布局大小
    CGRect rect = CGRectMake(x, y, itemSize.width, itemSize.height);
    return rect;
}

/// 竖向瀑布流 item等宽不等高
- (CGRect)_tttn_getItemFrameOfVerticalEqualWidthWaterFlow:(NSIndexPath *)indexPath {
    // item的宽度
    CGFloat itemWidth = (long)((_collectionWidth - _spacingInset.left - _spacingInset.right - _itemSpacing * (_lineOrRowCount - 1))/_lineOrRowCount);
    // 获取每个item大小
    CGSize itemSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForItemAtIndexPath:indexPath];
    // 头部视图大小
    CGSize headViewSize = CGSizeMake(0, 0);
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        headViewSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    // 起始位置
    CGFloat x = 0, y = 0;
    
    if (self.columnHeights.count < _lineOrRowCount) {
        // 第一行
        x = (self.rowWidths.count <= 0 ? _spacingInset.left : ([[self.rowWidths firstObject] floatValue] + itemWidth + _itemSpacing));
        y = _spacingInset.left + headViewSize.height;
        // 存值
        if (self.rowWidths.count <= 0) {
            [self.rowWidths addObject:@(x)];
        } else {
            [self.rowWidths replaceObjectAtIndex:0 withObject:@(x)];
        }
        [self.columnHeights addObject:[NSValue valueWithCGPoint:CGPointMake(x, y + itemSize.height + _lineSpacing)]];
    }
    else {
        // 查找最小y值index
        NSInteger minIndex = 0;
        CGPoint minValue = [self.columnHeights.firstObject CGPointValue];
        for (NSInteger i = 1, count = self.columnHeights.count; i < count; i++) {
            CGPoint value = [[self.columnHeights objectAtIndex:i] CGPointValue];
            if (value.y < minValue.y) {
                minIndex = i;
                minValue = value;
            }
        }
        // 设置位置
        x = minValue.x;
        y = minValue.y;
        // 重置y对应值
        [self.columnHeights replaceObjectAtIndex:minIndex withObject:[NSValue valueWithCGPoint:CGPointMake(x, y + itemSize.height + _lineSpacing)]];
    }
    
    // 查找最大y值index
    CGPoint maxValue = [self.columnHeights.firstObject CGPointValue];
    for (NSInteger i = 1, count = self.columnHeights.count; i < count; i++) {
        CGPoint value = [[self.columnHeights objectAtIndex:i] CGPointValue];
        if (value.y > maxValue.y) {
            maxValue = value;
        }
    }
    // 记录内容的高度
    self.maxColumnHeight = maxValue.y - _lineSpacing + _spacingInset.bottom;
    // 返回的布局大小
    CGRect rect = CGRectMake(x, y, itemWidth, itemSize.height);
    return rect;
}

// 水平瀑布流 item等高不等宽
- (CGRect)_tttn_getItemFrameOfHorizontalEqualHeightWaterFlow:(NSIndexPath *)indexPath {
    // item的高度
    CGFloat itemHeight = (long)((_collectionHeight - _spacingInset.top - _spacingInset.bottom - _lineSpacing*(_lineOrRowCount - 1))/_lineOrRowCount);
    // 获取每个item大小
    CGSize itemSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForItemAtIndexPath:indexPath];
    // 头部视图大小
    CGSize headViewSize = CGSizeMake(0, 0);
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForHeaderViewInSection:)]){
        headViewSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    // 起始位置
    CGFloat x = 0, y = 0;
    
    if (self.rowWidths.count < _lineOrRowCount) {
        // 第一行
        x = _spacingInset.left + headViewSize.width;
        y = (self.columnHeights.count <= 0 ? _spacingInset.top : ([[self.columnHeights firstObject] floatValue] + itemHeight + _lineSpacing));
        // 存值
        if (self.columnHeights.count <= 0) {
            [self.columnHeights addObject:@(y)];
        } else {
            [self.columnHeights replaceObjectAtIndex:0 withObject:@(y)];
        }
        [self.rowWidths addObject:[NSValue valueWithCGPoint:CGPointMake(x + itemSize.width + _itemSpacing, y)]];
    }
    else {
        // 查找最小x值index
        NSInteger minIndex = 0;
        CGPoint minValue = [self.rowWidths.firstObject CGPointValue];
        for (NSInteger i = 1, count = self.rowWidths.count; i < count; i++) {
            CGPoint value = [[self.rowWidths objectAtIndex:i] CGPointValue];
            if (value.x < minValue.x) {
                minIndex = i;
                minValue = value;
            }
        }
        // 设置位置
        x = minValue.x;
        y = minValue.y;
        // 重置y对应值
        [self.rowWidths replaceObjectAtIndex:minIndex withObject:[NSValue valueWithCGPoint:CGPointMake(x + itemSize.width + _itemSpacing, y)]];
    }
    
    // 查找最大x值index
    CGPoint maxValue = [self.rowWidths.firstObject CGPointValue];
    for (NSInteger i = 1, count = self.rowWidths.count; i < count; i++) {
        CGPoint value = [[self.rowWidths objectAtIndex:i] CGPointValue];
        if (value.x > maxValue.x) {
            maxValue = value;
        }
    }
    // 记录内容的高度
    self.maxRowWidth = maxValue.x - _itemSpacing + _spacingInset.right;
    // 返回的布局大小
    CGRect rect = CGRectMake(x, y, itemSize.width, itemHeight);
    return rect;
}

// 水平瀑布流 item等宽不等高 不支持头脚视图
- (CGRect)_tttn_getItemFrameOfHorizontalEqualWidthWaterFlow:(NSIndexPath *)indexPath {
    // 获取每个item大小
    CGSize itemSize = [self.tttn_delegate tttn_waterFlowLayout:self sizeForItemAtIndexPath:indexPath];
    // 起始位置
    CGFloat x = 0, y = 0;
    // 不换行
    if (([[self.columnHeights firstObject] floatValue] + itemSize.height + _spacingInset.bottom) <= _collectionHeight) {
        // 计算x位置
        x = (self.rowWidths.count <= 0 ? _spacingInset.left : [[self.rowWidths firstObject] floatValue]);
        // 计算y位置
        y = (self.columnHeights.count <= 0 ? _spacingInset.top : [[self.columnHeights firstObject] floatValue]);
        // 存下一个位置的值
        if (self.columnHeights.count <= 0) {
            [self.columnHeights addObject:@(y + itemSize.height + _lineSpacing)];
        } else {
            [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + itemSize.height + _lineSpacing)];
        }
    }
    // 换行
    else {
        // 计算x位置
        x = (self.rowWidths.count <= 0 ? _spacingInset.left : [[self.rowWidths firstObject] floatValue]);
        x = x + itemSize.width + _itemSpacing;
        // 计算y位置
        y = _spacingInset.top;
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + itemSize.height + _lineSpacing)];
        // 存下一个位置的值
        if (self.rowWidths.count <= 0) {
            [self.rowWidths addObject:@(x)];
        } else {
            [self.rowWidths replaceObjectAtIndex:0 withObject:@(x)];
        }
    }
    
    // 记录内容的高度
    self.maxRowWidth = [[self.rowWidths firstObject] floatValue] + _spacingInset.right + itemSize.width;
    // 返回的布局大小
    CGRect rect = CGRectMake(x, y, itemSize.width, itemSize.height);
    return rect;
}

#pragma mark ----- Private Footer Methods
/// 竖向瀑布流 item等高不等宽
- (CGRect)_tttn_getFooterFrameOfVerticalEqualHeightWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)]) {
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section];
    }
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight;
    
    self.maxColumnHeight = y + size.height;
    
    [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.collectionWidth)];
    [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.maxColumnHeight)];
    
    return  CGRectMake(x , y, self.collectionWidth, size.height);
}

/// 竖向瀑布流 item等宽不等高
- (CGRect)_tttn_getFooterFrameOfVerticalEqualWidthWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)]) {
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight;
    
    self.maxColumnHeight = y + size.height;
    
    if (self.columnHeights.count > 0) {
        for (NSInteger i = 0; i < self.columnHeights.count; i++) {
            CGPoint point = [[self.columnHeights objectAtIndex:i] CGPointValue];
            [self.columnHeights replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CGPointMake(point.x, self.maxColumnHeight)]];
        }
    }
    
    return  CGRectMake(x , y, self.collectionWidth, size.height);
}

/// 水平瀑布流 item等高不等宽
- (CGRect)_tttn_getFooterFrameOfHorizontalEqualHeightWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)]) {
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section];
    }
    
    CGFloat x = self.maxRowWidth;
    CGFloat y = 0;
    
    self.maxRowWidth = x + size.width;
    
    if (self.rowWidths.count > 0) {
        for (NSInteger i = 0; i < self.rowWidths.count; i++) {
            CGPoint point = [[self.rowWidths objectAtIndex:i] CGPointValue];
            [self.rowWidths replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:CGPointMake(self.maxRowWidth, point.y)]];
        }
    }
    
    return  CGRectMake(x , y, size.width, self.collectionHeight);
}

/// 水平瀑布流 item等宽不等高
- (CGRect)_tttn_getFooterFrameOfHorizontalEqualWidthWaterFlow:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([self.tttn_delegate respondsToSelector:@selector(tttn_waterFlowLayout:sizeForFooterViewInSection:)]) {
        size = [self.tttn_delegate tttn_waterFlowLayout:self sizeForFooterViewInSection:indexPath.section];
    }
    CGFloat x = self.maxRowWidth;
    CGFloat y = 0;
    
    self.maxRowWidth = x + size.width;
    
    [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.maxRowWidth)];
    [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.collectionHeight)];
    
    return  CGRectMake(x , y, size.width, self.collectionHeight);
}

@end
