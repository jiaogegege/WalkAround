//
//  CalendarView.h
//  UI额外内容
//
//  Created by 蒋雪姣 on 15/12/29.
//  Copyright © 2015年 蒋雪姣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

@protocol CalendarViewDelegate <NSObject>

-(void)getDateByClickedButton:(NSDate *)date;

@end

@interface CalendarView : UIView
@property(nonatomic,weak)id<CalendarViewDelegate> delegate;

@end
