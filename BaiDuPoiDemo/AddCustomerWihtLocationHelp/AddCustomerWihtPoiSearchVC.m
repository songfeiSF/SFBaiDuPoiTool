//
//  AddCustomerWihtPoiSearchVC.m
//  iseasoftCompany
//
//  Created by songfei on 2018/9/28.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "AddCustomerWihtPoiSearchVC.h"
#import "PoiSearchHelpTool.h"
#import "SugListTableView.h"
static NSString *POICELLID = @"POICELLID";
@interface AddCustomerWihtPoiSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SugListTableViewDelegate>
@property (nonatomic ,strong)SugListTableView *sugListView;

@property (nonatomic ,strong) AddressModel *aderssModel;

@property (nonatomic ,strong) NSMutableArray<BMKPoiInfo*> *dataArry;

@property (nonatomic ,copy) PoiSearchBlcok backBlock;
@end

@implementation AddCustomerWihtPoiSearchVC{
    NSInteger selectIndex;
    NSString *keyword;
}

- (instancetype)initWihtAdressModel:(AddressModel*)adModel blcok:(POIOverBlcok)blcok{
    self = [super init];
    if (self) {
        self.aderssModel = adModel;
        self.backBlock = blcok;
    }
    return self;
}


- (SugListTableView *)sugListView{
    if (!_sugListView) {
        _sugListView = [[SugListTableView alloc]initWithFrame:CGRectMake(self.searchBar.left, self.searchBar.bottom, self.searchBar.width, 0)];
        _sugListView.delegate = self;
        _sugListView.defultHight = 200;
        _sugListView.backColor = [UIColor groupTableViewBackgroundColor];
        _sugListView.animationTime = 0.5;
    }
    return _sugListView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem = BACK_BUTTON;
    self.title = @"地图创建";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入要搜索的名称";
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.sugListView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(3);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    self.defultPageIndext = 0;
    self.pageSize = 20;
    
    [self noData];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[PoiSearchHelpTool sharedInstance] setDelegate];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PoiSearchHelpTool sharedInstance] removeDelegate];
}


- (void)poiSearch{
    
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:POICELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:POICELLID];
    }
    
    cell.textLabel.text = self.dataArry[indexPath.row].name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor getHEXRGB:@"222222"];
    
    cell.detailTextLabel.text = self.dataArry[indexPath.row].address;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor getHEXRGB:@"666666"];
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.row == selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    DismisKeyword;
    
    if (indexPath.row == selectIndex) {
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    selectIndex = indexPath.row;
    
}

#pragma mark --UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!(searchText.length > 0)) {
        [self.sugListView dismis];
        DismisKeyword;
        return;
    }
    
    Weak_Self;
    [[PoiSearchHelpTool sharedInstance] startSugSearchWihtCity:self.aderssModel.city keyword:searchText block:^(id  _Nonnull object) {
        weakSelf.sugListView.dataArry = (NSArray*)object;
        [weakSelf.sugListView show];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    DismisKeyword;
    [self.sugListView dismis];
    keyword = searchBar.text;
    [self headerBegingRefresh];
}


#pragma mark --SugListTableViewDelegate
- (void)actionWithDidSelect:(NSString *)text{
    self.searchBar.text = text;
    DismisKeyword;
    [self.sugListView dismis];
    keyword = text;
    [self headerBegingRefresh];
}


- (void)onNetWork{
    Weak_Self;
    if (!keyword) {
//        SHOW_MSG(@"没有输入关键词！");
        return;
    }
    [[PoiSearchHelpTool sharedInstance] startPoiSearchWihtNearyBy:CLLocationCoordinate2DMake(self.aderssModel.latitude, self.aderssModel.longitude) keyword:keyword block:^(id  _Nonnull object) {
        NSArray<BMKPoiInfo*>* arry = (NSArray*)object;
        if (weakSelf.pageIndext == 0) {
             [weakSelf headerEndRefresh];
             weakSelf.dataArry = [NSMutableArray arrayWithArray:arry];
            [weakSelf.tableView reloadData];
            
            if (arry.count < weakSelf.pageSize) {
                [self noData];
            }else{
                [self footerEndRefresh];
            }
            
        }else{
            if (arry.count == 0) {
                [self noData];
                return;
            }

            if (arry.count < self.pageSize) {
                [self noData];
            }else{
                [self footerEndRefresh];
            }
            
            [self.dataArry addObjectsFromArray:arry];
            
            NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
            for (NSInteger i = (self.dataArry.count - arry.count); i < self.dataArry.count; i++) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexpath];
            }
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];
   
}


- (void)onRightBtn{
    if (self.backBlock) {
        self.backBlock(self.dataArry[selectIndex]);
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    DismisKeyword;
}
@end

