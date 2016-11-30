//
//  BLMapViewController.m
//  MapDemo
//
//  Created by 边雷 on 16/11/30.
//  Copyright © 2016年 Mac-b. All rights reserved.
//

#import "BLMapViewController.h"
#import "Masonry.h"
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
    //添加地图类型
    [self addMapType];
    //添加返回按钮    返回定位点
    [self backBtn];
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
    self.map.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.map.delegate = self;
    //显示标尺
    self.map.showsScale = YES;
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

#pragma mark - 地图类型
- (void)addMapType
{
    NSArray *arr = @[@"标准",@"卫星",@"混合"];
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:arr];
    seg.frame = CGRectMake(18, 95, 180, 20);
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(clickSeg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: seg];
}

#pragma mark - 地图类型点击事件
- (void)clickSeg:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.map.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.map.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.map.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}

#pragma mark - 返回定位点
- (void)backBtn
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.backgroundColor = [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 1;
    [btn sizeToFit];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(backUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
}
/** 返回按钮点击事件*/
- (void)backUserLocation
{
    //  方式一:  修改用户定位跟踪模式 并实现动画
//    [self.map setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
    //  方式二:修改地图显示的范围 -> 定位的范围
    //  中心点 = 定位点
    CLLocationCoordinate2D center = self.map.userLocation.location.coordinate;
    //  跨度 = 当前地图的跨度
    MKCoordinateSpan span = self.map.region.span;
    [self.map setRegion:MKCoordinateRegionMake(center, span) animated:YES];
}

@end
