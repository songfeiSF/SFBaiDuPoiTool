//
//  MatchAdressModel.h
//  iseasoftCompany
//
//  Created by songfei on 2018/9/25.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MatchAdressModel : NSObject
@property (nonatomic ,assign) NSInteger province;//    省ID    数字(number)
@property (nonatomic ,assign) NSInteger city;//   市ID    数字(number)
@property (nonatomic ,assign) NSInteger district;//    区ID    数字(number)
@property (nonatomic ,assign) NSInteger street;//   街道ID    数字(number)
@property (nonatomic ,assign) BOOL isperfectmatch;//    是否完全匹配    数字(number)        0：否 1：是

@property (nonatomic ,copy) NSString *detailAddress;
@end

NS_ASSUME_NONNULL_END
