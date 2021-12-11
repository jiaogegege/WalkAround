//
//  MyInfoViewController.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/19.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "MyInfoViewController.h"
#import "PrefixHeader.pch"
#import "StepDataModel.h"
#import "StepCountManager.h"
#import "DataBaseManager.h"

@interface MyInfoViewController ()
{
    StepCountManager *_stepManager;
    DataBaseManager *_dbManager;
    NSArray *_dataArray;
    NSMutableArray *_dataLabelArray;
}
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataLabelArray = [[NSMutableArray alloc] init];
    //先拿到所有数据
    _stepManager = [StepCountManager defaultManager];
    [_stepManager addObserver:self forKeyPath:@"currentDate" options:NSKeyValueObservingOptionNew context:nil];
    _dbManager = [DataBaseManager defaultManager];
    _dataArray = [_dbManager getAllData];
    [self createUI];
    [self addLabelData];
}

-(void)createUI
{
    self.view.backgroundColor = bgColor;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.title = @"我的记录";
    
    //设置各项记录
    NSArray *titleArray = @[@"总步数", @"总距离", @"总时间", @"平均速度", @"最好成绩", @"累计天数"];
    CGFloat height = (kScreenHeight - 64 - 49)/6.0;
    for (int i = 0; i < 6; ++i)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+i*height, kScreenWidth/3.0, height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = titleArray[i];
        [self.view addSubview:titleLabel];
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0, 64+i*height, kScreenWidth/3.0*2, height)];
        dataLabel.textColor = kMainColor;
        dataLabel.font = [UIFont systemFontOfSize:25];
        [self.view addSubview:dataLabel];
        [_dataLabelArray addObject:dataLabel];
    }
}

///处理数据
-(void)addLabelData
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSNumber *totalSteps = [_dataArray valueForKeyPath:@"@sum.numberOfSteps"];
    NSString *totalStepsStr = [NSString stringWithFormat:@"%ld步", totalSteps.integerValue];
    [dataArray addObject:totalStepsStr];
    NSNumber *totalDis = [_dataArray valueForKeyPath:@"@sum.distance"];
    NSString *distanceStr = [NSString stringWithFormat:@"%.1f公里", totalDis.floatValue/1000];
    [dataArray addObject:distanceStr];
    NSNumber *totalTime = [_dataArray valueForKeyPath:@"@sum.totalTime"];
    NSString *timeStr = [NSString stringWithFormat:@"%ld分钟", totalTime.integerValue/60];
    [dataArray addObject:timeStr];
    NSNumber *avgSpeed = [_dataArray valueForKeyPath:@"@avg.speed"];
    NSString *speedStr = [NSString stringWithFormat:@"%.1f米/秒", avgSpeed.floatValue];
    [dataArray addObject:speedStr];
    NSNumber *maxStep = [_dataArray valueForKeyPath:@"@max.numberOfSteps"];
    NSString *maxStepStr = [NSString stringWithFormat:@"%ld步", maxStep.integerValue];
    [dataArray addObject:maxStepStr];
    NSNumber *dayCount = [_dataArray valueForKeyPath:@"@count"];
    NSString *totalDays = [NSString stringWithFormat:@"%ld天", dayCount.integerValue];
    [dataArray addObject:totalDays];
    //写到界面上
    [_dataLabelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = obj;
        label.text = dataArray[idx];
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentDate"])
    {
        _dataArray = [_dbManager getAllData];
        [self addLabelData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
