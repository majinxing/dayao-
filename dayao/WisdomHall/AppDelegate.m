//
//  AppDelegate.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AppDelegate.h"
#import "DYTabBarViewController.h"
#import "TheLoginViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "ChatHelper.h"
#import "ConversationVC.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DYHeader.h"
#import "NoticeViewController.h"

@interface AppDelegate ()<EMCallManagerDelegate,EMChatManagerDelegate,EMChatroomManagerDelegate>
@property(nonatomic,strong)ChatHelper * chat;
@end

@implementation AppDelegate

-(void)dealloc{
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    if ([[Appsetting sharedInstance] isLogin]) {
        _chat = [[ChatHelper alloc] init];
        DYTabBarViewController * tab = [[DYTabBarViewController alloc] init];
        self.window.rootViewController = tab;
    }else{
        TheLoginViewController * loginVC = [[TheLoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    }

    // iOS8之后和之前应区别对待
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIUserNotificationTypeSound];
    }
//    //环信注册
//    EMOptions  * options = [EMOptions optionsWithAppkey:@"1161170505178076#college-sign"];
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8004" password:@"111111"];
//    if (error==nil) {
//        NSLog(@"注册成功");
//    }
//    EMError *error2 = [[EMClient sharedClient] loginWithUsername:@"8002" password:@"111111"];
//    if (!error2) {
//        NSLog(@"登录成功");
//    }
//    
//    //注册消息回调
//    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
//    
//    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    
//    [self getWifiName];
    
    return YES;
}
///*!
// @method
// @brief 接收到一条及以上非cmd消息
// */
//- (void)messagesDidReceive:(NSArray *)aMessages{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertView show];
//
//    NSLog(@"%s",__func__);
//}
///*!
// @method
// @brief 接收到一条及以上cmd消息
// */
//- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
//    NSLog(@"%s",__func__);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertView show];
//
//}
-(NSString *)getWifiName

{
    
    NSString *wifiName = nil;
    
    
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    
    
    if (!wifiInterfaces) {
        
        return nil;
        
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        
        
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            NSLog(@"network info -> %@", networkInfo);
            
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            
        }
        
    }
    
    
    
    CFRelease(wifiInterfaces);
    
    return wifiName;
    
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NoticeViewController * n = [[NoticeViewController alloc] init];
    _chat = [[ChatHelper alloc] init];
    n.backType = @"TabBar";
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:n];
    
        NSLog(@"%s",__func__);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    _chat.outOrIn = @"out";
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    _chat.outOrIn = @"In";
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
