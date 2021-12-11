//
//  CalendarView.m
//  UI额外内容
//
//  Created by 蒋雪姣 on 15/12/29.
//  Copyright © 2015年 蒋雪姣. All rights reserved.
//

#import "CalendarView.h"

#define cellHeight (self.bounds.size.height/8.0)
#define cellWidth (self.bounds.size.width/7.0)

@interface CalendarView()
{
    NSDate *_currentDate;   //该日期总是置为一个月的第一天
    UIButton *_preMonth;
    UIButton *_nextMonth;
    UIView *_mainView;
    UILabel *_infoLabel;    //顶部标签栏
    UIButton *_lastClickBtn;    //当前被点击的日期
}
@end

@implementation CalendarView

-(void)createUI
{
    //8行7列
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    //添加顶部信息栏
    UIView *topVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, cellHeight)];
    topVIew.backgroundColor = kMainColor;
    [bgView addSubview:topVIew];
    //添加前按钮
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    preBtn.frame = CGRectMake(0, 0, cellWidth, cellHeight);
    [preBtn setTitle:@"前" forState:UIControlStateNormal];
    [preBtn addTarget:self action:@selector(clickPreMonthBtn:) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topVIew addSubview:preBtn];
    //添加后按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(6*cellWidth, 0, cellWidth, cellHeight);
    [nextBtn setTitle:@"后" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextMonthBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topVIew addSubview:nextBtn];
    //添加中间标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth, 0, 5*cellWidth, cellHeight)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self getMonthAndYear];
    [topVIew addSubview:label];
    _infoLabel = label;
    
    ///添加中部星期栏
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight, bgView.bounds.size.width, cellHeight)];
    middleView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:middleView];
    //创建星期数
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四",@"五", @"六"];
    for (int i = 0; i < array.count; ++i)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * cellWidth, 0, cellWidth, cellHeight)];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kMainColor;
        [middleView addSubview:label];
    }
    
    //添加下部日期
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * cellHeight, bgView.bounds.size.width, bgView.bounds.size.height - 2 * cellHeight)];
    mainView.backgroundColor = [UIColor whiteColor];
    _mainView = mainView;
    [bgView addSubview: mainView];
    NSInteger numberOfDays = [self getNumberOfCurrentMonth];
    NSUInteger firstWeekday = [self firstWeekdayInThisMonth];
    for (int i = 0; i < 6; ++i)
    {
        for (int j = 0; j < 7; ++j)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(j * cellWidth, i * cellHeight, cellWidth, cellHeight);
            [btn addTarget:self action:@selector(clickDateBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.layer.borderWidth = 1;
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1].CGColor;
            [mainView addSubview:btn];
        }
    }
    NSArray *btnArray = mainView.subviews;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger today = [calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    //填充日期
    for (int i = 1; i <= numberOfDays; ++i)
    {
        UIButton *btn = btnArray[i+firstWeekday-1];
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        //如果是今天，背景颜色
        if (i == today)
        {
            [btn setBackgroundColor:kMainColor];
        }
    }
    
    //设置当前日期
    calendar.firstWeekday = 1;  //星期天是一周的第一天
    NSDateComponents *com = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    com.day = 1;
    _currentDate = [calendar dateFromComponents:com];
}

///单击日期按钮的事件
-(void)clickDateBtn:(UIButton *)sender
{
    if (sender.currentTitle.length>0)
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *com = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_currentDate];
        com.day = [sender.currentTitle integerValue];
        NSDate *date = [calendar dateFromComponents:com];
        [self.delegate getDateByClickedButton:date];
        NSDateComponents *today = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        if (!(com.day == today.day && com.year == today.year && com.month == today.month))
        {
            [sender setBackgroundColor:kMainColor];
            if (_lastClickBtn != nil)
            {
                [_lastClickBtn setBackgroundColor:[UIColor whiteColor]];
                _lastClickBtn = sender;
            }
            else
            {
                _lastClickBtn = sender;
            }
        }
        else
        {
            [_lastClickBtn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

///获得当前月的第一天是星期几
-(NSInteger)firstWeekdayInThisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 1;  //星期天是一周的第一天
    NSDateComponents *com = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    com.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:com];
    NSUInteger weekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDate];
    return weekday -1;
}

///获得当前月的天数
-(NSInteger)getNumberOfCurrentMonth
{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    return range.length;
}

///获得标签的年份和月份
-(NSString *)getMonthAndYear
{
    NSDate *date = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    NSString *str = [NSString stringWithFormat:@"%ld-%ld", components.year, components.month];
    return str;
}

//点击前一个月
-(void)clickPreMonthBtn:(UIButton *)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *com = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_currentDate];
    com.month -= 1;
    if (com.month < 1)
    {
        com.month = 12;
        com.year -= 1;
    }
    //修改标签的年份和月份
    _infoLabel.text = [NSString stringWithFormat:@"%ld-%ld",com.year, com.month];
    //获得上一个月的天数和第一天的星期数
    _currentDate = [calendar dateFromComponents:com];
    NSInteger numberOfDays = [self getNumberOfMonth];
    NSUInteger firstWeekday = [self firstWeekdayInMonth];
    NSArray *btnArray = _mainView.subviews;
    //更新日期
    for (int i = 0; i < btnArray.count; ++i)
    {
        UIButton *btn = btnArray[i];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    NSDateComponents *today = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    for (int i = 1; i <= numberOfDays; ++i)
    {
        UIButton *btn = btnArray[i+firstWeekday-1];
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        //如果是今天，背景颜色
        if (i == today.day && com.year == today.year && com.month == today.month)
        {
            [btn setBackgroundColor:kMainColor];
        }
    }
}

///单击后一个月
-(void)clickNextMonthBtn:(UIButton *)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *com = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_currentDate];
    com.month += 1;
    if (com.month > 12)
    {
        com.month = 1;
        com.year += 1;
    }
    //修改标签的年份和月份
    _infoLabel.text = [NSString stringWithFormat:@"%ld-%ld",com.year, com.month];
    //获得下一个月的天数和第一天的星期数
    _currentDate = [calendar dateFromComponents:com];
    NSInteger numberOfDays = [self getNumberOfMonth];
    NSUInteger firstWeekday = [self firstWeekdayInMonth];
    NSArray *btnArray = _mainView.subviews;
    //更新日期
    for (int i = 0; i < btnArray.count; ++i)
    {
        UIButton *btn = btnArray[i];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    NSDateComponents *today = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    for (int i = 1; i <= numberOfDays; ++i)
    {
        UIButton *btn = btnArray[i+firstWeekday-1];
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        if (i == today.day && com.year == today.year && com.month == today.month)
        {
            [btn setBackgroundColor:kMainColor];
        }
    }
}

-(NSInteger)getNumberOfMonth
{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_currentDate];
    return range.length;
}
///获得月份的第一天是星期几
-(NSInteger)firstWeekdayInMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 1;  //星期天是一周的第一天
    NSDateComponents *com = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:_currentDate];
    com.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:com];
    NSUInteger weekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDate];
    return weekday -1;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self createUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

@end
