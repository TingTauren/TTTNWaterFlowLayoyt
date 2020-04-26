//
//  ChildViewController.h
//  TTTNWaterFlowLayout
//
//  Created by jiudun on 2020/4/23.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTTNWaterFlowLayout.h" // 流布局

NS_ASSUME_NONNULL_BEGIN

@interface ChildViewController : UIViewController

/** 类型 */
@property (nonatomic, assign) TTTNWaterFlowLayoutStyle layoutStyle;

@end

NS_ASSUME_NONNULL_END
