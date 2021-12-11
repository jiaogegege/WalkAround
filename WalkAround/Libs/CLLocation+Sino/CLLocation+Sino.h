//
//  CLLocation+Sino.h
//
//  Created by i0xbean@gmail.com on 13-4-26.
//  火星坐标系转换扩展
//
//  earth（国外 WGS84）, mars（国内 GCJ-02）, bearPaw（百度 BD-09） 坐标系间相互转换
//  未包含 mars2earth. 需要这个可参考 http://xcodev.com/131.html

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Sino)

//从地图坐标转化到火星坐标
- (CLLocation*)locationMarsFromEarth;

//- (CLLocation*)locationEarthFromMars; // 未实现

//从火星坐标转化到百度坐标
- (CLLocation*)locationBearPawFromMars;
//从百度坐标到火星坐标  
- (CLLocation*)locationMarsFromBearPaw;

@end