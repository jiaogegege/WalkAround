//
//  DailyRecordViewController.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/20.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "DailyRecordViewController.h"
#import "StepCountManager.h"
#import "DailyStepCountView.h"

@interface DailyRecordViewController ()
{
    //计步器管理器
    StepCountManager *_stepManager;
    UIButton *_backBtn;
    UILabel *_dateLabel;
    UIButton *_targetBtn;
    //距离时间速度
    UILabel *_distanceLabel;
    UILabel *_timeLabel;
    UILabel *_speedLabel;
}
@end

@implementation DailyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    _stepManager = [StepCountManager defaultManager];
}

-(void)createUI
{
    self.view.backgroundColor = bgColor;
    //上部工具和标题栏
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    //添加返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(20, 30, 50, 50);
    [_backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_backBtn];
    //添加日期标签
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70+10, 30, kScreenWidth-70-70-10-10, 50)];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [format stringFromDate:self.date];
    _dateLabel.text = dateStr;
    _dateLabel.textColor = kMainColor;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_dateLabel];
    //添加设定目标按钮
    _targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _targetBtn.frame = CGRectMake(kScreenWidth-70, 30, 50, 50);
    [_targetBtn setImage:[UIImage imageNamed:@"targetBtn"] forState:UIControlStateNormal];
    [_targetBtn addTarget:self action:@selector(targetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_targetBtn];
    
    
    //添加中部圆圈
    CGFloat viewWidth = (kScreenWidth)/6.0 * 4;
    DailyStepCountView *stepView = [[DailyStepCountView alloc] initWithFrame:CGRectMake((kScreenWidth)/6, 100+30, viewWidth, viewWidth)];
    stepView.model = self.model;
    [self.view addSubview:stepView];
    
    //下部数据标签
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100+30+viewWidth, kScreenWidth, kScreenHeight-100-30-viewWidth-49)];
    [self.view addSubview:bottomView];
    //距离、时间、速度
    CGFloat labelWidth = 80;
    CGFloat whiteSpace = (kScreenWidth - 80*3)/4.0;
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace, (bottomView.bounds.size.height-labelWidth)/2.0, labelWidth, labelWidth)];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.font = [UIFont systemFontOfSize:25];
    _distanceLabel.text = [NSString stringWithFormat:@"%.1f", self.model.distance.floatValue/1000];
    _distanceLabel.textColor = kMainColor;
    [bottomView addSubview:_distanceLabel];
    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace, (bottomView.bounds.size.height-labelWidth)/2.0+labelWidth, labelWidth, 30)];
    distance.textAlignment = NSTextAlignmentCenter;
    distance.font = [UIFont systemFontOfSize:12];
    distance.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    distance.text = @"距离:公里";
    [bottomView addSubview:distance];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace+labelWidth+whiteSpace, (bottomView.bounds.size.height-labelWidth)/2.0, labelWidth, labelWidth)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:25];
    _timeLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(self.model.totalTime.floatValue/60.0)];
    _timeLabel.textColor = kMainColor;
    [bottomView addSubview:_timeLabel];
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace+labelWidth+whiteSpace, (bottomView.bounds.size.height-labelWidth)/2.0+labelWidth, labelWidth, 30)];
    time.textAlignment = NSTextAlignmentCenter;
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    time.text = @"时间:分钟";
    [bottomView addSubview:time];
    
    _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace+2*(labelWidth+whiteSpace), (bottomView.bounds.size.height-labelWidth)/2.0, labelWidth, labelWidth)];
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    _speedLabel.font = [UIFont systemFontOfSize:25];
    _speedLabel.text = [NSString stringWithFormat:@"%.1f", self.model.speed.floatValue];
    _speedLabel.textColor = kMainColor;
    [bottomView addSubview:_speedLabel];
    UILabel *speed = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace+2*(labelWidth+whiteSpace), (bottomView.bounds.size.height-labelWidth)/2.0+labelWidth, labelWidth, 30)];
    speed.textAlignment = NSTextAlignmentCenter;
    speed.font = [UIFont systemFontOfSize:12];
    speed.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    speed.text = @"速度:米/秒";
    [bottomView addSubview:speed];
}

///返回按钮单击事件
-(void)backBtnClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

///目标按钮单击事件
-(void)targetBtnClicked:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设定目标" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alert.textFields[0].text.integerValue)
        {
            _stepManager.target = @(alert.textFields[0].text.integerValue);
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
