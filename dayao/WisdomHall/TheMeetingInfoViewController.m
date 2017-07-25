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

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface TheMeetingInfoViewController ()<ShareViewDelegate,UINavigationControllerDelegate, UIVideoEditorControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *meetingName;
@property (strong, nonatomic) IBOutlet UILabel *signNumber;
@property (strong, nonatomic) IBOutlet UILabel *meetingTime;
@property (strong, nonatomic) IBOutlet UILabel *meetingPlace;
@property (strong, nonatomic) IBOutlet UILabel *host;
@property (strong, nonatomic) IBOutlet UIButton *interactiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *signBtn;

@property (strong, nonatomic) IBOutlet UIButton *seatBtn;
@property (nonatomic,strong) ShareView * interaction;
@property (nonatomic,strong)UserModel * user;

@property (nonatomic,strong)NSTimer * timeRun;
@end

@implementation TheMeetingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [[Appsetting sharedInstance] getUsetInfo];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addContentView];
    
    [self setNavigationTitle];
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSignNumber) name:@"SignSucceed" object:nil];
    // Do any additional setup after loading the view from its nib.
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
    [[NetworkRequest sharedInstance] POST:MeetingDelect dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }
    } failure:^(NSError *error) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"删除会议失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addContentView{
    _meetingName.text = [NSString stringWithFormat:@"会议名称：%@",_meetingModel.meetingName];
    
    _host.text = [NSString stringWithFormat:@"主  持  人：%@",_meetingModel.meetingHost];
    
    _meetingPlace.text = [NSString stringWithFormat:@"会议地点：%@",_meetingModel.meetingPlace];
    
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        _signNumber.text = [NSString stringWithFormat:@"签到人数：%ld/%@",(long)_meetingModel.n,_meetingModel.meetingTotal];
        [_seatBtn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        [_seatBtn setTitle:@"人员管理" forState:UIControlStateNormal];
    }else{
        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"1"]) {
            _signNumber.text = [NSString stringWithFormat:@"签到状态：未签到"];
        }else if([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]){
            _signNumber.text = [NSString stringWithFormat:@"签到状态：已签到"];
        }
        [_seatBtn setTitle:[NSString stringWithFormat:@"座次：%@",_meetingModel.userSeat] forState:UIControlStateNormal];
        [_seatBtn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        [_seatBtn setEnabled: NO];
        
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
    
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        
        SignListViewController * signListVC = [[SignListViewController alloc] init];
        signListVC.signType = SignMeeting;//签到类型
        signListVC.meetingModel = _meetingModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:signListVC animated:YES];
        
    }else{
        
        if ([[NSString stringWithFormat:@"%@",_meetingModel.signStatus] isEqualToString:@"2"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }else{
            if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"不在时间段内"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            
        }
        NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
        
        if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
      
            
            NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
            
            if ([bssid isEqualToString:_meetingModel.mck]) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已检测到WiFi，请连接网络数据以便签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
                alertView.delegate = self;
                alertView.tag = 2;
                [alertView show];
                
            }else{
                NSString * s = [_meetingModel.mck substringWithRange:NSMakeRange(_meetingModel.mck.length-4, 4)];
                s = [NSString stringWithFormat:@"DAYAO_%@",s];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
                alertView.delegate = self;
                alertView.tag = 1;
                [alertView show];
            }
            
        }else{
            NSString * s = [_meetingModel.mck substringWithRange:NSMakeRange(_meetingModel.mck.length-4, 4)];
            s = [NSString stringWithFormat:@"DAYAO_%@",s];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
        
    }
}

-(void)alter:(NSString *) str{
    if ([str isEqualToString:@"1002"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"现在还不能签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [_timeRun invalidate];
        _timeRun = nil;
        [alertView show];
    }else if ([str isEqualToString:@"1003"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已经签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [_timeRun invalidate];
        _timeRun = nil;
        [alertView show];
    }else if ([str isEqualToString:@"1004"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有参加课程" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_timeRun invalidate];
        _timeRun = nil;
    }else if ([str isEqualToString:@"0000"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [alertView show];
        [_timeRun invalidate];
        _timeRun = nil;
        _signNumber.text = @"签到状态：已签到";
    }else if ([str isEqualToString:@"5000"]){
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alertView show];
    }
}
- (IBAction)personnelManagement:(id)sender {
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    classManegeVC.manage = MeetingManageType;
    classManegeVC.meeting = _meetingModel;
    [self.navigationController pushViewController:classManegeVC animated:YES];
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            //时间间隔
            NSTimeInterval timeInterval = 1.0 ;
            _timeRun =  [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                         target:self
                                                       selector:@selector(handleMaxShowTimer:)
                                                       userInfo:nil
                                                        repeats:YES];
            [_timeRun fire];
        }else if(buttonIndex == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"若没有网络数据连接将不能签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"meetingId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    [[NetworkRequest sharedInstance] POST:MeetingSign dict:dict succeed:^(id data) {
        NSLog(@"succedd:%@",data);
        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        
    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
    }];
}
#pragma mark ShareViewDelegate

- (void)shareViewButtonClick:(NSString *)platform
{
    if (![platform isEqualToString:InteractionType_Responder]) {
        UIAlertView * later = [[UIAlertView alloc] initWithTitle:nil message:@"未完待续" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [later show];
        return;
    }//mjx
    
    if ([platform isEqualToString:InteractionType_Discuss]){
        DiscussViewController * d = [[DiscussViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:d animated:YES];
        NSLog(@"讨论");
    }
    else if ([platform isEqualToString:InteractionType_Vote]){
        VoteViewController * v = [[VoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:v animated:YES];
        NSLog(@"投票");
    }
    else if ([platform isEqualToString:InteractionType_Responder]){
        NSLog(@"抢答");
        if (_meetingModel.workNo.length>0) {
            
            ConversationVC * c =[[ConversationVC alloc] init];
            c.HyNumaber = [NSString stringWithFormat:@"%@%@",_user.school,_meetingModel.workNo];
            c.call = CALLING;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:c animated:YES];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能呼叫自己" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    }
    else if ([platform isEqualToString:InteractionType_Test]){
        NSLog(@"测试");
    }
    else if ([platform isEqualToString:InteractionType_Add]){
        NSLog(@"更多");
    }else if ([platform isEqualToString:InteractionType_Data]){
        NSLog(@"资料");
        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }
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
