//
//  RunningViewController.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/19.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "RunningViewController.h"
#import "PrefixHeader.pch"

@interface RunningViewController ()

@end

@implementation RunningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
}

-(void)createUI
{
    self.view.backgroundColor = bgColor;
    
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
