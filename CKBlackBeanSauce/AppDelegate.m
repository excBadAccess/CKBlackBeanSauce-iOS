//
//  AppDelegate.m
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#import "AppDelegate.h"

#import "FeaturedViewController.h"
#import "CategoryViewController.h"
#import "HotViewController.h"
#import "SearchViewController.h"
#import "MiscellaneousViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    
    // 创建精选界面的视图控制器
    FeaturedViewController *featured = [[FeaturedViewController alloc] init];
    // 精选界面的UINavigationController
    UINavigationController *navigation1 = [[UINavigationController alloc] initWithRootViewController:featured];
    navigation1.tabBarItem.title = @"电影";
    navigation1.tabBarItem.image = [UIImage imageNamed:@"recommendation.png"];
    [featured release];
    
    // 创建分类界面的视图控制器
    CategoryViewController *category = [[CategoryViewController alloc] init];
    // 分类界面的UINavigationController
    UINavigationController *navigation2 = [[UINavigationController alloc] initWithRootViewController:category];
    navigation2.tabBarItem.title = @"音乐";
    navigation2.tabBarItem.image = [UIImage imageNamed:@"category.png"];
    [category release];
    
    // 创建热门界面的视图控制器
    HotViewController *hot = [[HotViewController alloc] init];
    // 热门界面的UINavigationController
    UINavigationController *navigation3 = [[UINavigationController alloc] initWithRootViewController:hot];
    navigation3.tabBarItem.title = @"图书";
    navigation3.tabBarItem.image = [UIImage imageNamed:@"favorites.png"];
    [hot release];
    
    // 创建搜索界面的视图控制器
    SearchViewController *search = [[SearchViewController alloc] init];
    // 搜索界面的UINavigationController
    UINavigationController *navigation4 = [[UINavigationController alloc] initWithRootViewController:search];
    navigation4.tabBarItem.title = @"搜索";
    navigation4.tabBarItem.image = [UIImage imageNamed:@"order.png"];
    [search release];
    
    // 创建其他界面的视图控制器
    MiscellaneousViewController *misc = [[MiscellaneousViewController alloc] init];
    // 其他界面的UINavigationController
    UINavigationController *navigation5 = [[UINavigationController alloc] initWithRootViewController:misc];
    navigation5.tabBarItem.title = @"其他";
    navigation5.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
    [misc release];
    
    // 创建整体的UITabBarController
    UITabBarController *tabs = [[UITabBarController alloc] init];
    tabs.viewControllers = [NSArray arrayWithObjects:navigation1, navigation2, navigation3, navigation4, navigation5, nil];
    [navigation1 release];
    [navigation2 release];
    [navigation3 release];
    [navigation4 release];
    [navigation5 release];
    
    // 将tabs设为整个界面的主视图控制器
    self.window.rootViewController = tabs;
    [tabs release];
    
    // 开始显示主界面
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
