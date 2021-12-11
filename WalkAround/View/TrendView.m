//
//  TrendView.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/21.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "TrendView.h"
#import "PrefixHeader.pch"

@implementation TrendView
{
    CGFloat _width;
    CGFloat _height;
    NSNumber *_maxSteps;
    NSMutableArray *_pointArray;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor whiteColor];
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
    }
    return self;
}

-(void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    _maxSteps = [modelArray valueForKeyPath:@"@max.numberOfSteps"];
}

//绘制图形
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBottomLine];
    [self drawDateText:context];
    [self drawStepCount:context];
    [self drawLineBetweenPoint];
}

///绘制下部的线条
-(void)drawBottomLine
{
    UIBezierPath *bottomLine = [UIBezierPath bezierPath];
    //配置贝塞尔曲线参数
    [[UIColor colorWithWhite:0.7 alpha:1] setStroke];
    bottomLine.lineWidth = 1;
    [bottomLine moveToPoint:CGPointMake(0, _height-10)];
    [bottomLine addLineToPoint:CGPointMake(_width, _height-10)];
    [bottomLine stroke];
}

///绘制日期
-(void)drawDateText:(CGContextRef)context
{
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [[UIColor colorWithWhite:0.7 alpha:1] setStroke];
    NSDictionary *textAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:kMainColor};
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM.dd";
    for (int i = 0; i < self.modelArray.count; ++i)
    {
        StepDataModel *model = self.modelArray[i];
        NSString *date = [format stringFromDate:model.date];
        [date drawAtPoint:CGPointMake(5+i*50, _height-10) withAttributes:textAttr];
    }
}

///绘制步数圆点
-(void)drawStepCount:(CGContextRef)context
{
    _pointArray = [[NSMutableArray alloc] init];
    [kMainColor setFill];
    [kMainColor setStroke];
    CGFloat contentHeight = _height - 20;
    for (int i = 0; i < self.modelArray.count; ++i)
    {
        StepDataModel *model = self.modelArray[i];
        CGFloat yReduce = model.numberOfSteps.floatValue/_maxSteps.floatValue*contentHeight;
        CGPoint point = CGPointMake(10+50*i, _height-10-yReduce);
        [_pointArray addObject:[NSValue valueWithCGPoint:point]];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        //配置贝塞尔曲线参数
        path.lineWidth = 1;
        [path fill];
        //绘制步数文字
        CGContextSetTextDrawingMode(context, kCGTextFill);
        NSDictionary *textAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:kMainColor};
        NSString *stepText = model.numberOfSteps.stringValue;
        [stepText drawAtPoint:CGPointMake(15+50*i, _height-15-yReduce) withAttributes:textAttr];
    }
}

///绘制点的连接线
-(void)drawLineBetweenPoint
{
    if (_pointArray.count>0)
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        //配置贝塞尔曲线参数
        [kMainColor setStroke];
        path.lineWidth = 1;
        [path moveToPoint:[_pointArray [0] CGPointValue]];
        for (int i = 1; i < _pointArray.count; ++i)
        {
            [path addLineToPoint:[_pointArray [i] CGPointValue]];
        }
        [path stroke];
    }
}

@end
