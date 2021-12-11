//
//  StepDataModel.h
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/18.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepDataModel : NSObject

@property(nonatomic, strong)NSDate *date;   //记录当天的年月日
@property(nonatomic, strong)NSNumber *numberOfSteps;    //记录当天的步数
@property(nonatomic, strong)NSNumber *distance;     //记录当天的距离
@property(nonatomic, strong)NSNumber *totalTime;    //记录当天的总时间
@property(nonatomic, strong)NSNumber *speed;    //记录当天的平均速度


@end
