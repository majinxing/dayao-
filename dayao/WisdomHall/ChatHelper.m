//
//  ChatHelper.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ChatHelper.h"
#import <Hyphenate/Hyphenate.h>
#import "ConversationVC.h"

static ChatHelper *helper = nil;

@interface ChatHelper ()<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

@end
@implementation ChatHelper
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatHelper alloc] init];
    });
    return helper;
}
- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}
- (void)initHelper
{
    [self Hyregistered];

    //注册代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}
-(void)Hyregistered{
    //环信注册
    EMOptions  * options = [EMOptions optionsWithAppkey:@"1161170505178076#college-sign"];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8004" password:@"111111"];
    if (error==nil) {
        NSLog(@"注册成功");
    }
    EMError *error2 = [[EMClient sharedClient] loginWithUsername:@"8002" password:@"111111"];
    if (!error2) {
        NSLog(@"登录成功");
    }
}
/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:aMessages,@"messageAry", nil];
    // 2.创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:dict];
    // 3.通过 通知中心 发送 通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
//    NSLog(@"%s",__func__);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertView show];
//    
}

-(void)callDidReceive:(EMCallSession *)aSession{
    
    NSLog(@"%s",__func__);
    ConversationVC * c  = [[ConversationVC alloc] init];
    c.callSession = aSession;
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:c];
    //    调用:
    EMError *error = nil;
}
@end
