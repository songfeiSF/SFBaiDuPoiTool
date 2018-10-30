//
//  PoiSearchHelpTool.m
//  iseasoftCompany
//
//  Created by songfei on 2018/9/27.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import "PoiSearchHelpTool.h"

static PoiSearchHelpTool * _instance = nil;

@interface PoiSearchHelpTool()<BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate>
@property(nonatomic,strong) BMKPoiSearch * poisearch;
@property (nonatomic ,strong)BMKGeoCodeSearch *geoSearcher;

@property (nonatomic ,strong)BMKSuggestionSearch *sugSearcher;

@property (nonatomic ,copy)PoiSearchBlcok poiSearchBlcok;
@end

@implementation PoiSearchHelpTool

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone ];
        [_instance setSearcherInit];
    });
    return _instance;
}

+(instancetype) sharedInstance{
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}

- (void)setSearcherInit{
    //初始化POI搜索服务
    self.poisearch =[[BMKPoiSearch alloc]init];
    //初始化GEO检索服务
    self.geoSearcher = [[BMKGeoCodeSearch alloc]init];
    //初始化 地点输入提示服务
    self.sugSearcher = [[BMKSuggestionSearch alloc] init];
}

- (void)setDelegate{
    self.poisearch.delegate = self;
    self.geoSearcher.delegate = self;
    self.sugSearcher.delegate = self;
}

- (void)removeDelegate{
    self.poisearch.delegate = nil;
    self.geoSearcher.delegate = nil;
    self.sugSearcher.delegate = nil;
}


#pragma mark --开始POI检索
- (void)startPoiSearchWihtCity:(NSString*)city keyword:(NSString*)keyword block:(PoiSearchBlcok)blcok{
    //请求参数类BMKCitySearchOption
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = self.pageIndext;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= city;
    citySearchOption.keyword = keyword;
    //发起城市内POI检索
    BOOL flag = [self.poisearch poiSearchInCity:citySearchOption];
    if(flag) {
        NSLog(@"POI城市内检索发送成功");
        self.poiSearchBlcok = blcok;
    }
    else {
        NSLog(@"POI城市内检索发送失败");
    }
}

- (void)startPoiSearchWihtNearyBy:(CLLocationCoordinate2D)centerCoordinate keyword:(NSString*)keyword block:(PoiSearchBlcok)blcok{
    //请求参数类BMKCitySearchOption
    BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc]init];
    nearbySearchOption.pageIndex = self.pageIndext;
    nearbySearchOption.pageCapacity = 20;
    nearbySearchOption.location= centerCoordinate;
    nearbySearchOption.radius = 500;
    nearbySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;
    nearbySearchOption.keyword = keyword;
    //发起城市内POI检索
    BOOL flag = [self.poisearch poiSearchNearBy:nearbySearchOption];
    if(flag) {
        NSLog(@"POI附近范围检索发送成功");
        self.poiSearchBlcok = blcok;
    }
    else {
        NSLog(@"POI附近范围检索发送失败");
    }
}



- (void)startSugSearchWihtCity:(NSString*)city  keyword:(NSString*)keyword block:(PoiSearchBlcok)blcok{
    //初始化检索对象
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = city;
    option.keyword  = keyword;
    BOOL flag = [self.sugSearcher suggestionSearch:option];
    if(flag)
    {
        NSLog(@"Sug检索发送成功");
        self.poiSearchBlcok = blcok;
    }
    
    else
    {
        NSLog(@"Sug检索发送失败");
    }
}


//反地理编码查找周边 根据坐标查询 详细地址
- (void)startGeoSearchWithLocation:(CLLocationCoordinate2D)centerCoordinate block:(PoiSearchBlcok)blcok{
    //反地理编码 根据坐标找地址
    BMKReverseGeoCodeOption *geoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
    geoCodeOption.reverseGeoPoint = centerCoordinate;
    BOOL flag = [self.geoSearcher reverseGeoCode:geoCodeOption];
    if(flag){
        NSLog(@"geo检索发送成功");
        self.poiSearchBlcok = blcok;
    }else{
        NSLog(@"geo检索发送失败");
    }
}

#pragma mark --BMKPoiSearchDelegate POI检索回调代理
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(poiResult.poiInfoList);
        }
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(@[]);
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(@[]);
        }
    }
    
}

#pragma mark --BMKSuggestionSearchDelegate 地点输入提示检索（Sug检索)
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(result.keyList);
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(@[]);
        }
    }
    else {
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(@[]);
        }
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark --BMKGeoCodeSearchDelegate 反地理编码回调代理
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (self.poiSearchBlcok) {
            self.poiSearchBlcok(result);
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    }
    else{
        NSLog(@"geo检索结果有误");
    }
}

@end
