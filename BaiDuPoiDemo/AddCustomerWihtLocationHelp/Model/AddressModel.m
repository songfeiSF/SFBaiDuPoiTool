//
//  AddressModel.m
//  iseasoftCompany
//
//  Created by songfei on 2018/4/3.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
- (NSString *)detailAddress{
    if (_detailAddress) {
        return _detailAddress;
    }
    
    NSString *adresss = @"";
    if(self.province){
        adresss = [adresss stringByAppendingString:self.province];
    }
    if (self.city) {
        adresss = [adresss stringByAppendingString:self.city];
    }
    if (self.district) {
        adresss = [adresss stringByAppendingString:self.district];
    }
    if (self.street) {
        adresss = [adresss stringByAppendingString:self.street];
    }
    if (self.streetNumber) {
        adresss = [adresss stringByAppendingString:self.streetNumber];
    }
//    if (self.locationDescribe){
//        adresss = [adresss stringByAppendingString:self.locationDescribe];
//    }
    return adresss;
}
@end
