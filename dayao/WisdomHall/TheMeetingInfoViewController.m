//
//  TheMeetingInfoViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/20.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "DYHeader.h"
#import "ShareView.h"
#import "VoteViewController.h"
#import "ConversationVC.h"
#import "DiscussViewController.h"
#import "ClassManagementViewController.h"
#import "SignListViewController.h"
#import "DataDownloadViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "ZFSeatViewController.h"
#import "SeatIngModel.h"
#import "AFHTTPSessionManager.h"


#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface TheMeetingInfoViewController ()<ShareViewDelegate,UINavigationControllerDelegate, UIVideoEditorControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *meetingName;
@property (strong, nonatomic) IBOutlet UILabel *signNumber;
@property (strong, nonatomic) IBOutlet UILabel *meetingTime;
@property (strong, nonatomic) IBOutlet UILabel *meetingPlace;
@property (strong, nonatomic) IBOutlet UILabel *host;
@property (strong, nonatomic) IBOutlet UILabel *meetingId;


@property (strong, nonatomic) IBOutlet UIButton *interactiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *signBtn;

@property (strong, nonatomic) IBOutlet UIButton *seatBtn;
@property (nonatomic,strong) ShareView * interaction;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)NSTimer * timeRun;
@property (nonatomic,strong)SeatIngModel * seatModel;
@property (nonatomic,assign)int mac;
@end

@implementation TheMeetingInfoViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mac = 0;
    
    [self getData];
    
    [self addContentView];
    
    [self setNavigationTitle];
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSignNumber) name:@"SignSucceed" object:nil];
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceCalls:) name:@"VoiceCalls" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)voiceCalls:(NSNotification *)dict{
    EMCallSession * aSession = [dict.userInfo objectForKey:@"session"];
    ConversationVC * c  = [[ConversationVC alloc] init];
    c.callSession = aSession;
    int n = (int)[NSString stringWithFormat:@"%@",_user.school].length;
    NSMutableString * str = [NSMutableString stringWithFormat:@"%@",aSession.remoteName];
    [str deleteCharactersInRange:NSMakeRange(0,n)];
    c.teacherName = str;
    c.call = CALLED;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:c animated:YES];
    //    调用:
}
-(void)getData{
    
    
    [[NetworkRequest sharedInstance] GET:QueryMeetingRoom dict:nil succeed:^(id data) {
        //        NSLog(@"%@",data);
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            SeatIngModel * s = [[SeatIngModel alloc] init];
            [s setInfoWithDict:ary[i]];
            if ([[NSString stringWithFormat:@"%@",_meetingModel.meetingPlaceId] isEqualToString:s.seatTableId]) {
                _seatModel = s;
                return ;
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"meetingId", nil];
    [[NetworkRequest sharedInstance] GET:QueryMeetingPeople dict:dict succeed:^(id data) {
        //        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        
    }];
}
//更新签到数据
-(void)changeSignNumber{
    [self addContentView];
}

-(void)viewWillAppear:(BOOL)animated{
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"会议详情";
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"删除会议" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMeeting)];
        self.navigationItem.rightBarButtonItem = myButton;
    }
    
}
-(void)deleteMeeting{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"id", nil];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在提交数据", @"Load data...")];
    
    [[NetworkRequest sharedInstance] POST:MeetingDelect dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            // 2.创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController popViewControllerAnimated:YES];
            [self hideHud];
            
        }else{
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            [self hideHud];
        }
    } failure:^(NSError *error) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [self hideHud];
        
    }];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark View
-(void)addContentView{
    _meetingName.text = [NSString stringWithFormat:@"会议名称：%@",_meetingModel.meetingName];
    if ([UIUtils isBlankString:_meetingModel.meetingHost]) {
        _host.text = [NSString stringWithFormat:@"主  持  人："];
    }else{
        _host.text = [NSString stringWithFormat:@"主  持  人：%@",_meetingModel.meetingHost];
    }
    
    
    _meetingPlace.text = [NSString stringWithFormat:@"会议地点：%@",_meetingModel.meetingPlace];
    
    _meetingId.text = [NSString stringWithFormat:@"会议邀请码：%@",_meetingModel.meetingId];
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        _signNumber.text = [NSString stringWithFormat:@"签到人数：%ld/%ld",(long)_meetingModel.n,(long)_meetingModel.m];
        [_seatBtn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        [_seatBtn setTitle:@"人员管理" forState:UIControlStateNormal];
        _temp = 0;
    }else{
        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"1"]) {
            _signNumber.text = [NSString stringWithFormat:@"签到状态：未签到"];
        }else if([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]){
            _signNumber.text = [NSString stringWithFormat:@"签到状态：已签到"];
            [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [_signBtn setEnabled:NO];
            [_signBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",_meetingModel.userSeat]]) {
            [_seatBtn setTitle:[NSString stringWithFormat:@"座次：%@ （点击查看详情）",_meetingModel.userSeat] forState:UIControlStateNormal];
            
        }else{
            [_seatBtn setTitle:[NSString stringWithFormat:@"座次：暂未安排（点击查看详情）"] forState:UIControlStateNormal];
            
        }
        [_seatBtn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        
        //        [_seatBtn setEnabled: NO];
        _temp = 1;
    }
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",_meetingModel.meetingTime];
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];
    
    _meetingTime.text = [NSString stringWithFormat:@"会议时间：%@",strUrl];
    
    _interactiveBtn.layer.masksToBounds = YES;
    _interactiveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _interactiveBtn.layer.borderWidth = 1;
    
    _signBtn.layer.masksToBounds = YES;
    _signBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _signBtn.layer.borderWidth = 1;
    
    
}

- (IBAction)interactiveBtnPressed:(id)sender {
    if (!_interaction)
    {
        _interaction = [[ShareView alloc] initWithFrame:self.navigationController.view.bounds withType:@"meetingInteraction"];
        _interaction.delegate = self;
    }
    [_interaction showInView:self.view];
}
- (IBAction)signBtnPressed:(id)sender {
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        
        [self hideHud];
        
        SignListViewController * signListVC = [[SignListViewController alloc] init];
        signListVC.signType = SignMeeting;//签到类型
        signListVC.meetingModel = _meetingModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:signListVC animated:YES];
        
    }else{
        [self hideHud];

        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]) {
            
            [UIUtils showInfoMessage:@"已签到"];
            
            return;
            
        }else{
            if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
                [UIUtils showInfoMessage:@"会议开始之后一定时间范围内才可以签到"];
                
                return;
            }
        }
        
        
        NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
        
        if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
            
            
            NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
            
            if ([UIUtils matchingMacWith:_meetingModel.mck withMac:bssid]) {
                _mac = 1;
                
                [self signSendIng];

                [self sendSignInfo];
                
            }else if (_mac == 1){
                [self signSendIng];

                [self sendSignInfo];
            }else{
                
                NSString * s = [UIUtils returnMac:_meetingModel.mck];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
                alertView.delegate = self;
                alertView.tag = 1;
                [alertView show];
            }
            
        }else if (_mac == 1){
            
            [self signSendIng];
            [self sendSignInfo];
            
        }else{
            NSString * s = [UIUtils returnMac:_meetingModel.mck];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
        
    }
}
-(void)signSendIng{
    [_signBtn setTitle:@"发送数据中" forState:UIControlStateNormal];
    [_signBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_signBtn setEnabled:NO];
}
-(void)signBtnSign{
    [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [_signBtn setTitleColor:RGBA_COLOR(10, 96, 254, 1) forState:UIControlStateNormal];
    [_signBtn setEnabled:YES];
}
-(void)alter:(NSString *) str{
    if ([str isEqualToString:@"1002"]) {
        [UIUtils showInfoMessage:@"暂时不能签到"];
        [self signBtnSign];
    }else if ([str isEqualToString:@"1003"]){
        
        [UIUtils showInfoMessage:@"已签到"];
        _signNumber.text = @"签到状态：已签到";
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        _signBtn.backgroundColor = [UIColor clearColor];
        [_signBtn setEnabled:NO];
        
    }else if ([str isEqualToString:@"1004"]){
        [UIUtils showInfoMessage:@"未参加课程"];
        [self signBtnSign];
    }else if ([str isEqualToString:@"0000"]){
        
        
        _signNumber.text = @"签到状态：已签到";
        _meetingModel.signStatus = @"2";
        
        [UIUtils showInfoMessage:@"签到成功"];
        
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        _signBtn.backgroundColor = [UIColor clearColor];
        [_signBtn setEnabled:NO];
        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([str isEqualToString:@"5000"]){
        [UIUtils showInfoMessage:@"签到失败"];
        [self signBtnSign];
    }
}
- (IBAction)personnelManagement:(id)sender {
    if (_temp == 0) {
        ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        classManegeVC.manage = MeetingManageType;
        classManegeVC.meeting = _meetingModel;
        [self.navigationController pushViewController:classManegeVC animated:YES];
        
    }else{
        ZFSeatViewController * z = [[ZFSeatViewController alloc] init];
        z.seatTable = _seatModel.seatTable;
        z.seat = _meetingModel.userSeat;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:z animated:YES];
    }
    
}

-(void)sendSignInfo{
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"meetingId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    
    [[NetworkRequest sharedInstance] POST:MeetingSign dict:dict succeed:^(id data) {
        NSLog(@"succedd:%@",data);
        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        
    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"签到失败请重新签到，请保证数据流量的连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alter.tag = 2;
        [alter show];
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
        [_signBtn setTitleColor:RGBA_COLOR(10, 96, 254, 1) forState:UIControlStateNormal];
        [_signBtn setEnabled:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ALter
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            
            [[UIApplication sharedApplication] openURL:url];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }else if(buttonIndex == 1){
            [alertView setHidden:YES];
        }
        
    }else if (alertView.tag == 2){
        
        if (buttonIndex == 0) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


#pragma mark ShareViewDelegate

- (void)shareViewButtonClick:(NSString *)platform
{
    if ([platform isEqualToString:InteractionType_Responder]){
        NSLog(@"抢答");
        if (_meetingModel.workNo.length>0) {
            
            ConversationVC * c =[[ConversationVC alloc] init];
            
            c.HyNumaber = [NSString stringWithFormat:@"%@%@",_user.school,_meetingModel.workNo];
            
            c.call = CALLING;
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:c animated:YES];
            
        }else{
            [UIUtils showInfoMessage:@"不能呼叫自己"];
        }
        
    }else if ([platform isEqualToString:InteractionType_Vote]){
        VoteViewController * v = [[VoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        v.meetModel = _meetingModel;
        v.type = @"meeting";
        [self.navigationController pushViewController:v animated:YES];
        NSLog(@"投票");
    }
    else if ([platform isEqualToString:InteractionType_Data]){
        NSLog(@"资料");
        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
        d.meeting = _meetingModel;
        d.type = @"meeting";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }else {
        [UIUtils showInfoMessage:@"未完待续"];
        return;
    }
    
    //    if ([platform isEqualToString:InteractionType_Discuss]){
    //        DiscussViewController * d = [[DiscussViewController alloc] init];
    //        self.hidesBottomBarWhenPushed = YES;
    //
    //        [self.navigationController pushViewController:d animated:YES];
    //        NSLog(@"讨论");
    //    }else if ([platform isEqualToString:InteractionType_Responder]){
    //        NSLog(@"抢答");
    //        if (_meetingModel.workNo.length>0) {
    //
    //            ConversationVC * c =[[ConversationVC alloc] init];
    //            c.HyNumaber = [NSString stringWithFormat:@"%@%@",_user.school,_meetingModel.workNo];
    //            c.call = CALLING;
    //            self.hidesBottomBarWhenPushed = YES;
    //            [self.navigationController pushViewController:c animated:YES];
    //
    //        }else{
    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能呼叫自己" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //            [alertView show];
    //        }
    //
    //    }
    //    else if ([platform isEqualToString:InteractionType_Test]){
    //        NSLog(@"测试");
    //    }
    //    else if ([platform isEqualToString:InteractionType_Add]){
    //        NSLog(@"更多");
    //    }else if ([platform isEqualToString:InteractionType_Data]){
    //        NSLog(@"资料");
    //        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
    //        d.meeting = _meetingModel;
    //        d.type = @"meeting";
    //        self.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController: d animated:YES];
    //    }
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
