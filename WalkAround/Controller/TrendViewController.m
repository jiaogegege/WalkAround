//
//  TrendViewController.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/19.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "TrendViewController.h"
#import "PrefixHeader.pch"
#import "DataBaseManager.h"
#import "StepDataModel.h"
#import "TrendView.h"
#import "StepCountManager.h"

@interface TrendViewController ()
{
    DataBaseManager *_dbManager;
    NSArray *_dataArray;
    StepCountManager *_stepManager;
    UILabel *_label;
    TrendView *_tv;
    UIScrollView *_scrollView;
}
@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _stepManager = [StepCountManager defaultManager];
    //KVO观察
    [_stepManager addObserver:self forKeyPath:@"currentDate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    //先拿到所有记录的数据
    _dbManager = [DataBaseManager defaultManager];
    _dataArray = [_dbManager getAllData];
    [self createUI];
    
}

-(void)createUI
{
    self.view.backgroundColor = bgColor;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight-49)/3)];
    imgView.image = [UIImage imageNamed:@"trendBackground"];
    [self.view addSubview:imgView];
    //添加统计视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-49)/3, kScreenWidth, (kScreenHeight-49)/3)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    _scrollView = scrollView;
    //设置内容视图
    CGFloat contentWidth = 10+50*_dataArray.count;
    TrendView *tv = [[TrendView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, scrollView.bounds.size.height)];
    _tv = tv;
    tv.modelArray = _dataArray;
    [scrollView addSubview:tv];
    scrollView.contentSize = CGSizeMake(tv.bounds.size.width, tv.bounds.size.height);
    scrollView.contentSize = CGSizeZero;
    [self.view addSubview:scrollView];
    
    //设置下部统计数据视图
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight-49)/3*2, kScreenWidth, (kScreenHeight-49)/3)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 3;
    //设置步行距离
    NSNumber *totalDistance = [_dataArray valueForKeyPath:@"@sum.distance"];
    NSDictionary *attrDict1 = @{NSForegroundColorAttributeName:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSDictionary *attrDict2 = @{NSForegroundColorAttributeName:kMainColor, NSFontAttributeName:[UIFont systemFontOfSize:30]};
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"目前您一共步行了\n" attributes:attrDict1];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f公里\n", totalDistance.floatValue/1000] attributes:attrDict2];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"请继续努力!" attributes:attrDict1];
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] init];
    [totalStr appendAttributedString:str1];
    [totalStr appendAttributedString:str2];
    [totalStr appendAttributedString:str3];
    _label.attributedText = totalStr;
    [self.view addSubview:_label];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentDate"])
    {
        _dataArray = [_dbManager getAllData];
        //更新统计视图
        CGFloat contentWidth = 10+50*_dataArray.count;
        _tv.frame = CGRectMake(0, 0, contentWidth, _scrollView.bounds.size.height);
        _tv.modelArray = _dataArray;
        [_tv setNeedsDisplay];
        //设置步行距离
        NSNumber *totalDistance = [_dataArray valueForKeyPath:@"@sum.distance"];
        NSDictionary *attrDict1 = @{NSForegroundColorAttributeName:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSDictionary *attrDict2 = @{NSForegroundColorAttributeName:kMainColor, NSFontAttributeName:[UIFont systemFontOfSize:30]};
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"目前您一共步行了\n" attributes:attrDict1];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f公里\n", totalDistance.floatValue/1000] attributes:attrDict2];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"请继续努力!" attributes:attrDict1];
        NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] init];
        [totalStr appendAttributedString:str1];
        [totalStr appendAttributedString:str2];
        [totalStr appendAttributedString:str3];
        _label.attributedText = totalStr;
    }
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
