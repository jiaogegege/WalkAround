//
//  MainViewController.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/19.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "MainViewController.h"
#import "PrefixHeader.pch"
#import "CalendarView.h"
#import "StepCountView.h"
#import "StepCountManager.h"
#import "DataBaseManager.h"
#import "DailyRecordViewController.h"

@interface MainViewController ()<CalendarViewDelegate>
{
    //计步器管理器
    StepCountManager *_stepManager;
    CalendarView *_calendarView;
    UIButton *_calendarBtn;
    UILabel *_dateLabel;
    UIButton *_targetBtn;
    //距离时间速度
    UILabel *_distanceLabel;
    UILabel *_timeLabel;
    UILabel *_speedLabel;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    //添加KVO
    _stepManager = [StepCountManager defaultManager];
    [_stepManager addObserver:self forKeyPath:@"currentDate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
}

-(void)createUI
{
    self.view.backgroundColor = bgColor;
    //上部工具和标题栏
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    //添加日历按钮
    _calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _calendarBtn.frame = CGRectMake(20, 30, 50, 50);
    [_calendarBtn setImage:[UIImage imageNamed:@"CalendarBtnIcon"] forState:UIControlStateNormal];
    [_calendarBtn addTarget:self action:@selector(calendarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_calendarBtn];
    UILabel *calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 50, 10)];
    calendarLabel.textAlignment = NSTextAlignmentCenter;
    calendarLabel.textColor = kMainColor;
    calendarLabel.font = [UIFont systemFontOfSize:10];
    calendarLabel.text = @"日历";
    [topView addSubview:calendarLabel];
    
    //添加日期标签
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70+10, 30, kScreenWidth-70-70-10-10, 50)];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *currentDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [format stringFromDate:currentDate];
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
    UILabel *targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 85, 50, 10)];
    targetLabel.textAlignment = NSTextAlignmentCenter;
    targetLabel.textColor = kMainColor;
    targetLabel.font = [UIFont systemFontOfSize:10];
    targetLabel.text = @"目标";
    [topView addSubview:targetLabel];
    
    //添加中部圆圈
    CGFloat viewWidth = (kScreenWidth)/6.0 * 4;
    StepCountView *stepView = [[StepCountView alloc] initWithFrame:CGRectMake((kScreenWidth)/6, 100+30, viewWidth, viewWidth)];
    [self.view addSubview:stepView];
    
    //下部数据标签
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100+30+viewWidth, kScreenWidth, kScreenHeight-100-30-viewWidth-49)];
//    bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomView];
    //距离、时间、速度
    CGFloat labelWidth = 80;
    CGFloat whiteSpace = (kScreenWidth - 80*3)/4.0;
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace, (bottomView.bounds.size.height-labelWidth)/2.0, labelWidth, labelWidth)];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.font = [UIFont systemFontOfSize:25];
    _distanceLabel.text = [NSString stringWithFormat:@"%.1f", 0.0];
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
    _timeLabel.text = [NSString stringWithFormat:@"%d", 0];
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
    _speedLabel.text = [NSString stringWithFormat:@"%.1f", 0.0];
    _speedLabel.textColor = kMainColor;
    [bottomView addSubview:_speedLabel];
    UILabel *speed = [[UILabel alloc] initWithFrame:CGRectMake(whiteSpace+2*(labelWidth+whiteSpace), (bottomView.bounds.size.height-labelWidth)/2.0+labelWidth, labelWidth, 30)];
    speed.textAlignment = NSTextAlignmentCenter;
    speed.font = [UIFont systemFontOfSize:12];
    speed.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    speed.text = @"速度:米/秒";
    [bottomView addSubview:speed];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentDate"])
    {
        _distanceLabel.text = [NSString stringWithFormat:@"%.1f", _stepManager.model.distance.floatValue/1000];
        _timeLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(_stepManager.model.totalTime.floatValue/60.0)];
        _speedLabel.text = [NSString stringWithFormat:@"%.1f", _stepManager.model.speed.floatValue];
    }
}

-(void)calendarBtnClicked:(UIButton *)sender
{
    
    UIView *mask = [[UIView alloc] initWithFrame:self.view.bounds];
    mask.tag = 500;
    [self.view addSubview:mask];
    mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [mask addGestureRecognizer:tap];
    
    _calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, -0.8*kScreenWidth, kScreenWidth, 0.8 * kScreenWidth)];
    _calendarView.delegate = self;
    [self.view addSubview:_calendarView];
    [UIView animateWithDuration:0.5 animations:^{
        _calendarView.frame = CGRectMake(0, 20, kScreenWidth, 0.8 * kScreenWidth);
    }];
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

///给背景叠加层添加的手势
-(void)tapGestureHandler:(UITapGestureRecognizer *)sender
{
    UIView *mask = sender.view;
    [UIView animateWithDuration:0.5 animations:^{
        _calendarView.frame = CGRectMake(0, -0.8*kScreenWidth, kScreenWidth, 0.8 * kScreenWidth);
        
    } completion:^(BOOL finished) {
        [_calendarView removeFromSuperview];
        [mask removeFromSuperview];
    }];
    
}

#pragma  mark - 日历控件的协议方法
-(void)getDateByClickedButton:(NSDate *)date
{
    //从数据库查询往期步行数据，显示一个ViewController展示往期步行数据
    [UIView animateWithDuration:0.5 animations:^{
        _calendarView.frame = CGRectMake(0, -0.8*kScreenWidth, kScreenWidth, 0.8 * kScreenWidth);
    } completion:^(BOOL finished) {
        UIView *mask = [self.view viewWithTag:500];
        [mask removeFromSuperview];
        [_calendarView removeFromSuperview];
        //在此弹出新的视图控制器
        DataBaseManager *manager = [DataBaseManager defaultManager];
        DailyRecordViewController *dvc = [[DailyRecordViewController alloc] init];
        dvc.model = [manager getModelByDate:date];
        dvc.date = date;
        [self presentViewController:dvc animated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
