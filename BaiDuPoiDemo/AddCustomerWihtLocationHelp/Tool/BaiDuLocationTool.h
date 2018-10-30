//
//  BaiDuLocationTool.h
//  iseasoftCompany
//
//  Created by songfei on 2018/4/3.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationkit/BMKLocationAuth.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import "AddressModel.h"
@interface BaiDuLocationTool : NSObject
+(instancetype) sharedInstance;

/**
 获取地理位置

 @param block 返回
 */
-(void)getAddressDetail:(void(^)(AddressModel *addressModel)) block;

//获取两个坐标间的距离
- (CGFloat)BMKPointToPointDistence:(CLLocationCoordinate2D)point1 point2:(CLLocationCoordinate2D)point2;
@end
