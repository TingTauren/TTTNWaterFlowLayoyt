# TTTNWaterFlowLayoyt
瀑布流布局</br>
![](https://github.com/TingTauren/TTTNWaterFlowLayoyt/blob/master/Apr-26-2020%2014-46-41.gif)

常用瀑布流布局</br>
使用简单，使用和正常layout相似，把设置滚动方向变成设置瀑布流类型就好</br>
TTTNWaterFlowLayout *layout = [[TTTNWaterFlowLayout alloc] init];</br>
layout.tttn_delegate = self;</br>
layout.minimumLineSpacing = 10.0;</br>
layout.minimumInteritemSpacing = 10.0;</br>
layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);</br>
if (self.layoutStyle == TTTNWaterFlowVerticalEqualWidth || self.layoutStyle == TTTNWaterFlowHorizontalEqualHeight) {</br>
    // 需要设置行数或列数</br>
    layout.lineOrRowCount = 3;</br>
}</br>
layout.flowLayoutStyle = self.layoutStyle;</br>
UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];</br>
参考https://github.com/wsl2ls/WSLWaterFlowLayout 重新造的一个轮子,只是自己跟着重新写了一遍,添加了横向滑动的头脚布局
