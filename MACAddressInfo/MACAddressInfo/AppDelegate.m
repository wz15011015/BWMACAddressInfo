//
//  AppDelegate.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "BTSTabBarViewController.h"
#import "BTSAdViewController.h"
#import "CommonFile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadMainWindow];
    
    [self loadDatabase];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Window

/** 加载Window视图控制器 */
- (void)loadMainWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BTSAdViewController *rootVC = [[BTSAdViewController alloc] init];
     // 创建TabBar控制器
//    BTSTabBarViewController *rootVC = [[BTSTabBarViewController alloc] init];

    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

/** 切换至TabBar控制器 */
- (void)switchToTabBarController {
    // 创建TabBar控制器
    BTSTabBarViewController *tabBarVC = [[BTSTabBarViewController alloc] init];
    self.window.rootViewController = tabBarVC;
}


#pragma mark - Database

- (void)loadDatabase {
    if (BW_DATABASE_MODE_DEBUG) {
        [DatabaseManagerInstance createDatabase];
    } else {
        [DatabaseManagerInstance openDatabase];
    }
    
    /**
     * 串行队列
     *
     * 特点: 可以保证效率(会新建一个子线程),能够实现并发! (因为新建子线程是有开销的,所以不能无休止的新建线程.)
     * 使用串行队列的异步任务非常非常非常有用!!!
     * 应用场景: 从网络上下载图片,然后加滤镜处理
     */
    dispatch_queue_t queue = dispatch_queue_create("Queue_Database", DISPATCH_QUEUE_SERIAL);
    // 串行队列的异步任务
    dispatch_async(queue, ^{ // 异步任务,顺序执行,会在子线程上运行(会新建一个子线程) (异步任务,并发执行,但如果在串行队列中,仍然会依次顺序执行)
        [StatisticsManagerInstance top20Companys];
        [StatisticsManagerInstance countriesOfCompanyRank];
    });
}

@end
