//
//  DataBaseManager.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/20.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabase.h"


@interface DataBaseManager()
{
    FMDatabase *_dataBase;
    NSLock *_lock;
}
@end

@implementation DataBaseManager

//单例类方法
+(DataBaseManager *)defaultManager
{
    static DataBaseManager *dbManager = nil;
    @synchronized(self) {
        if (dbManager == nil)
        {
            dbManager = [[DataBaseManager alloc] init];
        }
    }
    return dbManager;
}

-(instancetype)init
{
    if (self = [super init])
    {
        _lock = [[NSLock alloc] init];
        //数据库文件路径
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/stepData.db"];
        NSLog(@"%@", dbPath);
        _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        if ([_dataBase open])
        {
            NSString *sql = @"create table if not exists everyDaySteps(date vchar(255) primary key, numberOfSteps integer, distance double, totalTime double, speed double)";
            //执行sql语句
            BOOL ret = [_dataBase executeUpdate:sql];
            if (!ret)
            {
                NSLog(@"create table error:%@", _dataBase.lastErrorMessage);
            }
        }
        else
        {
            NSLog(@"open database error:%@", _dataBase.lastErrorMessage);
        }
    }
    return self;
}

///计步器管理器需要调用的方法，该方法根据传入的模型去查询该记录是否存在，不存在就创建，如果存在就更新该记录
-(void)updateRecordWithNewData:(StepDataModel *)model
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *date = [format stringFromDate:model.date];
    BOOL ret = [self queryRecordByDate:date];
    if (ret)
    {
        [self updateRecordWithModel:model];
    }
    else
    {
        [self addRecordWithModel:model];
    }
}

///内部调用，根据日期查询某条记录是否存在，存在返回yes，不存在返回no
-(BOOL)queryRecordByDate:(NSString *)date
{
    [_lock lock];
    BOOL ret = NO;
    NSString *sql = @"select * from everyDaySteps where date=?";
    FMResultSet *set = [_dataBase executeQuery:sql, date];
    if ([set next])
    {
        ret = YES;
    }
    [_lock unlock];
    return ret;
}

///如果记录存在那么更新该记录
-(void)updateRecordWithModel:(StepDataModel *)model
{
    [_lock lock];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *date = [format stringFromDate:model.date];
    NSString *sql = @"update everyDaySteps set numberOfSteps=?, distance=?, totalTime=?, speed=? where date=?";
    BOOL ret = [_dataBase executeUpdate:sql, model.numberOfSteps, model.distance, model.totalTime, model.speed, date];
    if (!ret)
    {
        NSLog(@"update error:%@", _dataBase.lastErrorMessage);
    }
    [_lock unlock];
}

///如果记录不存在那么新增该记录
-(void)addRecordWithModel:(StepDataModel *)model
{
    [_lock lock];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *date = [format stringFromDate:model.date];
    NSString *sql = @"insert into everyDaySteps(date, numberOfSteps, distance, totalTime, speed)values(?,?,?,?,?)";
    BOOL ret = [_dataBase executeUpdate:sql, date, model.numberOfSteps, model.distance, model.totalTime, model.speed];
    if (!ret)
    {
        NSLog(@"insert error:%@", _dataBase.lastErrorMessage);
    }
    [_lock unlock];
}

///查询所有记录
-(NSArray *)getAllData
{
    [_lock lock];
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *sql = @"select * from everyDaySteps";
    FMResultSet *set = [_dataBase executeQuery:sql];
    while ([set next])
    {
        StepDataModel *model = [[StepDataModel alloc] init];
        NSString *date = [set stringForColumn:@"date"];
        model.date = [format dateFromString:date];
        model.numberOfSteps = @([set intForColumn:@"numberOfSteps"]);
        model.distance = @([set doubleForColumn:@"distance"]);
        model.totalTime = @([set doubleForColumn:@"totalTime"]);
        model.speed = @([set doubleForColumn:@"speed"]);
        [modelArray addObject:model];
    }
    [_lock unlock];
    return modelArray;
}

///根据日期查询某条记录并返回
-(StepDataModel *)getModelByDate:(NSDate *)date
{
    [_lock lock];
    StepDataModel *model = nil;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [format stringFromDate:date];
    NSString *sql = @"select * from everyDaySteps where date=?";
    FMResultSet *set = [_dataBase executeQuery:sql, dateStr];
    if ([set next])
    {
        model = [[StepDataModel alloc] init];
        NSString *retDate = [set stringForColumn:@"date"];
        model.date = [format dateFromString:retDate];
        model.numberOfSteps = @([set intForColumn:@"numberOfSteps"]);
        model.distance = @([set doubleForColumn:@"distance"]);
        model.totalTime = @([set doubleForColumn:@"totalTime"]);
        model.speed = @([set doubleForColumn:@"speed"]);
    }
    [_lock unlock];
    return model;
}

@end
