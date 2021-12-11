//
//  StepCountManager.h
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/18.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

/**这个类用来在后台记录步行信息，不断在后台获取数据并反映到界面上，界面通过KVO观察其属性来更新界面的数据，记录的数据包括步数、步行总时间、步行距离、步行平均速度、开始和结束时间，这是个单例类
 */

#import <Foundation/Foundation.h>
#import "StepDataModel.h"

@interface StepCountManager : NSObject

+(instancetype)defaultManager;

@property(nonatomic, strong)StepDataModel *model;
@property(nonatomic,strong)StepDataModel *previousModel;
@property(nonatomic,strong)NSDate *currentDate;
@property(nonatomic,strong)NSNumber *target;    //设定目标

@end
