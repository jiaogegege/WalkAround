//
//  StepCountManager.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/18.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "StepCountManager.h"
#import <CoreMotion/CoreMotion.h>
#import "DataBaseManager.h"

@interface StepCountManager()
{
    CMPedometer *_stepManager;
    DataBaseManager *_dbManager;
    NSDate *_lastUpdateDate;
}
@end

@implementation StepCountManager

static StepCountManager *_instance = nil;

///获取单例类方法
+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return  _instance;
}
///重写初始化方法
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

///初始化计步器，初始化只执行一次，发生在第一次启动app的时候，如果app进入后台被挂起再次打开的时候不会执行init方法，因此在init方法中先获得今天之前的步行数据，然后再进行计步
-(instancetype)init
{
    if (self = [super init])
    {
        //初始化模型对象
        self.model = [[StepDataModel alloc] init];
        self.previousModel = [[StepDataModel alloc] init];
        //数据库对象
        _dbManager = [DataBaseManager defaultManager];
        //最近更新的日期
        _lastUpdateDate = [self getTodayDate];
        //默认目标为5000步，可以修改
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([user objectForKey:@"target"])
        {
            _target = [user objectForKey:@"target"];
        }
        else
        {
            self.target = @(5000);
        }
        
        //判断是否支持计步器
        if ([CMPedometer isStepCountingAvailable])
        {
            NSLog(@"支持计步器");
            //设备支持计步器，那么初始化计步器对象
            _stepManager = [[CMPedometer alloc] init];
            
            //更新计步器数据
            [_stepManager startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                self.model.date = [self getTodayDate];
                //保存数据模型用来显示在界面和存储到数据库中
                self.model.numberOfSteps = pedometerData.numberOfSteps;
                self.model.distance = pedometerData.distance;
                self.model.totalTime = @([pedometerData.endDate timeIntervalSinceDate:pedometerData.startDate]);
                self.model.speed = @(self.model.distance.doubleValue / self.model.totalTime.doubleValue);
                //这个时间戳用来提醒界面的KVO数据已经更新，界面应该从数据模型中取数据
                self.currentDate = [NSDate date];
                //每次更新完数据都应该保存到数据库
                [_dbManager updateRecordWithNewData:self.model];
                /**如果更新到的时间是第二天，那么就应该保存数据并开始一个新的计步处理
                 */
                if (![self.model.date isEqualToDate:_lastUpdateDate])
                {
                    _lastUpdateDate = self.model.date;
                    //开始一个新更新
                    [self startNewStepUpdate];
                }
                else
                {
                    _lastUpdateDate = self.model.date;
                }
                
                
            }];
            
        }
        else
        {
            NSLog(@"不支持计步器");
        }
    }
    return self;
}

///开始一个新的更新
-(void)startNewStepUpdate
{
    [_stepManager stopPedometerUpdates];
    [_stepManager startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        self.model.date = [self getTodayDate];
        //保存数据模型用来显示在界面和存储到数据库中
        self.model.numberOfSteps = pedometerData.numberOfSteps;
        self.model.distance = pedometerData.distance;
        self.model.totalTime = @([pedometerData.endDate timeIntervalSinceDate:pedometerData.startDate]);
        self.model.speed = @(self.model.distance.doubleValue / self.model.totalTime.doubleValue);
        //每次更新完数据都应该保存到数据库
        [_dbManager updateRecordWithNewData:self.model];
        /**如果更新到的时间是第二天，那么就应该保存数据并开始一个新的计步处理
         */
        if (![self.model.date isEqualToDate:_lastUpdateDate])
        {
            _lastUpdateDate = self.model.date;
            //开始一个新更新
            [self startNewStepUpdate];
        }
        else
        {
            _lastUpdateDate = self.model.date;
        }
        //这个时间戳用来提醒界面的KVO数据已经更新，界面应该从数据模型中取数据
        self.currentDate = [NSDate date];
    }];
}

///得到今天零点的NSDate
-(NSDate *)getTodayZeroDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *zeroDate = [calendar dateFromComponents:components];
    return zeroDate;
}

///得到今天的年月日
-(NSDate *)getTodayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *todayDate = [calendar dateFromComponents:components];
    return todayDate;
}

//将目标保存起来
-(void)setTarget:(NSNumber *)target
{
    _target = target;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:_target forKey:@"target"];
    [user synchronize];
}


@end
