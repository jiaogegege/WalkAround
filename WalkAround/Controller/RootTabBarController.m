//
//  RootTabBarController.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/19.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "RootTabBarController.h"
#import "PrefixHeader.pch"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViewControllers];
}

-(void)createViewControllers
{
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    NSArray *titleArray = @[@"步行", @"趋势", @"记录"];
    NSArray *imgArray = @[@"home_Normal", @"trend_Normal", @"record_Normal"];
    NSArray *selImgArray = @[@"home_Active", @"trend_Active", @"record_Active"];
    NSArray *vcTitleArray = @[@"MainViewController", @"TrendViewController", @"MyInfoViewController"];
    for (int i = 0; i < vcTitleArray.count; ++i)
    {
        Class cl = NSClassFromString(vcTitleArray[i]);
        UIViewController *vc = [[cl alloc] init];
        if (i == 2)
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:[UIImage imageNamed:imgArray[i]] selectedImage:[UIImage imageNamed:selImgArray[i]]];
            nav.tabBarItem = item;
            [vcArray addObject:nav];
        }
        else
        {
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:[UIImage imageNamed:imgArray[i]] selectedImage:[UIImage imageNamed:selImgArray[i]]];
            vc.tabBarItem = item;
            [vcArray addObject:vc];
        }
    }
    self.viewControllers = vcArray;
    self.tabBar.tintColor = kMainColor;
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
