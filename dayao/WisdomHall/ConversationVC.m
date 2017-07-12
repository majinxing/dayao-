//
//  ConversationVC.m
//  EMChatText
//
//  Created by zzjd on 2017/3/17.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import "ConversationVC.h"

#import <AVFoundation/AVFoundation.h>
#import "DYHeader.h"
#import "DYTabBarViewController.h"
#import "EMCallOptions+NSCoding.h"
@interface ConversationVC ()<EMCallManagerDelegate>

@property (nonatomic,strong)UIView * videoView;


@property (nonatomic,strong)UIButton * hangupBtn;
@property (nonatomic,strong)UIButton * receiveBtn;


@property (nonatomic,strong)UILabel * typeLab;

@end

@implementation ConversationVC

-(void)viewWillAppear:(BOOL)animated{
    
    if (!_callSession) {

//        视频之前，设置全局的音视频属性，具体属性有哪些请查看头文件 *EMCallOptions*
        
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
        
        options.isSendPushIfOffline = YES;
        
        [[EMClient sharedClient].callManager setCallOptions:options];
        

        NSString * string = ([[[EMClient sharedClient] currentUsername] isEqualToString:@"aaaaa111"])?@"aaaaa1111":@"aaaaa111";
        
        NSLog(@"currentUsername = %@  ,  string = %@",[[EMClient sharedClient] currentUsername],string);
        //15243670131"
        [[EMClient sharedClient].callManager startCall:EMCallTypeVoice remoteName:_HyNumaber ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
            
            NSLog(@"startCall : errorDescription = %@",aError.errorDescription);
            
            if (!aError) {
                _callSession = aCallSession;
                [self createUI];
            }else{
                if (self.navigationController.viewControllers.count>1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                }

            }
            
        }];
    }else{
        
        [self createUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];

    // Do any additional setup after loading the view.
}

-(void)createUI{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//休眠关闭

    if (!_hangupBtn) {
        _hangupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _hangupBtn.frame = CGRectMake(30, APPLICATION_HEIGHT-60, APPLICATION_WIDTH-60, 40);
        
        _hangupBtn.backgroundColor = [UIColor redColor];
        
        [_hangupBtn setTitle:@"hangup" forState:UIControlStateNormal];
        
        [_hangupBtn addTarget:self action:@selector(hangupBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_hangupBtn];
    }
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _receiveBtn.frame = CGRectMake(30, APPLICATION_HEIGHT-110, APPLICATION_WIDTH-60, 40);
        
        _receiveBtn.backgroundColor = [UIColor redColor];
        
        [_receiveBtn setTitle:@"receive" forState:UIControlStateNormal];
        
        [_receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_receiveBtn];
    }
    if (!_typeLab) {
        
        _typeLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 40)];
        
        _typeLab.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:_typeLab];
    }
    _typeLab.text = @"正在链接";
    _receiveBtn.hidden = _isSender;
    
    if (_type == 1) {
        
        //对方窗口
        _callSession.remoteVideoView = [[EMCallRemoteView alloc]initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        _callSession.remoteVideoView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_callSession.remoteVideoView];
        
        
        //自己窗口
        _callSession.localVideoView = [[EMCallLocalView alloc]initWithFrame:CGRectMake(APPLICATION_WIDTH-100, 64, 80, 120)];
        [self.view addSubview:_callSession.localVideoView];
        
    }
    [self.view bringSubviewToFront:_receiveBtn];
    [self.view bringSubviewToFront:_hangupBtn];
    
}

/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidConnect:(EMCallSession *)aSession{
    NSLog(@"callDidConnect 通话通道完成");
    if ([aSession.callId isEqualToString:_callSession.callId]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    
}

/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    
    NSLog(@"callDidAccept 同意通话");
    _typeLab.text = @"正在通话中";

    
}

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 */
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    
    NSLog(@"callDidEnd 通话结束 ：%@  reason = %u",aError.errorDescription,aReason);
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    
    _callSession = nil;
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }

    //[self.navigationController popViewControllerAnimated:YES];

}

/*!
 *  \~chinese
 *  用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aType     改变类型
 */
- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType{
    
    NSLog(@"callStateDidChange 用户A和用户B正在通话中，用户A中断或者继续数据流传输");

}



#pragma mark -------------------同意

-(void)receiveBtnClick:(UIButton *)btn{
    
    EMError * error = [[EMClient sharedClient].callManager answerIncomingCall:_callSession.callId];
    
    if (error) {
        
        NSLog(@"receiveBtnClick errorDescription = %@",error.errorDescription);
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonFailed];
    }else{
        btn.hidden = YES;
    }
    
}

#pragma mark -------------------挂断

-(void)hangupBtnClick{
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonDecline];
        _callSession = nil;
    }
    if (self.call == CALLING) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }
}



-(void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//休眠关闭
    [self hangupBtnClick];
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonHangup];
    }
    
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;
    
    
    //    [self stopSystemSound];
    
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
