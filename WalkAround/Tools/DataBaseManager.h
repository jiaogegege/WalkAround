//
//  DataBaseManager.h
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/20.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StepDataModel.h"

@interface DataBaseManager : NSObject

+(DataBaseManager *)defaultManager;
-(void)updateRecordWithNewData:(StepDataModel *)model;
-(StepDataModel *)getModelByDate:(NSDate *)date;
-(NSArray *)getAllData;
@end
