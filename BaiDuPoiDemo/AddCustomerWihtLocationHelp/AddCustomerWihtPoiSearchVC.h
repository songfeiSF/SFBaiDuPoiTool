//
//  AddCustomerWihtPoiSearchVC.h
//  iseasoftCompany
//
//  Created by songfei on 2018/9/28.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "SoftBaseViewController.h"
#import "AddressModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^POIOverBlcok)(id obj);
@interface AddCustomerWihtPoiSearchVC : SoftBaseViewController
- (instancetype)initWihtAdressModel:(AddressModel*)adModel blcok:(POIOverBlcok)blcok;
@end

NS_ASSUME_NONNULL_END
