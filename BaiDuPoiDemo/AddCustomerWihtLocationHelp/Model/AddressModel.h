//
//  AddressModel.h
//  iseasoftCompany
//
//  Created by songfei on 2018/4/3.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
//维度
@property(nonatomic ,assign) double latitude;
//经度
@property(nonatomic ,assign) double longitude;
///省份名字属性
@property(nonatomic, copy) NSString *province;

///城市名字属性
@property(nonatomic, copy) NSString *city;

///区名字属性
@property(nonatomic, copy) NSString *district;

///街道名字属性
@property(nonatomic, copy) NSString *street;

///街道号码属性
@property(nonatomic, copy) NSString *streetNumber;

///位置语义化结果的定位点在什么地方周围的描述信息
@property(nonatomic, copy) NSString *locationDescribe;


@property (nonatomic ,copy) NSString *detailAddress;

@property (nonatomic ,copy) NSString *userName;
@end
