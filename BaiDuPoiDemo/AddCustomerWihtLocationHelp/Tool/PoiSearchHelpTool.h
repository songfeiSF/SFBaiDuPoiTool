//
//  PoiSearchHelpTool.h
//  iseasoftCompany
//
//  Created by songfei on 2018/9/27.
//  Copyright © 2018年 hycrazyfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^PoiSearchBlcok)(id object);
@interface PoiSearchHelpTool : NSObject

/**
 查询的页码
 */
@property (nonatomic ,assign) int pageIndext;

/**
 单例

 @return 返回
 */
+(instancetype) sharedInstance;



/**
 开启代理 在viewWillAppear里调用
 */
- (void)setDelegate;


/**
 移除代理 在viewWillDisappear里调用
 */
- (void)removeDelegate;

/**
 开始以城市poi搜索

 @param city 城市
 @param keyword 关键词
 @param blcok 返回
 */
- (void)startPoiSearchWihtCity:(NSString*)city keyword:(NSString*)keyword block:(PoiSearchBlcok)blcok;


/**
 开始搜索周围

 @param centerCoordinate 坐标
 @param keyword 关键词
 @param blcok 返回
 */
- (void)startPoiSearchWihtNearyBy:(CLLocationCoordinate2D)centerCoordinate keyword:(NSString*)keyword block:(PoiSearchBlcok)blcok;



/**
 地点输入提示检索（Sug检索）

 @param city 城市
 @param keyword 关键词
 @param blcok 返回
 */
- (void)startSugSearchWihtCity:(NSString*)city  keyword:(NSString*)keyword block:(PoiSearchBlcok)blcok;

/**
 开始反地理编码

 @param centerCoordinate 经纬度坐标
 @param blcok 返回
 */
- (void)startGeoSearchWithLocation:(CLLocationCoordinate2D)centerCoordinate block:(PoiSearchBlcok)blcok;
@end

NS_ASSUME_NONNULL_END
