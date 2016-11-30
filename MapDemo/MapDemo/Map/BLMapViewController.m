//
//  BLMapViewController.m
//  MapDemo
//
//  Created by 边雷 on 16/11/30.
//  Copyright © 2016年 Mac-b. All rights reserved.
//

#import "BLMapViewController.h"
#import <MapKit/MapKit.h>
@interface BLMapViewController ()<MKMapViewDelegate>
@property(nonatomic, weak) MKMapView *map;
@property(nonatomic, strong) CLLocationManager *mgr;
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
    
    //授权   设置info.plist
    self.mgr = [CLLocationManager new];
    if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mgr requestWhenInUseAuthorization];
    }
    self.map.userTrackingMode = MKUserTrackingModeFollow;
    
    self.map.delegate = self;
}

#pragma mark - 定位大头针 反地理编码
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLGeocoder *gecoder = [CLGeocoder new];
    
    CLLocation *location = userLocation.location;
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //判断地标对象
        if (placemarks.count == 0 || error) {
            return ;
        }
        
        //设置数据
        self.map.userLocation.title = placemarks.lastObject.locality;
        self.map.userLocation.subtitle = placemarks.lastObject.name;
    }];
}


@end
