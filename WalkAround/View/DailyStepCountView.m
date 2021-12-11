//
//  DailyStepCountView.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/20.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "DailyStepCountView.h"
#import "PrefixHeader.pch"
#import "StepCountManager.h"

@implementation DailyStepCountView

{
    CADisplayLink *_timer;
    CAGradientLayer *_gLayer;
    CAShapeLayer *_sLayer;
    UILabel *_countLabel;
    StepCountManager *_stepManager;
    //结束点
    CGFloat _endStroke;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {

    }
    return self;
}

-(void)setModel:(StepDataModel *)model
{
    _model = model;
    [self configUI];
}

///初始化界面Layer
-(void)configUI
{
    //获取单例管理类
    _stepManager = [StepCountManager defaultManager];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:self.bounds.size.width/3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    //轨道图层
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.path = path.CGPath;
    trackLayer.frame = self.bounds;
    trackLayer.lineWidth = 22;
    trackLayer.strokeColor = [UIColor whiteColor].CGColor;
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:trackLayer];
    
    //渐变图层
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.colors = @[(__bridge id) kMainColor.CGColor, (__bridge id)kMainColor.CGColor, (__bridge id)kMainColor.CGColor];
    gLayer.locations = @[@(0.2), @(0.4), @(0.8)];
    gLayer.startPoint = CGPointMake(0, 0);
    gLayer.endPoint = CGPointMake(0, 1);
    gLayer.frame = self.bounds;
    _gLayer = gLayer;
    [self.layer addSublayer:gLayer];
    
    UIBezierPath *stepPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:self.bounds.size.width/3 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    _sLayer = [CAShapeLayer layer];
    //遮罩图层
    _sLayer.path = stepPath.CGPath;
    _sLayer.frame = self.bounds;
    _sLayer.lineWidth = 22;
    _sLayer.strokeColor = [UIColor whiteColor].CGColor;
    _sLayer.fillColor = [UIColor clearColor].CGColor;
    _sLayer.lineCap = kCALineCapRound;
    _gLayer.mask = _sLayer;
    _sLayer.strokeEnd = 0;
    
    //添加圆圈中间的白色圆
    CAShapeLayer *middleLayer = [CAShapeLayer layer];
    UIBezierPath *middlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:self.bounds.size.width/3-20 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    middleLayer.path = middlePath.CGPath;
    middleLayer.frame = self.bounds;
    middleLayer.lineWidth = 0;
    middleLayer.strokeColor = [UIColor clearColor].CGColor;
    middleLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:middleLayer];
    
    //添加圆圈中间的文字UILabel，属性字符串
    //属性字符串
    NSDictionary *attrDict1 = @{NSForegroundColorAttributeName:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:15]};
    NSDictionary *attrDict2 = @{NSForegroundColorAttributeName:kMainColor, NSFontAttributeName:[UIFont systemFontOfSize:30]};
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"步数\n" attributes:attrDict1];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n", self.model.numberOfSteps.integerValue] attributes:attrDict2];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"目标%ld", _stepManager.target.integerValue] attributes:attrDict1];
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] init];
    [totalStr appendAttributedString:str1];
    [totalStr appendAttributedString:str2];
    [totalStr appendAttributedString:str3];
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.bounds.size.width/3-20)*2, (self.bounds.size.width/3-20)*2)];
    _countLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
    _countLabel.attributedText = totalStr;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.numberOfLines = 3;
    [self addSubview:_countLabel];
    
    
    CGFloat steps = [self.model.numberOfSteps floatValue];
    CGFloat strokeEndLine = steps/_stepManager.target.integerValue;
    _endStroke = strokeEndLine;

    //绘制圆弧
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkMethod)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)displayLinkMethod
{
    if (_sLayer.strokeEnd < _endStroke)
    {
        _sLayer.strokeEnd += 0.01;
    }
    else
    {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
