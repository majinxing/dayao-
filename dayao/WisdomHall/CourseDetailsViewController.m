//
//  CourseDetailsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "ClassManagementViewController.h"
#import "InteractiveView.h"
#import "DYHeader.h"
#import "ShareView.h"
#import "TextViewController.h"
#import "SignListViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "ConversationVC.h"
#import "DiscussViewController.h"
#import "VoteViewController.h"
#import "DataDownloadViewController.h"
#import "SignPeople.h"
#import "AFHTTPSessionManager.h"


@interface CourseDetailsViewController ()<UIActionSheetDelegate,ShareViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *interactive;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (nonatomic,strong) InteractiveView * interactiveView;
@property (nonatomic,strong) ShareView * shareView;
@property (nonatomic,strong) ShareView * interaction;

@property (strong, nonatomic, readonly) EMCallSession *callSession;
@property (strong, nonatomic) IBOutlet UILabel *className;

@property (strong, nonatomic) IBOutlet UILabel *classTime;
@property (strong, nonatomic) IBOutlet UILabel *classPlace;

@property (strong, nonatomic) IBOutlet UILabel *classTeacherName;
@property (strong, nonatomic) IBOutlet UILabel *classSign;

@property (strong, nonatomic) IBOutlet UIButton *classManage;
@property (strong, nonatomic) IBOutlet UILabel *classId;


@property (strong, nonatomic)UserModel * user;
@property (strong, nonatomic) NSMutableArray * signAry;
@property (strong, nonatomic) NSMutableArray * notSignAry;

@property (nonatomic,assign)NSInteger n;//签到人数
@property (nonatomic,assign)NSInteger m;//未签到人数

@property (nonatomic,copy)NSString * selfSignStatus;
@property (nonatomic,assign)int temp;//记录mac不被覆盖
@end

@implementation CourseDetailsViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _signAry = [NSMutableArray arrayWithCapacity:1];
    _notSignAry = [NSMutableArray arrayWithCapacity:1];
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _n = 0;
    _m = 0;
    _temp = 0;
    
    [self setNavigationTitle];
    
    [self xib];
    
    [self getData];
    
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceCalls:) name:@"VoiceCalls" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)voiceCalls:(NSNotification *)dict{
    NSLog(@"%@",dict);
    NSLog(@"%s",__func__);
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
-(void)xib{
    _interactive.layer.masksToBounds = YES;
    _interactive.layer.borderWidth = 1;
    _interactive.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _signInBtn.layer.masksToBounds = YES;
    _signInBtn.layer.borderWidth = 1;
    _signInBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    
    _className.text = [NSString stringWithFormat:@"课程名：%@",_c.name];
    
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",_c.actStarTime];
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];
    
    _classTime.text = [NSString stringWithFormat:@"上课时间：%@",strUrl];
    
    _classPlace.text = [NSString stringWithFormat:@"上课地点：%@",_c.typeRoom];
    if ([UIUtils isBlankString:_c.teacherName]) {
        _classTeacherName.text = [NSString stringWithFormat:@"老  师："];
    }else{
        _classTeacherName.text = [NSString stringWithFormat:@"老  师：%@",_c.teacherName];
    }
    
    _classId.text = [NSString stringWithFormat:@"课程邀请码：%@",_c.sclassId];
    
    if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        [_classManage setTitle:@"班级管理" forState:UIControlStateNormal];
        _classManage.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
        [_classManage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        _classManage.enabled = NO;
    }
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"id",_c.courseDetailId,@"courseDetailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryCourseMemBer dict:dict succeed:^(id data) {
        //        NSLog(@"成功%@",data);
        NSArray *ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count;i++) {
            SignPeople * s = [[SignPeople alloc] init];
            [s setInfoWithDict:ary[i]];
            if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"1"]) {
                _m = _m + 1;
                [_notSignAry addObject:s];
            }else{
                _n = _n + 1;
            }
            if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",_user.peopleId]]) {
                if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"1"]) {
                    _selfSignStatus = @"签到状态：未签到";
                    _c.signStatus = @"1";
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"2"]){
                    _selfSignStatus = @"签到状态：已签到";
                    _c.signStatus = @"2";
                    [self signBtned];
                }
            }
            [_signAry addObject:s];
        }
        if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
            _classSign.text = [NSString stringWithFormat:@"签到人：%ld/%ld",(long)_n,(_m+_n)];
        }else{
            _classSign.text = _selfSignStatus;
        }
    } failure:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
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
    self.title = @"课程详情";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"删除课程" style:UIBarButtonItemStylePlain target:self action:@selector(delecateCourse)];
    
    if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        self.navigationItem.rightBarButtonItem = myButton;
    }
}
-(void)delecateCourse{
    if ([[NSString stringWithFormat:@"%@",_c.courseType] isEqualToString:@"1"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
        //分别按顺序放入每个按钮；
        [alert addAction:[UIAlertAction actionWithTitle:@"删除周期课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确定删除周期性课程" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alertView.delegate = self;
            alertView.tag = 1002;
            [alertView show];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"删除当前课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确定删除当前课程" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alertView.delegate = self;
            alertView.tag = 1003;
            [alertView show];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
    }else if([[NSString stringWithFormat:@"%@",_c.courseType] isEqualToString:@"2"]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确定删除临时性课程" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.delegate = self;
        alertView.tag = 1001;
        [alertView show];
    }
}
-(void)signSendIng{
    [_signInBtn setTitle:@"发送数据中" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_signInBtn setEnabled:NO];
}
-(void)signBtnSign{
    [_signInBtn setTitle:@"签到" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:RGBA_COLOR(10, 96, 254, 1) forState:UIControlStateNormal];
    [_signInBtn setEnabled:YES];
}
-(void)signBtned{
    [_signInBtn setTitle:@"已签到" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_signInBtn setEnabled:NO];
}

- (IBAction)signInBtnPressed:(id)sender {
    [self showHudInView:self.view hint:NSLocalizedString(@"正在签到", @"Load data...")];
    
    if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        
        SignListViewController * signListVC = [[SignListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        signListVC.signType = SignClassRoom;
        signListVC.ary = [NSMutableArray arrayWithCapacity:1];
        signListVC.ary = _notSignAry;
        [self.navigationController pushViewController:signListVC animated:YES];
        [self hideHud];
        return;
        
    }
    
    [self hideHud];
    
    if ([[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"2"]) {
        [UIUtils showInfoMessage:@"已签到"];
        return;
    }else{
        if (![UIUtils validateWithStartTime:_c.actStarTime withExpireTime:nil]) {
            [UIUtils showInfoMessage:@"课程开始之后一定时间范围内才可以签到"];
            return;
        }
    }
    
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dictWifi objectForKey:@"BSSID"]]]) {
        
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([UIUtils matchingMacWith:_c.mck withMac:bssid]) {
            _temp = 1;
            [self signSendIng];
            [self sendSignInfo];
            
        }else if (_temp == 1){
            
            [self signSendIng];
            [self sendSignInfo];
            
        }else{
            NSString * s =[UIUtils returnMac:_c.mck];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [self hideHud];
            [alertView show];
        }
        
    }else{
        NSString * s =[UIUtils returnMac:_c.mck];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [self hideHud];
        [alertView show];
    }
    
}
-(void)alter:(NSString *) str{
    [self hideHud];
    if ([str isEqualToString:@"1002"]) {
        [UIUtils showInfoMessage:@"暂不能签到"];
        [self signBtnSign];
    }else if ([str isEqualToString:@"1003"]){
        [UIUtils showInfoMessage:@"已签到"];
        [self signBtned];
    }else if ([str isEqualToString:@"1004"]){
        [UIUtils showInfoMessage:@"没有参加课程"];
        [self signBtnSign];
    }else if ([str isEqualToString:@"0000"]){
        
        [UIUtils showInfoMessage:@"签到成功"];
        [self signBtned];
        _c.signStatus = @"2";
        _selfSignStatus = @"签到状态：已签到";
        _classSign.text = @"签到状态：已签到";

        
        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //  _signNumber.text = @"签到状态：已签到";
    }else if ([str isEqualToString:@"5000"]){
        [UIUtils showInfoMessage:@"签到失败"];
        [self signBtnSign];

    }else if ([str isEqualToString:@"1016"]){
        [UIUtils showInfoMessage:@"暂不能签到"];
        [self signBtnSign];
    }
}

-(void)sendSignInfo{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"Id",_c.courseDetailId,@"courseDetailId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    [[NetworkRequest sharedInstance] POST:ClassSign dict:dict succeed:^(id data) {
        NSLog(@"succedd:%@",data);
        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        
    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"签到失败请重新签到，请保证数据流量的连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alter.tag = 2;
        [alter show];
        [self signBtnSign];
    }];
}

- (IBAction)interactiveBtnPressed:(id)sender {
    if (!_interaction)
    {
        _interaction = [[ShareView alloc] initWithFrame:self.navigationController.view.bounds withType:@"interaction"];
        _interaction.delegate = self;
    }
    [_interaction showInView:self.view];
}
- (IBAction)classManagementBtnPressed:(id)sender {
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    classManegeVC.manage = ClassManageType;
    classManegeVC.signAry = [NSMutableArray arrayWithCapacity:1];
    classManegeVC.signAry = _signAry;
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }else if(buttonIndex == 1){
            [alertView setHidden:YES];
        }
    }else if (alertView.tag == 2){
        if (buttonIndex == 0) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.courseDetailId,@"courseDetailId",_c.sclassId,@"id",@"2",@"courseType", nil];
            
            [[NetworkRequest sharedInstance] POST:DelecateCourse dict:dict succeed:^(id data) {
                NSString * s = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                if ([s isEqualToString:@"成功"]) {
                    // 2.创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
                    // 3.通过 通知中心 发送 通知
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [UIUtils showInfoMessage:@"课程删除失败"];
                }
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"课程删除失败"];
            }];
        }
    }else if (alertView.tag == 1002){
        if (buttonIndex == 1) {
            //点击按钮的响应事件；
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.courseDetailId,@"courseDetailId",_c.sclassId,@"id",@"1",@"courseType", nil];
            
            [[NetworkRequest sharedInstance] POST:DelecateCourse dict:dict succeed:^(id data) {
                NSString * s = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                if ([s isEqualToString:@"成功"]) {
                    // 2.创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
                    // 3.通过 通知中心 发送 通知
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [UIUtils showInfoMessage:@"课程删除失败"];
                }
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"课程删除失败"];
                
            }];
        }
    }else if (alertView.tag == 1003){
        if (buttonIndex == 1) {
            
            //点击按钮的响应事件；
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.courseDetailId,@"courseDetailId",@"1",@"courseType", nil];
            
            [[NetworkRequest sharedInstance] POST:DelecateCourse dict:dict succeed:^(id data) {
                NSString * s = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                if ([s isEqualToString:@"成功"]) {
                    // 2.创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
                    // 3.通过 通知中心 发送 通知
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [UIUtils showInfoMessage:@"课程删除失败"];
                }
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"课程删除失败"];
            }];
            
        }
    }
}

#pragma mark ShareViewDelegate

- (void)shareViewButtonClick:(NSString *)platform
{
    //    if (![platform isEqualToString:InteractionType_Responder]||![platform isEqualToString:InteractionType_Data]) {
    //        UIAlertView * later = [[UIAlertView alloc] initWithTitle:nil message:@"未完待续" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //        [later show];
    //        return;
    //    }
    
    if ([platform isEqualToString:InteractionType_Vote]){
        VoteViewController * v = [[VoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        v.classModel = _c;
        v.type = @"classModel";
        [self.navigationController pushViewController:v animated:YES];
        NSLog(@"投票");
    }else if ([platform isEqualToString:InteractionType_Data]){
        NSLog(@"资料");
        DataDownloadViewController * d = [[DataDownloadViewController alloc] init];
        d.classModel = _c;
        d.type = @"classModel";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }else if ([platform isEqualToString:InteractionType_Responder]){
        NSLog(@"抢答");
        ConversationVC * c =[[ConversationVC alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        UserModel * s = [[Appsetting sharedInstance] getUsetInfo];
        c.HyNumaber = [NSString stringWithFormat:@"%@%@",s.school,_c.teacherWorkNo];
        c.call = CALLING;
        c.teacherName = _c.teacherName;
        [self.navigationController pushViewController:c animated:YES];
    }else{
        UIAlertView * later = [[UIAlertView alloc] initWithTitle:nil message:@"未完待续" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [later show];
        return;
        
    }
    
    if ([platform isEqualToString:InteractionType_Test]){
        NSLog(@"测试");
        [_interaction hide];
        self.hidesBottomBarWhenPushed = YES;
        TextViewController * textVC = [[TextViewController alloc] init];
        [self.navigationController pushViewController:textVC animated:YES];
        
    }
    else if ([platform isEqualToString:InteractionType_Discuss]){
        DiscussViewController * d = [[DiscussViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:d animated:YES];
        NSLog(@"讨论");
    }
    else if ([platform isEqualToString:InteractionType_Test]){
        NSLog(@"测试");
    }
    else if ([platform isEqualToString:InteractionType_Add]){
        NSLog(@"更多");
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
