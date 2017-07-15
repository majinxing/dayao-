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

@interface CourseDetailsViewController ()<InteractiveViewdDelegate,UIActionSheetDelegate,ShareViewDelegate>
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
@property (strong,nonatomic) NSMutableArray * signAry;
@property (nonatomic,strong)NSTimer * timeRun;

@end

@implementation CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signAry = [NSMutableArray arrayWithCapacity:1];
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
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _className.text = [NSString stringWithFormat:@"课程名：%@",_c.name];
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",_c.actStarTime];
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];
    _classTime.text = [NSString stringWithFormat:@"上课时间：%@",strUrl];
    _classPlace.text = [NSString stringWithFormat:@"上课地点：%@",_c.typeRoom];
    _classTeacherName.text = [NSString stringWithFormat:@"老  师：%@",_c.teacherName];
    
    
    if ([[NSString stringWithFormat:@"%@",_c.teacherId] isEqualToString:[NSString stringWithFormat:@"%@",_user.peopleId]]) {
        [_classManage setTitle:@"班级管理" forState:UIControlStateNormal];
    }
    [_classManage setTitle:@"班级管理" forState:UIControlStateNormal];
    _classManage.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"id",_c.courseDetailId,@"courseDetailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryCourseMemBer dict:dict succeed:^(id data) {
        NSLog(@"成功%@",data);
        NSArray *ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count;i++) {
            SignPeople * s = [[SignPeople alloc] init];
            [s setInfoWithDict:ary[i]];
            [_signAry addObject:s];
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
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
  //  [self.navigationController pushViewController:signListVC animated:YES];
    
    if ([[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"2"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else{
        if (![UIUtils validateWithStartTime:_c.actStarTime withExpireTime:nil]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"不在时间段内"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
//            return;
        }
        
    }
    NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
    
    if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
        
        
        NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
        
        if ([bssid isEqualToString:_c.mck]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已检测到WiFi，请连接网络数据以便签到"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 2;
            [alertView show];
            
        }else{
            NSString * s = [_c.mck substringWithRange:NSMakeRange(_c.mck.length-4, 4)];
            s = [NSString stringWithFormat:@"DAYAO_%@",s];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
            alertView.delegate = self;
            alertView.tag = 1;
            [alertView show];
        }
        
    }else{
        NSString * s = [_c.mck substringWithRange:NSMakeRange(_c.mck.length-4, 4)];
        s = [NSString stringWithFormat:@"DAYAO_%@",s];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请到WiFi列表连接指定WiFi:%@,再点击签到",s] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消", nil];
        alertView.delegate = self;
        alertView.tag = 1;
        [alertView show];
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
       // [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [alertView show];
        [_timeRun invalidate];
        _timeRun = nil;
      //  _signNumber.text = @"签到状态：已签到";
    }else if ([str isEqualToString:@"5000"]){
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alertView show];
    }else if ([str isEqualToString:@"1016"]){
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
    if ([platform isEqualToString:ShareType_Weixin_Friend])
    {
        NSLog(@"微信好友");
    }
    else if ([platform isEqualToString:ShareType_Weixin_Circle])
    {
        NSLog(@"朋友圈");
    }
    else if ([platform isEqualToString:ShareType_QQ_Friend])
    {
        NSLog(@"QQ好友");
    }
    else if ([platform isEqualToString:ShareType_QQ_Zone])
    {
        NSLog(@"QQ空间");
    }
    else if ([platform isEqualToString:ShareType_Weibo])
    {
        NSLog(@"新浪微博");
    }
    else if ([platform isEqualToString:ShareType_Email])
    {
        NSLog(@"Email");
    }
    else if ([platform isEqualToString:ShareType_Message])
    {
        NSLog(@"短信");
    }
    else if ([platform isEqualToString:ShareType_Copy])
    {
        NSLog(@"复制链接");
    }
    else if ([platform isEqualToString:InteractionType_Test]){
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
        c.HyNumaber = [NSString stringWithFormat:@"%@%@",s.school,_c.teacherId];
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
