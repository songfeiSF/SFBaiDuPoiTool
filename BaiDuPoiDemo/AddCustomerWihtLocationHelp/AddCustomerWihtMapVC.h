//
//  AddCustomerWihtMapVC.h
//  iseasoftCompany
//
//  Created by songfei on 2018/9/26.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define Weak_Self __weak typeof (self)weakSelf = self;
typedef void (^AddOverBlcok)(id obj);
@interface AddCustomerWihtMapVC : UIViewController
- (instancetype)initWihtBlcok:(AddOverBlcok)blcok;
@end

NS_ASSUME_NONNULL_END
