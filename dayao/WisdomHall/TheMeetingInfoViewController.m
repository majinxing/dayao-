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

@interface TheMeetingInfoViewController ()<ShareViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *meetingName;
@property (strong, nonatomic) IBOutlet UILabel *signNumber;
@property (strong, nonatomic) IBOutlet UILabel *meetingTime;
@property (strong, nonatomic) IBOutlet UILabel *meetingPlace;
@property (strong, nonatomic) IBOutlet UILabel *host;
@property (strong, nonatomic) IBOutlet UIButton *interactiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *signBtn;

@property (nonatomic,strong) ShareView * interaction;

@end

@implementation TheMeetingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self addContentView];
    
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
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
    
    _signNumber.text = [NSString stringWithFormat:@"签到人数：%@/%@",_meetingModel.peopleNumber,_meetingModel.meetingTotal];
    
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
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    signListVC.signType = SignMeeting;//签到类型
    signListVC.meetingModel = _meetingModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signListVC animated:YES];

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
