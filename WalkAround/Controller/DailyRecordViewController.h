//
//  DailyRecordViewController.h
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/20.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepDataModel.h"

@interface DailyRecordViewController : UIViewController
@property(nonatomic,strong)StepDataModel *model;
@property(nonatomic,strong)NSDate *date;
@end
