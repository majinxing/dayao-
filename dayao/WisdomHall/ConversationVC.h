//
//  ConversationVC.h
//  EMChatText
//
//  Created by zzjd on 2017/3/17.
//  Copyright © 2017年 zzjd. All rights reserved.
//语音聊天界面

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>
#import "EMCallOptions+NSCoding.h"
@interface ConversationVC : UIViewController


@property (nonatomic,assign)NSInteger type;

@property (nonatomic,strong)EMCallSession *callSession;

@property (nonatomic,assign)BOOL isSender;


@end
