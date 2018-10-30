//
//  ViewController.m
//  BaiDuPoiDemo
//
//  Created by songfei on 2018/10/30.
//  Copyright © 2018年 songfei. All rights reserved.
//

#import "ViewController.h"
#import "AddCustomerWihtMapVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(id)sender {
    AddCustomerWihtMapVC *vc = [[AddCustomerWihtMapVC alloc] initWihtBlcok:^(id  _Nonnull obj) {
        
        
    }];
    UINavigationController *nav  = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:true completion:nil];
}


@end
