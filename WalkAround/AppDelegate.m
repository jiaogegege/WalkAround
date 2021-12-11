//
//  AppDelegate.m
//  WalkAround
//
//  Created by 蒋雪姣 on 16/1/15.
//  Copyright © 2016年 蒋雪姣. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "StepCountManager.h"
#import "RootTabBarController.h"
#import "DataBaseManager.h"

@interface AppDelegate ()
{
    CLLocationManager *_locationManager;
    StepCountManager *_stepManager;
    DataBaseManager *_dbManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //开启定位服务
//    [self locationBackgroundEnabled];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //创建数据库管理对象
    _dbManager = [DataBaseManager defaultManager];
    //启动单例类计步器
    _stepManager = [StepCountManager defaultManager];
    
    //设置视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    RootTabBarController *root = [[RootTabBarController alloc] init];
    self.window.rootViewController = root;
    
    return YES;
}

///申请后台定位
-(void)locationBackgroundEnabled
{
    //判断是否支持定位服务
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [_locationManager startUpdatingLocation];
        NSLog(@"开启定位成功");
    }
    else
    {
        NSLog(@"不支持定位服务");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"程序进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"程序进入前台");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"程序被激活");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"程序被kill");
}

@end
