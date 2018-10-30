//
//  SoftBaseViewController.m
//  iseasoftCompany
//
//  Created by songfei on 2018/9/28.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "SoftBaseViewController.h"

@interface SoftBaseViewController ()

@end

@implementation SoftBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.pageSize = 20;
    self.pageIndext = 1;
    [self setMjRefresh];
}

- (void)setMjRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullOnNetWork)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
}

- (void)headerBegingRefresh{
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerEndRefresh{
    [self.tableView.mj_header endRefreshing];
}

- (void)footerEndRefresh{
    [self.tableView.mj_footer endRefreshing];
}


- (void)noData{
    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
}

- (void)pullOnNetWork{
    self.pageIndext = self.defultPageIndext;
    [self onNetWork];
}

- (void)nextPage{
    self.pageIndext = self.pageIndext + 1;
    [self onNetWork];
}


- (void)onNetWork{
    //TODO 子类需要重写
}




- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(12, 5+64, self.view.width - 24, 36)];
        _searchBar.barStyle =  UIBarStyleDefault;
        _searchBar.tintColor = [UIColor getHEXRGB:@"3285FF"];
        [_searchBar setBackgroundImage:[UIImage imageNamed:@"wSearBar"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [_searchBar rounded:3 width:0.5 color:[UIColor getHEXRGB:@"E6E6E6"]];
    }
    return _searchBar;
}
@end
