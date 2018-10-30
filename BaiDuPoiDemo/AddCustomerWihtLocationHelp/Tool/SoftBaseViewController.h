//
//  SoftBaseViewController.h
//  iseasoftCompany
//
//  Created by songfei on 2018/9/28.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

#define Weak_Self __weak typeof (self)weakSelf = self;
#define DismisKeyword  [[UIApplication sharedApplication].keyWindow endEditing:true]
NS_ASSUME_NONNULL_BEGIN

@interface SoftBaseViewController : UIViewController
//默认第一页页码
@property (nonatomic ,assign) NSInteger defultPageIndext;

//分页页码
@property (nonatomic ,assign) NSInteger pageIndext;
//分页一页大小
@property (nonatomic ,assign) NSInteger pageSize;
//
@property (nonatomic ,strong) UITableView *tableView;

//搜索框
@property (nonatomic ,strong) UISearchBar *searchBar;

//首页下拉刷新
- (void)pullOnNetWork;
//下一页
- (void)nextPage;
/**
 网络请求方法 需要子类重写
 */
- (void)onNetWork;

//刷新
- (void)headerBegingRefresh;
//停止刷新
- (void)headerEndRefresh;
//停止刷新
- (void)footerEndRefresh;
//没有更多数据
- (void)noData;
@end

NS_ASSUME_NONNULL_END
