//
//  ViewController.m
//  TTTNWaterFlowLayout
//
//  Created by jiudun on 2020/4/23.
//  Copyright © 2020 jiudun. All rights reserved.
//

#import "ViewController.h"

#import "ChildViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 列表视图 */
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

#pragma mark ----- set get方法
- (UITableView *)tableView {
    if (_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return _tableView;
}

#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self _nt_handleViewConfig];
    [self _nt_handleViewModelConfig];
}
#pragma mark ----- 处理回调
- (void)_nt_handleViewConfig {
    [self.view addSubview:self.tableView];
}
- (void)_nt_handleViewModelConfig {
    
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"ViewControllerTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"竖向瀑布流 item等高不等宽";
            break;
        case 1:
            cell.textLabel.text = @"竖向瀑布流 item等宽不等高";
            break;
        case 2:
            cell.textLabel.text = @"水平瀑布流 item等高不等宽 不支持头脚视图";
            break;
        case 3:
            cell.textLabel.text = @"水平瀑布流 item等宽不等高 不支持头脚视图";
            break;
        default:
            break;
    }
    
    return cell;
}
#pragma mark ----- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger type = 0;
    switch (indexPath.row) {
        case 0:
            type = 1;
            break;
        case 1:
            type = 2;
            break;
        case 2:
            type = 3;
            break;
        case 3:
            type = 4;
            break;
        default:
            break;
    }
    
    ChildViewController *vc = [[ChildViewController alloc] init];
    vc.layoutStyle = type;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
