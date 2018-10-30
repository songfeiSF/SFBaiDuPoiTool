//
//  SugListTableView.m
//  iseasoftCompany
//
//  Created by songfei on 2018/9/28.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "SugListTableView.h"
#import "Masonry.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"
static NSString *const UITableViewCellID = @"UITableViewCellID";
@interface SugListTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *sugListTabeView;

@end
@implementation SugListTableView{
    NSInteger selectIndex;
}

- (void)setDataArry:(NSArray<NSString *> *)dataArry{
    _dataArry = dataArry;
    [self.sugListTabeView reloadData];
}

- (void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    self.backgroundColor = backColor;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sugListTabeView];
        [self.sugListTabeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        self.hidden = true;
    }
    return self;
}

- (UITableView *)sugListTabeView{
    if (!_sugListTabeView) {
        _sugListTabeView = [[UITableView alloc] init];
        _sugListTabeView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _sugListTabeView.estimatedRowHeight = 0;
        _sugListTabeView.estimatedSectionFooterHeight = 0;
        _sugListTabeView.estimatedSectionHeaderHeight = 0;
        _sugListTabeView.tableFooterView = [UIView new];
        _sugListTabeView.delegate = self;
        _sugListTabeView.dataSource = self;
        [_sugListTabeView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellID];
    }
    return _sugListTabeView;
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellID];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.textLabel.text = self.dataArry[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor getHEXRGB:@"222222"];
    return cell;
}

#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.delegate) {
        [self.delegate actionWithDidSelect:self.dataArry[indexPath.row]];
    }
}


- (void)show{
    [UIView animateWithDuration:self.animationTime animations:^{
        self.hidden = false;
        self.height = self.defultHight;
    }];
}

- (void)dismis{
    [UIView animateWithDuration:self.animationTime animations:^{
        self.hidden = true;
        self.height = 0;
    }];
}
@end
