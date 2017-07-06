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
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface TheMeetingInfoViewController ()<ShareViewDelegate,UINavigationControllerDelegate, UIVideoEditorControllerDelegate>

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
@end

@implementation TheMeetingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addContentView{
    _meetingName.text = [NSString stringWithFormat:@"会议名称：%@",_meetingModel.meetingName];
    
    _host.text = [NSString stringWithFormat:@"主  持  人：%@",_meetingModel.meetingHost];
    
    _meetingPlace.text = [NSString stringWithFormat:@"会议地点：%@",_meetingModel.meetingPlace];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_meetingModel.meetingHostId]]) {
        _signNumber.text = [NSString stringWithFormat:@"签到人数：%ld/%@",_meetingModel.n,_meetingModel.meetingTotal];
        [_seatBtn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        [_seatBtn setTitle:@"人员管理" forState:UIControlStateNormal];
    }else{

        [_seatBtn setTitle:[NSString stringWithFormat:@"座次：%@",_meetingModel.userSeat] forState:UIControlStateNormal];
        [_seatBtn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
        [_seatBtn setEnabled: NO];

    }
    _meetingTime.text = [NSString stringWithFormat:@"会议时间：%@",_meetingModel.meetingTime];
    
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
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"meetingId",_user.peopleId,@"userId" ,idfv,@"mck",nil];
        [[NetworkRequest sharedInstance] POST:MeetingSign dict:dict succeed:^(id data) {
            NSLog(@"succedd:%@",data);
            [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
        } failure:^(NSError *error) {
            NSLog(@"失败：%@",error);
        }];
    }
}
-(void)alter:(NSString *) str{
    if ([str isEqualToString:@"1002"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"现在还不能签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else if ([str isEqualToString:@"1003"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已经签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else if ([str isEqualToString:@"1004"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有参加课程" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else if ([str isEqualToString:@"0000"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [alertView show];
    }else if ([str isEqualToString:@"5000"]){
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alertView show];
    }
}
- (IBAction)personnelManagement:(id)sender {
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    
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
