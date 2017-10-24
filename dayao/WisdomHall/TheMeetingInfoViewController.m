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
#import "MeetingTableViewCell.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface TheMeetingInfoViewController ()<UINavigationControllerDelegate, UIVideoEditorControllerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MeetingTableViewCellDelegate>
@property (nonatomic,strong) ShareView * interaction;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)NSTimer * timeRun;
@property (nonatomic,strong)SeatIngModel * seatModel;
@property (nonatomic,assign)int mac;
@property (nonatomic,strong)UITableView * tableView;
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
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    // 1.注册通知
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSignNumber) name:@"SignSucceed" object:nil];
    
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
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
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

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeetingTableViewCell * cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell addFirstContentView:_meetingModel];
    }else if (indexPath.section == 1){
        if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellSecond"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:1];
            }
            [cell addSecondContentView:_meetingModel];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellThird"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:2];
            }
            [cell addThirdContentView:_meetingModel];
        }
        
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellFourth"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:3];
        }
        [cell addFourthContentView:_meetingModel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 150;
    }else if (indexPath.section ==1){
        return 60;
    }else if (indexPath.section == 2){
        return 200;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 25;
    }else if(section == 2){
        return 25;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = RGBA_COLOR(231, 231, 231, 1);
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 80, 20)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    if (section == 1) {
        label.text = @"签到";
    }else if(section == 2){
        label.text = @"互动";
    }
    return view;
}
#pragma mark MeetingCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)platform{
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
    }else if ([platform isEqualToString:InteractionType_Data]){
        NSLog(@"资料");
        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
        d.meeting = _meetingModel;
        d.type = @"meeting";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }else if ([platform isEqualToString:InteractionType_Discuss]){
        DiscussViewController * d = [[DiscussViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:d animated:YES];
        NSLog(@"讨论");
    }else if([platform isEqualToString:InteractionType_Sit]){
        if (![UIUtils isBlankString:_seatModel.seatTable]) {
            ZFSeatViewController * z = [[ZFSeatViewController alloc] init];
            z.seatTable = _seatModel.seatTable;
            z.seat = _meetingModel.userSeat;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:z animated:YES];
        }else{
            [UIUtils showInfoMessage:@"未获取会场信息，请刷新会场页面信息获取"];
        }
    }else {
        [UIUtils showInfoMessage:@"未完待续"];
        return;
    }
    
    
    //  else if ([platform isEqualToString:InteractionType_Responder]){
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
-(void)peopleManagementDelegate{
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    classManegeVC.manage = MeetingManageType;
    classManegeVC.meeting = _meetingModel;
    [self.navigationController pushViewController:classManegeVC animated:YES];
}
-(void)signNOPeopleDelegate{
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    signListVC.signType = SignMeeting;//签到类型
    signListVC.meetingModel = _meetingModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signListVC animated:YES];
}
-(void)signBtnPressedDelegate:(UIButton *)btn{
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    if (![UIUtils validateWithStartTime:_meetingModel.meetingTime withExpireTime:nil]) {
        [UIUtils showInfoMessage:@"会议开始之后一定时间范围内才可以签到"];
        [self hideHud];
        return;
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
            [self hideHud];
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
        [self hideHud];
    }
}
-(void)signSendIng{
    _meetingModel.signStatus = @"3";
    [_tableView reloadData];
}
-(void)sendSignInfo{
    
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"meetingId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    
    [[NetworkRequest sharedInstance] POST:MeetingSign dict:dict succeed:^(id data) {
        NSLog(@"succedd:%@",data);
        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        [self hideHud];

    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"签到失败请重新签到，请保证数据流量的连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alter.tag = 2;
        [alter show];
        [self hideHud];

    }];
}
-(void)alter:(NSString *) str{
    if ([str isEqualToString:@"1002"]) {
        [UIUtils showInfoMessage:@"暂时不能签到"];
        _meetingModel.signStatus = @"1";

    }else if ([str isEqualToString:@"1003"]){
        [UIUtils showInfoMessage:@"已签到"];
        _meetingModel.signStatus = @"2";
    }else if ([str isEqualToString:@"1004"]){
        [UIUtils showInfoMessage:@"未参加课程"];
        _meetingModel.signStatus = @"1";
    }else if ([str isEqualToString:@"0000"]){
        
        _meetingModel.signStatus = @"2";
        
        [UIUtils showInfoMessage:@"签到成功"];
        
        [_tableView reloadData];
        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if ([str isEqualToString:@"5000"]){
        [UIUtils showInfoMessage:@"签到失败"];
        _meetingModel.signStatus = @"1";
    }
    [_tableView reloadData];
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
