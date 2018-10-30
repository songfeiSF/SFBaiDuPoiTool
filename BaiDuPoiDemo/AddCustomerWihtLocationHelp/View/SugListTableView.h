//
//  SugListTableView.h
//  iseasoftCompany
//
//  Created by songfei on 2018/9/28.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SugListTableViewDelegate <NSObject>
- (void)actionWithDidSelect:(NSString*)text;
@end
@interface SugListTableView : UIView
@property (nonatomic ,weak)id<SugListTableViewDelegate> delegate;
@property (nonatomic ,strong) NSArray<NSString*>* dataArry;

@property (nonatomic ,assign) CGFloat defultHight;
@property (nonatomic ,assign) CGFloat animationTime;

@property (nonatomic ,strong) UIColor *backColor;

- (void)show;
- (void)dismis;
@end

NS_ASSUME_NONNULL_END
