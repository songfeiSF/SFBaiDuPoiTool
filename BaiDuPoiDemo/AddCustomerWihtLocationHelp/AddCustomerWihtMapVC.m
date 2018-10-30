//
//  AddCustomerWihtMapVC.m
//  iseasoftCompany
//
//  Created by songfei on 2018/9/26.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "AddCustomerWihtMapVC.h"
#import "BaiDuLocationTool.h"
#import "PoiSearchHelpTool.h"
//#import "Constant.h"
#import "UIView+Extension.h"
#import "AddCustomerWihtPoiSearchVC.h"
//#import "GoMapAPPTool.h"
static NSString *const UITableViewCellID = @"UITableViewCellID";
@interface AddCustomerWihtMapVC ()<BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) BMKMapView * mapView;

@property (nonatomic ,strong) UIView *searchBtn;

@property (nonatomic ,strong) BMKPointAnnotation * userPointAnnotation;//用户的坐标

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray<BMKPoiInfo*> *dataArry;

@property (nonatomic ,strong) UIImageView *centerImageView;

@property (nonatomic ,copy) AddOverBlcok backBlock;

@property (nonatomic ,strong) UIButton *reLocationBtn;
@end

@implementation AddCustomerWihtMapVC{
    BOOL needSearch;//是否需要 重新搜索周边 true 是 ，false 否
    
    AddressModel *userAdressModel; // 定位自己的位置
    
    NSString *keyWords; // 搜索关键词
    
    NSInteger selectIndex;// 选择的类标 下标
    
    BMKPoiInfo *searchPioInfo;//搜索出来的结果
}


- (instancetype)initWihtBlcok:(AddOverBlcok)blcok{
    self = [super init];
    if (self) {
        self.backBlock = blcok;
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIView alloc]init];
        _searchBtn.backgroundColor = [UIColor whiteColor];
        _searchBtn.alpha = 0.8f;
        
        UILabel *lab = [[UILabel alloc]init];
        lab.textColor = [UIColor blackColor];
        lab.text = @"搜索客户名称";
        lab.font = [UIFont systemFontOfSize:16];
        
        [_searchBtn addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self->_searchBtn.mas_centerY);
            make.centerX.mas_equalTo(self->_searchBtn.mas_centerX);
        }];
        
        [_searchBtn rounded:5 width:0 color:nil];
        
        _searchBtn.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goSearch)];
        [_searchBtn addGestureRecognizer:tap];
    }
    return _searchBtn;
}

- (UIButton *)reLocationBtn{
    if (!_reLocationBtn) {
        _reLocationBtn = [[UIButton alloc] init];
        [_reLocationBtn setImage:[UIImage imageNamed:@"reLocation"] forState:UIControlStateNormal];
        _reLocationBtn.backgroundColor = [UIColor whiteColor];
        [_reLocationBtn addTarget:self action:@selector(userLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reLocationBtn;
}


- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]init];
        _mapView.showsUserLocation = true;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.logoPosition = BMKLogoPositionLeftBottom;
    }
    return _mapView;
}

- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 40)];
        _centerImageView.image = [UIImage imageNamed:@"on_position02"];
        _centerImageView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToThere)];
        [_centerImageView addGestureRecognizer:tap];
    }
    return _centerImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem = BACK_BUTTON;
//    UIButton *rigthBtn = [SFButton RightBarButtonItem:self titile:@"添加" action:@selector(addCustomer)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
    self.title = @"添加客户";
   
    //设置地图
    [self.view addSubview:self.mapView];
    //设置Table
    [self.view addSubview:[self tableView]];
    //添加搜索框
    [self.view addSubview:self.searchBtn];
    
    [self.view addSubview:self.reLocationBtn];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(self.view.height/2.0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.mapView.mas_bottom);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(10+64);
        make.left.mas_equalTo(self.view.mas_left).offset(50);
        make.right.mas_equalTo(self.view.mas_right).offset(-50);
        make.height.mas_equalTo(40);
    }];
    
    [self.reLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mapView.mas_bottom).offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.reLocationBtn rounded:15 width:0 color:nil];
 
    [self userLocation];
    
     needSearch = true;
    
    [self.mapView layoutIfNeeded];
    self.centerImageView.x = (self.mapView.width - self.centerImageView.width)/2.0;
    self.centerImageView.y = (self.mapView.height/2.0) - self.centerImageView.height;
    
    [self.mapView addSubview:self.centerImageView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;

    [[PoiSearchHelpTool sharedInstance] setDelegate];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;

    [[PoiSearchHelpTool sharedInstance] removeDelegate];
}


#pragma mark --Location 定位自己
- (void)userLocation{
    __weak typeof (self)weakSelf = self;
    [[BaiDuLocationTool sharedInstance] getAddressDetail:^(AddressModel *addressModel) {
        userAdressModel = addressModel;
        
        [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(addressModel.latitude, addressModel.longitude) animated:true];
        
        BMKPointAnnotation * point = [[BMKPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(addressModel.latitude, addressModel.longitude);;
        point.title = addressModel.street;
        
        if (weakSelf.userPointAnnotation) {
            [weakSelf.mapView removeAnnotation:weakSelf.userPointAnnotation];
            weakSelf.userPointAnnotation = point;
            [weakSelf.mapView addAnnotation:point];
        }else{
            weakSelf.userPointAnnotation = point;
            [weakSelf.mapView addAnnotation:point];
            BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01, 0.01);
            BMKCoordinateRegion region  = BMKCoordinateRegionMake(self.userPointAnnotation.coordinate,span);
            [weakSelf.mapView setRegion:region];
        }
        
        //开启反地理编码查询周边
        [[PoiSearchHelpTool sharedInstance] startGeoSearchWithLocation:weakSelf.mapView.centerCoordinate block:^(id  _Nonnull object) {
            BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult*)object;
            weakSelf.dataArry = result.poiList;
            [weakSelf.tableView reloadData];
        }];

    }];
}


#pragma mark --UITableViewDatsoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UITableViewCellID];
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

#pragma mark --UITableViewDalegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row == selectIndex) {
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    selectIndex = indexPath.row;
    
    //不需要 重新检索
    needSearch = false;
    
    [self.mapView setCenterCoordinate:self.dataArry[indexPath.row].pt animated:true];
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
#pragma mark --BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
//    on_position01
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView;
        
        //计算是不是当前的 大头针
        NSString *imageName = @"bluePoint";
        BMKPointAnnotation *pointAnimation = (BMKPointAnnotation*)annotation;
        if (pointAnimation.coordinate.latitude == self.userPointAnnotation.coordinate.latitude && pointAnimation.coordinate.longitude == self.userPointAnnotation.coordinate.longitude) {
           newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"mapAnnotation"];
            //设置大头针的偏移量
            newAnnotationView.centerOffset = CGPointMake(0, 1);
            imageName = @"bluePoint";
        }else{
            newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"mapAnnotation2"];
            imageName = @"on_position02";
        }
        
    
        newAnnotationView.image = [UIImage imageNamed:imageName];
        
        
//        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc]initWithCustomView:areaPaoView];
//        newAnnotationView.paopaoView = paopao;
        
        return newAnnotationView;
    }else{
        return nil;
    }
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%f",mapView.centerCoordinate.latitude);
//    nowPoint = mapView.centerCoordinate;
    [self shakerAnimationWihtView:self.centerImageView duration:1 height:30];
    //开启反地理编码查询周边
    if (!needSearch) {
        needSearch = true;
        return;
    }
    
    Weak_Self;
    [[PoiSearchHelpTool sharedInstance] startGeoSearchWithLocation:weakSelf.mapView.centerCoordinate block:^(id  _Nonnull object) {
        
        BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult*)object;
        self->selectIndex = 0;

        weakSelf.dataArry = result.poiList;

        [weakSelf.tableView reloadData];
    }];
}

#pragma mark --添加客户
- (void)addCustomer{
    BMKPoiInfo *poiInfo = self.dataArry[selectIndex];
    Weak_Self;
    [[PoiSearchHelpTool sharedInstance]startGeoSearchWithLocation:poiInfo.pt block:^(id  _Nonnull object) {
        BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult*)object;
        AddressModel *adressModel = [[AddressModel alloc]init];
        adressModel.latitude = result.location.latitude;
        adressModel.longitude = result.location.longitude;
        adressModel.province = result.addressDetail.province;
        adressModel.city = result.addressDetail.city;
        adressModel.district = result.addressDetail.district;
        adressModel.street = result.addressDetail.streetName;
        adressModel.streetNumber = result.addressDetail.streetNumber;
        adressModel.userName = poiInfo.name;
        [weakSelf addOverAndGoBack:adressModel];
    }];
    
}

#pragma mark --搜索
- (void)goSearch{
    Weak_Self;
    AddCustomerWihtPoiSearchVC *vc  = [[AddCustomerWihtPoiSearchVC alloc] initWihtAdressModel:userAdressModel blcok:^(id  _Nonnull obj) {
        BMKPoiInfo *info = (BMKPoiInfo*)obj;
        
        searchPioInfo = info;
        
        weakSelf.mapView.centerCoordinate = info.pt;
        
       __block NSMutableArray* mbArry = [NSMutableArray array];
        [mbArry addObject:info];
        //开启反地理编码查询周边
        [[PoiSearchHelpTool sharedInstance] startGeoSearchWithLocation:info.pt block:^(id  _Nonnull object) {
            BMKReverseGeoCodeResult *result = (BMKReverseGeoCodeResult*)object;
            [mbArry addObjectsFromArray:result.poiList];
            weakSelf.dataArry = mbArry;
            [weakSelf.tableView reloadData];
        }];
    }];
    
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark -- 添加信息处理完成回调
- (void)addOverAndGoBack:(AddressModel*)adressModel{
    if (self.backBlock) {
        self.backBlock(adressModel);
    }
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark --导航到该地点
- (void)goToThere{
//    [GoMapAPPTool goAppleMap:self.userPointAnnotation.coordinate toPoint:self.dataArry[selectIndex].pt myAdress:@"我的位置" toAdress:self.dataArry[selectIndex].name];
}

// 重力弹跳动画效果
- (void)shakerAnimationWihtView:(UIView*)view duration:(NSTimeInterval)duration height:(float)height{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTx = view.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentTx), @(currentTx - height), @(currentTx)];
    
    animation.keyTimes = @[@(0), @(0.5), @(1.0)];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}
@end


