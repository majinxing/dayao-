//
//  MessageIMViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/31.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageViewControllerUserDelegate;

@class IGroup;

@protocol MessageListViewControllerGroupDelegate <NSObject>
//从本地获取群组信息
- (IGroup*)getGroup:(int64_t)gid;
//从服务器获取用户信息
- (void)asyncGetGroup:(int64_t)gid cb:(void(^)(IGroup*))cb;
@end

@interface MessageIMViewController : UIViewController
@property(nonatomic) NSString *deviceToken;

@property(nonatomic, assign) int64_t currentUID;

@property(nonatomic, weak) id<MessageViewControllerUserDelegate> userDelegate;
@property(nonatomic, weak) id<MessageListViewControllerGroupDelegate> groupDelegate;

@property(nonatomic,strong)NSString * type;

@property(nonatomic,strong)NSMutableArray * peopleAry;
@end
