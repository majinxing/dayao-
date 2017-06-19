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

@interface CourseDetailsViewController ()<InteractiveViewdDelegate,UIActionSheetDelegate,ShareViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *interactive;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (nonatomic,strong) InteractiveView * interactiveView;
@property (nonatomic,strong) ShareView * shareView;
@property (nonatomic,strong) ShareView * interaction;

@property (strong, nonatomic, readonly) EMCallSession *callSession;
@end

@implementation CourseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self xib];
    // Do any additional setup after loading the view from its nib.
}
-(void)xib{
    _interactive.layer.masksToBounds = YES;
    _interactive.layer.borderWidth = 1;
    _interactive.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    _signInBtn.layer.masksToBounds = YES;
    _signInBtn.layer.borderWidth = 1;
    _signInBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
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
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"发起签到"
//                                  message:nil
//                                  delegate:self
//                                  cancelButtonTitle:nil
//                                  otherButtonTitles:nil];
//        [alertView show];
//    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-60, 300, 120, 30)];
//    // 设置提示内容
//    [tipLabel setText:@"发起签到"];
//    tipLabel.backgroundColor = [UIColor whiteColor];
//    tipLabel.layer.cornerRadius = 5;
//    tipLabel.layer.masksToBounds = YES;
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    tipLabel.textColor = [UIColor blackColor];
//    [self.view addSubview:tipLabel];
//    // 设置时间和动画效果
//    [UIView animateWithDuration:1.5 animations:^{
//        tipLabel.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        // 动画完毕从父视图移除
//        [tipLabel removeFromSuperview];
//    }];
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signListVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
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
        [self.navigationController pushViewController:c animated:YES];
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
