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
@property (strong, nonatomic)UserModel * user;
@property (strong, nonatomic) NSMutableArray * signAry;
@property (strong, nonatomic) NSMutableArray * notSignAry;
@property (nonatomic,strong)NSTimer * timeRun;

@property (nonatomic,assign)NSInteger n;//签到人数
@property (nonatomic,assign)NSInteger m;//未签到人数

@property (nonatomic,copy)NSString * selfSignStatus;
@end

@implementation CourseDetailsViewController

-(void)dealloc{
    [_timeRun invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    _timeRun = nil;
}
-(void)viewWillDisappear:(BOOL)animated{
    [_timeRun invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _signAry = [NSMutableArray arrayWithCapacity:1];
    _notSignAry = [NSMutableArray arrayWithCapacity:1];
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _n = 0;
    _m = 0;
    [self setNavigationTitle];
    [self xib];
    [self getData];
    // Do any additional setup after loading the view from its nib.
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
    _classTeacherName.text = [NSString stringWithFormat:@"老  师：%@",_c.teacherName];
    
    
    if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        [_classManage setTitle:@"班级管理" forState:UIControlStateNormal];
        _classManage.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
        [_classManage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        _classManage.enabled = NO;
    }
    //    [_classManage setTitle:@"班级管理" forState:UIControlStateNormal];
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
                }
            }
            [_signAry addObject:s];
        }
        if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
            _classSign.text = [NSString stringWithFormat:@"签到人：%d/%d",_n,(_m+_n)];
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
- (IBAction)shareBtnPressed:(id)sender {
    if (!_shareView)
    {
        _shareView = [[ShareView alloc] initWithFrame:self.navigationController.view.bounds withType:@"share"];
        _shareView.delegate = self;
    }
    [_shareView showInView:self.navigationController.view];
    
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
    
    
    if ([[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"2"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [self hideHud];
        [alertView show];
        return;
    }else{
        if (![UIUtils validateWithStartTime:_c.actStarTime withExpireTime:nil]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"课程开始之后一定时间范围内才可以签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [self hideHud];
            [alertView show];
            return;
        }
        
    }
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dictWifi objectForKey:@"BSSID"]]]) {
        
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([bssid isEqualToString:_c.mck]) {
            [self hideHud];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已检测到WiFi，请连接网络数据以便签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 2;
            [alertView show];
            
        }else{
            NSString * s = [_c.mck substringWithRange:NSMakeRange(_c.mck.length-4, 4)];
            s = [NSString stringWithFormat:@"DAYAO_%@",s];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，签到完成之后请连接数据流量保证数据传输",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [self hideHud];
            [alertView show];
        }
        
    }else{
        NSString * s = [_c.mck substringWithRange:NSMakeRange(_c.mck.length-4, 4)];
        s = [NSString stringWithFormat:@"DAYAO_%@",s];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [self hideHud];
        [alertView show];
    }
    
}
-(void)alter:(NSString *) str{
    [self hideHud];
    if ([str isEqualToString:@"1002"]) {
        [self hideHud];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"现在还不能签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [_timeRun invalidate];
        _timeRun = nil;
        [alertView show];
    }else if ([str isEqualToString:@"1003"]){
        [self hideHud];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已经签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [_timeRun invalidate];
        _timeRun = nil;
        [alertView show];
    }else if ([str isEqualToString:@"1004"]){
        [self hideHud];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有参加课程" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_timeRun invalidate];
        _timeRun = nil;
    }else if ([str isEqualToString:@"0000"]){
        [self hideHud];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        _c.signStatus = @"2";
        _selfSignStatus = @"签到状态：已签到";
        _classSign.text = @"签到状态：已签到";
        [alertView show];
        [_timeRun invalidate];
        _timeRun = nil;
        
        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //  _signNumber.text = @"签到状态：已签到";
    }else if ([str isEqualToString:@"5000"]){
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alertView show];
    }else if ([str isEqualToString:@"1016"]){
        [self hideHud];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"进行中状态的课程不能进行签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [_timeRun invalidate];
        _timeRun = nil;
    }
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
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            [self showHudInView:self.view hint:NSLocalizedString(@"正在传送签到数据,请保证数据连接", @"Load data...")];

            //时间间隔
            NSTimeInterval timeInterval = 5.0 ;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _timeRun =  [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                             target:self
                                                           selector:@selector(handleMaxShowTimer:)
                                                           userInfo:nil
                                                            repeats:YES];
                
                [[NSRunLoop currentRunLoop] run];
            
            });
            
          
            
//            [_timeRun fire];
        }else if(buttonIndex == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"若没有网络数据连接将不能签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
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
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"课程删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
                
            } failure:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"课程删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
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
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"课程删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
                
            } failure:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"课程删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
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
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"课程删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                }
                
            } failure:^(NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"课程删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
            }];

        }
    }
}
-(void)handleMaxShowTimer:(NSTimer *)theTimer{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"Id",_c.courseDetailId,@"courseDetailId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    [[NetworkRequest sharedInstance] POST:ClassSign dict:dict succeed:^(id data) {
        NSLog(@"succedd:%@",data);
        [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        
    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
        
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
#pragma mark ShareViewDelegate

- (void)shareViewButtonClick:(NSString *)platform
{
    if (![platform isEqualToString:InteractionType_Responder]) {
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
    else if ([platform isEqualToString:InteractionType_Vote]){
        VoteViewController * v = [[VoteViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:v animated:YES];
        NSLog(@"投票");
    }
    else if ([platform isEqualToString:InteractionType_Responder]){
        NSLog(@"抢答");
        ConversationVC * c =[[ConversationVC alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        UserModel * s = [[Appsetting sharedInstance] getUsetInfo];
        c.HyNumaber = [NSString stringWithFormat:@"%@%@",s.school,_c.teacherWorkNo];
        c.call = CALLING;
        c.teacherName = _c.teacherName;
        [self.navigationController pushViewController:c animated:YES];
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
