//
//  BaiDuLocationTool.m
//  iseasoftCompany
//
//  Created by songfei on 2018/4/3.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "BaiDuLocationTool.h"
//#import "Constant.h"
static BaiDuLocationTool * _instance = nil;
@interface BaiDuLocationTool()<BMKLocationManagerDelegate,BMKLocationAuthDelegate>
@property (nonatomic ,strong) BMKLocationManager *locationManager;
@end
@implementation BaiDuLocationTool
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
        [_instance locationManager];
    });
    return _instance;
}

+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

- (BMKLocationManager *)locationManager{
    if(!_locationManager){
//        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"kBR0WvPmBQm61Oztynf5lmwoMS27NAU5" authDelegate:self];//中盐

        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"gycyQYCf7X4aclFNjSjl5xH5mZz6OdEo" authDelegate:self];
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        _locationManager.allowsBackgroundLocationUpdates = NO;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}


//获取当前详细地址
-(void)getAddressDetail:(void(^)(AddressModel *addressModel)) block{
    [self.locationManager requestLocationWithReGeocode:true withNetworkState:true completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        AddressModel *moel = [[AddressModel alloc]init];
        
        if (error) {
//            SHOW_MSG([error.userInfo valueForKey:@"NSLocalizedDescription"]);
        }else{
            NSLog(@"location --- %@",location);
            moel.latitude = location.location.coordinate.latitude;
            moel.longitude = location.location.coordinate.longitude;
            moel.province = location.rgcData.province;
            moel.city = location.rgcData.city;
            moel.district = location.rgcData.district;
            moel.street = location.rgcData.street;
            moel.streetNumber = location.rgcData.streetNumber;
            moel.locationDescribe = location.rgcData.locationDescribe;
            moel.userName = location.rgcData.locationDescribe;
        }
        block(moel);
    }];
}


#pragma mark --BMKLocationAuthDelegate
//定位授权
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    if(iError == BMKLocationAuthErrorSuccess){
        NSLog(@"定位授权成功");
    }else{
        NSLog(@"定位授权失败");
    }
}

#pragma mark --BMKLocationManagerDelegate
//定位返回 ： 移动定位时 多次
-(void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
    
}

- (CGFloat)BMKPointToPointDistence:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2{
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:point2.latitude longitude:point2.longitude];

    CLLocationDistance meters=[orig distanceFromLocation:dist];
    NSLog(@"距离:%f",meters);
    return meters;
}

@end
