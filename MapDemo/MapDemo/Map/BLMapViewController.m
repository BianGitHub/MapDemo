//
//  BLMapViewController.m
//  MapDemo
//
//  Created by 边雷 on 16/11/30.
//  Copyright © 2016年 Mac-b. All rights reserved.
//

#import "BLMapViewController.h"
#import <MapKit/MapKit.h>
@interface BLMapViewController ()
@property(nonatomic, weak) MKMapView *map;
@end

@implementation BLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //隐藏返回item
    self.navigationItem.hidesBackButton = YES;
    
    [self setupUI];
}

- (void)setupUI
{
    MKMapView *map = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:map];
    self.map = map;
}

@end
