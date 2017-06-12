//
//  ChatHelper.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ChatHelper.h"
#import <Hyphenate/Hyphenate.h>

static ChatHelper *helper = nil;

@implementation ChatHelper
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatHelper alloc] init];
    });
    return helper;
}

//- (void)dealloc
//{
//    [[EMClient sharedClient] removeDelegate:self];
//    [[EMClient sharedClient].groupManager removeDelegate:self];
//    [[EMClient sharedClient].contactManager removeDelegate:self];
//    [[EMClient sharedClient].roomManager removeDelegate:self];
//    [[EMClient sharedClient].chatManager removeDelegate:self];
//}

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
    //注册代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

@end
