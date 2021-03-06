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
#import "ConversationVC.h"
#import "VoteViewController.h"
#import "DataDownloadViewController.h"
#import "SignPeople.h"
#import "AFHTTPSessionManager.h"
#import "TestAllViewController.h"
#import "MeetingTableViewCell.h"
#import "QRCodeGenerateVC.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "QrCodeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZFSeatViewController.h"
#import "PhotoPromptBox.h"
#import "AlterView.h"
#import "AllOrPersonalDataViewController.h"
#import "HomeWorkViewController.h"
#import "PersonalUploadDataViewController.h"
#import "PictureQuizViewController.h"
#import "MessageListViewController.h"
#import "AskForLeaveViewController.h"

@interface CourseDetailsViewController ()<UIActionSheetDelegate,ShareViewDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,MeetingTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AlterViewDelegate>

@property (nonatomic,strong) InteractiveView * interactiveView;
@property (nonatomic,strong) ShareView * shareView;
@property (nonatomic,strong) ShareView * interaction;

@property (nonatomic,assign)BOOL isEnable;


@property (strong, nonatomic)UserModel * user;
@property (strong, nonatomic) NSMutableArray * signAry;
@property (strong, nonatomic) NSMutableArray * notSignAry;

@property (nonatomic,assign)NSInteger n;//签到人数
@property (nonatomic,assign)NSInteger m;//未签到人数


@property (nonatomic,copy)NSString * selfSignStatus;
@property (nonatomic,copy)NSString * seatNo;
@property (nonatomic,assign)int temp;//记录mac不被覆盖
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)PhotoPromptBox * photoView;
@property (nonatomic,copy)NSString * pictureType;//标明是问答还是签到照片
@property (nonatomic,strong)AlterView * alterView;
@property (nonatomic,strong) NSTimer * t;

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
    _isEnable = NO;
    
    [self setNavigationTitle];
    
    [self getData];
    
    [self addTableView];
  
    
    // Do any additional setup after loading the view from its nib.
}
-(void)voiceCalls:(NSNotification *)dict{
    
    //    调用:
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"id",_c.courseDetailId,@"courseDetailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryCourseMemBer dict:dict succeed:^(id data) {
        //        NSLog(@"成功%@",data);
        NSArray *ary = [data objectForKey:@"body"];
        
        [_c.signAry removeAllObjects];

        for (int i = 0; i<ary.count;i++) {
            SignPeople * s = [[SignPeople alloc] init];
            
            [s setInfoWithDict:ary[i]];
            
            [_c.signAry addObject:s];

            if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"1"]||[[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"3"]) {
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
                    _isEnable = YES;
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"3"]){
                    _selfSignStatus = @"签到状态：请假";
                    _c.signStatus = @"3";
                    _isEnable = NO;
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"4"]){
                    _selfSignStatus = @"签到状态：迟到";
                    _c.signStatus = @"4";
                    _isEnable = NO;
                }else if ([[NSString stringWithFormat:@"%@",s.signStatus] isEqualToString:@"5"]){
                    _selfSignStatus = @"签到状态：早退";
                    _c.signStatus = @"5";
                    _isEnable = NO;
                }
                _seatNo = [NSString stringWithFormat:@"%@",s.seat];
            }
            [_signAry addObject:s];
        }
//        if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
            _c.n = (int)_n;
            _c.m = (int)_m;
//        }
        [self hideHud];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"失败%@",error);
        [self hideHud];
    }];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
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

-(void)alter:(NSString *) str{
    [self hideHud];
    if ([str isEqualToString:@"1002"]) {
        [UIUtils showInfoMessage:@"暂不能签到" withVC:self];
        _c.signStatus = @"1";
    }else if ([str isEqualToString:@"1003"]){
        [UIUtils showInfoMessage:@"已签到" withVC:self];
        _c.signStatus = @"2";
    }else if ([str isEqualToString:@"1004"]){
        [UIUtils showInfoMessage:@"没有参加课程" withVC:self];
        _c.signStatus = @"1";
    }else if ([str isEqualToString:@"0000"]){
        
//        [UIUtils showInfoMessage:@"签到成功" withVC:self];
        _c.signStatus = @"2";
        _selfSignStatus = @"签到状态：已签到";
        [self signPictureUpdate];

        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //  _signNumber.text = @"签到状态：已签到";
    }else if ([str isEqualToString:@"5000"]){
        [UIUtils showInfoMessage:@"签到失败" withVC:self];
        _c.signStatus = @"1";
    }else if ([str isEqualToString:@"1016"]){
        [UIUtils showInfoMessage:@"暂不能签到" withVC:self];
        _c.signStatus = @"1";
    }else if ([str isEqualToString:@"1008"]){
        [UIUtils showInfoMessage:@"这台手机已经签到一次了，不能重复使用签到，谢谢" withVC:self];
        _c.signStatus =@"1";
    }else if ([str isEqualToString:@"9999"]){
        _c.signStatus = @"1";
        [UIUtils showInfoMessage:@"系统错误" withVC:self];
    }
    [_tableView reloadData];
}

- (IBAction)interactiveBtnPressed:(id)sender {
    if (!_interaction)
    {
        _interaction = [[ShareView alloc] initWithFrame:self.navigationController.view.bounds withType:@"interaction"];
        _interaction.delegate = self;
    }
    [_interaction showInView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ALter
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2){
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
                    [UIUtils showInfoMessage:@"课程删除失败" withVC:self];
                }
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"课程删除失败" withVC:self];
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
                    [UIUtils showInfoMessage:@"课程删除失败" withVC:self];
                }
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"课程删除失败" withVC:self];
                
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
                    [UIUtils showInfoMessage:@"课程删除失败" withVC:self];
                }
                
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"课程删除失败" withVC:self];
            }];
            
        }
    }
}
#pragma mark NSTimer
-(void)removeView{
    NSTimeInterval timeInterval = 3.0 ;
    
    _t = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                          target:self
                                        selector:@selector(handleMaxShowTimer:)
                                        userInfo:nil
                                         repeats:YES];;
}
//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    [_alterView removeFromSuperview];
    [_t invalidate];
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
        [cell addFirstCOntentViewWithClassModel:_c];
    }else if (indexPath.section == 1){
        if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_c.teacherId]]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellSecond"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:1];
            }
            [cell addSecondContentViewWithClassModel:_c];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellThird"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:2];
            }
            [cell addThirdContentViewWithClassModel:_c isEnable:_isEnable];
        }
        
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingTableViewCellFourth"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MeetingTableViewCell" owner:self options:nil] objectAtIndex:3];
        }
        [cell addFourthContentViewWithClassModel:_c];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 260;
    }else if (indexPath.section==1){
        return 60;
    }else if (indexPath.section==2){
        return 220;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark alterViewDelegate
-(void)alterViewDeleageRemove{
    [_alterView removeFromSuperview];
    [_t invalidate];
}
#pragma mark MeetingCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)platform{
    [_interaction hide];
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
    }else if ([platform isEqualToString:Leave]){
        AskForLeaveViewController * vc = [[AskForLeaveViewController alloc] init];
        vc.c = _c;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([platform isEqualToString:InteractionType_Test]){
        NSLog(@"测试");
        self.hidesBottomBarWhenPushed = YES;
        TestAllViewController * textVC = [[TestAllViewController alloc] init];
        textVC.classModel = _c;
        [self.navigationController pushViewController:textVC animated:YES];
    }else if ([platform isEqualToString:InteractionType_Discuss]){
        MessageListViewController * d = [[MessageListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        d.type = @"enableCreate";
        d.peopleAry = [NSMutableArray arrayWithArray:_c.signAry];
        [self.navigationController pushViewController:d animated:YES];
        
        NSLog(@"讨论");
    }else if ([platform isEqualToString:InteractionType_Picture]){
        PictureQuizViewController * d = [[PictureQuizViewController alloc] init];
        d.classModel = _c;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: d animated:YES];
    }else if ([platform isEqualToString:InteractionType_Sit]){
        [self getCourseRoomSeat];
    }else if ([platform isEqualToString:InteractionType_Homework]){
        HomeWorkViewController * vc = [[HomeWorkViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        vc.c = _c;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([platform isEqualToString:InteractionType_Add]){
        NSLog(@"更多");
    }
}
-(void)getCourseRoomSeat{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];

    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_c.courseDetailId],@"courseDetailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryRoomSeat dict:dict succeed:^(id data) {
//        NSLog(@"%@",data);
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            ZFSeatViewController * z = [[ZFSeatViewController alloc] init];
            z.seatTable = [NSString stringWithFormat:@"%@",[data objectForKey:@"body"]];
//            z.type = @"class";
            z.classModel = _c;
            z.seat = _seatNo;
            self.hidesBottomBarWhenPushed = YES;
            if (![UIUtils isBlankString:z.seatTable]) {
                [self.navigationController pushViewController:z animated:YES];
            }else{
                [UIUtils showInfoMessage:@"会场拉取失败，请稍微在操作" withVC:self];
            }

        }else{
            [UIUtils showInfoMessage:@"获取信息缺失请重新获取" withVC:self];
        }
        [self hideHud];

    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"请求失败，请检查网络" withVC:self];
        [self hideHud];

    }];
}
-(void)peopleManagementDelegate{
    ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    classManegeVC.manage = ClassManageType;
    classManegeVC.signAry = [NSMutableArray arrayWithCapacity:1];
    classManegeVC.signAry = _signAry;
    classManegeVC.isEnableOutGroup = @"no";
    [self.navigationController pushViewController:classManegeVC animated:YES];
}
-(void)signNOPeopleDelegate{
    SignListViewController * signListVC = [[SignListViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    signListVC.signType = SignClassRoom;
    signListVC.ary = [NSMutableArray arrayWithCapacity:1];
    signListVC.ary = _notSignAry;
    [self.navigationController pushViewController:signListVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([[NSString stringWithFormat:@"%@",_user.peopleId] isEqualToString:[NSString stringWithFormat:@"%@",_c.teacherId]]) {
        return;
    }
    if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
        return;
    }else{
        if (![[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"1"]) {
            return;
        }else{
            [self autoSign];
        }
    }
}
-(void)autoSign{
    if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
        
        return;
    }else{
        if (![[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"1"]) {
            return;
        }
    }
    
    _isEnable = YES;
    [_tableView reloadData];
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
            self.alterView = [[AlterView alloc] initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 100) withAlterStr:@"未连接上教室指定WiFi"];
            self.alterView.delegate = self;
            [self.view addSubview:self.alterView];
            [self removeView];
        }
    }else{
        self.alterView = [[AlterView alloc] initWithFrame:CGRectMake(20, 100, APPLICATION_WIDTH-40, 100) withAlterStr:@"未连接上教室指定WiFi"];
        self.alterView.delegate = self;
        [self.view addSubview:self.alterView];
        [self removeView];
    }
}
-(void)signBtnPressedDelegate:(UIButton *)btn{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
        if ([[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"2"]) {
            [UIUtils showInfoMessage:@"已签到" withVC:self];
        }else{
            [UIUtils showInfoMessage:@"课程开始之后一定时间范围内才可以签到" withVC:self];
        }
        [self hideHud];
        return;
    }else{
        if ([[NSString stringWithFormat:@"%@",_c.signStatus] isEqualToString:@"2"]) {
//            [UIUtils showInfoMessage:@"已签到"];

            [self hideHud];
            [self signPictureUpdate];
            return;
        }
    }
    _isEnable = YES;
    [_tableView reloadData];
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
            
        }else if ([UIUtils determineWifiAndtimeCorrect:_c.mck]){
            [self signSendIng];
            [self sendSignInfo];
        }else{

            [self hideHud];

            NSString * str = [NSString stringWithFormat:@"请到WiFi列表连接指定的DAYAO或XTU开头的WiFi，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，点击签到按钮若网络情况不好，请断开WiFi连接数据流量再次点击签到"];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];

            }];
            
            [alertC addAction:alertA];
            
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
    }else{
        NSString * str = [NSString stringWithFormat:@"请到WiFi列表连接指定的DAYAO或XTU开头的WiFi，若不能跳转请主动在WiFi页面连接无线信号再返回app进行签到，点击签到按钮若网络情况不好，请断开WiFi连接数据流量再次点击签到"];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            
        }];
        
        [alertC addAction:alertA];
        
        [self presentViewController:alertC animated:YES completion:nil];
        [self hideHud];
    }
}
-(void)signSendIng{
    _c.signStatus = @"300";
    [_tableView reloadData];
}
-(void)sendSignInfo{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_c.sclassId,@"Id",_c.courseDetailId,@"courseDetailId",_user.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
    [[NetworkRequest sharedInstance] POST:ClassSign dict:dict succeed:^(id data) {
        NSString *message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        
        _c.signStatus = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"status"]];
        
        _c.courseSignId = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"id"]];
        
        if (![_c.signStatus isEqualToString:@"1"]&&![UIUtils isBlankString:_c.signStatus]) {
            [self signPictureUpdate];
            // 2.创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            [UIUtils showInfoMessage:message withVC:self];
        }
        
        [self hideHud];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
      
        NSString * str = [NSString stringWithFormat:@"签到失败请重新签到，请保证数据流量的连接"];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            
        }];
        
        [alertC addAction:alertA];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        _c.signStatus = @"400";
        
        [_tableView reloadData];
    }];
}

-(void)codePressedDelegate:(UIButton *)btn{
    if ([_c.signStatus isEqualToString:@"1"]) {
        if (![UIUtils validateWithStartTime:_c.signStartTime withExpireTime:nil]) {
            [UIUtils showInfoMessage:@"课程开始之后一定时间范围内才可以签到" withVC:self];
            return;
        }
        //     1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                            [vc returnText:^(NSDictionary *returnText) {
                                if (returnText) {
                                    [self codeSign:returnText];
                                }
                            }];
                        });
                        // 用户第一次同意了访问相机权限
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        
                    } else {
                        // 用户第一次拒绝了访问相机权限
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
            } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
                SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                [vc returnText:^(NSDictionary *returnText) {
                    if (returnText) {
                        [self codeSign:returnText];
                    }
                }];
            } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"因为系统原因, 无法访问相册");
            }
        } else {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }else{
        NSMutableDictionary * dictWifi =  [UIUtils getWifiName];
        
        if (![UIUtils isBlankString:[dictWifi objectForKey:@"BSSID"]]) {
            NSString * bssid  = [UIUtils specificationMCKAddress:[dictWifi objectForKey:@"BSSID"]];
            if ([UIUtils matchingMacWith:_c.mck withMac:bssid]) {
                NSString * interval = [UIUtils getCurrentTime];
                NSString * checkcodeLocal = [NSString stringWithFormat:@"%@dayaokeji",interval];
                NSString * md5 = [self md5:checkcodeLocal];
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:interval,@"date",_c.mck,@"loc_array",md5,@"checkcode",nil];
                QrCodeViewController * q = [[QrCodeViewController alloc] init];
                q.mck = [[NSMutableArray alloc] initWithArray:_c.mck];
                self.hidesBottomBarWhenPushed = YES;
                q.dict = dict;
                [self.navigationController pushViewController:q animated:YES];
            }else{
                [UIUtils showInfoMessage:@"请在连接指定的DAYAO或XTU开头的WiFi下生成二维码" withVC:self];
            }
        }else{
            [UIUtils showInfoMessage:@"请在连接指定的DAYAO或XTU开头的WiFi下生成二维码" withVC:self];
        }
    }
}
-(void)codeSign:(NSDictionary *)dict{
    if (dict) {
        NSString * date = [dict objectForKey:@"date"];
        NSArray * loc_array = [dict objectForKey:@"loc_array"];
        NSString * checkcode = [[dict objectForKey:@"checkcode"] lowercaseString];
        NSString * dateTime = [UIUtils getTheTimeStamp:date];
        NSString * checkcodeLocal = [NSString stringWithFormat:@"%@dayaokeji",date];
        NSString * md5 = [self md5:checkcodeLocal];
        if ([md5 isEqualToString:checkcode]) {
            if ([UIUtils dateTimeDifferenceWithStartTime:dateTime withTime:CodeEffectiveTime]) {
                if ([UIUtils returnMckIsHave:_c.mck withAccept:loc_array]) {
                    [self sendSignInfo];
                }else{
                    [UIUtils showInfoMessage:@"二维码有误wifi匹配不对，请重新扫描或者连接指定WiFi签到" withVC:self];
                }
            }else{
                [UIUtils showInfoMessage:@"二维码失效，请重新扫描或者连接指定WiFi签到" withVC:self];
            }
        }else{
            [UIUtils showInfoMessage:@"二维码无效，请重新扫描或者连接指定WiFi签到" withVC:self];
        }
    }else{
        [UIUtils showInfoMessage:@"二维码无效，请重新扫描或者连接指定WiFi签到" withVC:self];
    }
    
}
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(void)signPictureUpdate{
    if (![[NSString stringWithFormat:@"%@",_c.signWay] isEqualToString:@"9"]) {
        [UIUtils showInfoMessage:@"已签到" withVC:self];
        return;
    }
    if (!_photoView) {
        _photoView = [[PhotoPromptBox alloc] initWithBlack:^(NSString * str) {
            [_photoView removeFromSuperview];
        } WithTakePictureBlack:^(NSString *str) {
            [self getPicture];
            [_photoView removeFromSuperview];
        }];
        _photoView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    }
    _pictureType = @"SignPicture";
    [self.view addSubview:_photoView];
}
-(void)getPicture{
    //实现button点事件的回调方法
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //    //分别按顺序放入每个按钮；
    //    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;

    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
        
    }];
    //    }]];
    
    //    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //        //照片的选取样式还有以下两种
    //        //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //        //UIImagePickerControllerSourceTypeCamera//调取摄像头
    //
    //        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    //        pickerController.delegate = self;
    //        //使用模态呈现相册
    //        [self.navigationController presentViewController:pickerController animated:YES completion:^{
    //
    //        }];
    //
    //    }]];
    //
    //
    //    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //        //点击按钮的响应事件；
    //    }]];
    //
    //    //弹出提示框；
    //    [self presentViewController:alert animated:true completion:nil];
    
}
//选择照片完成之后的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
        
        UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        //    NSString * filePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        NSString * str = [NSString stringWithFormat:@"%@-%@-%@",user.userName,user.studentId,[UIUtils getTime]];
        
        if ([_pictureType isEqualToString:@"QAPicture"]) {
            NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"6",@"function",[NSString stringWithFormat:@"%@",_c.sclassId],@"relId",@"false",@"deleteOld",nil];
            [[NetworkRequest sharedInstance] POSTImage:FileUpload image:resultImage dict:dict1 succeed:^(id data) {
                NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
                if ([code isEqualToString:@"0000"]) {
                    [UIUtils showInfoMessage:@"上传成功" withVC:self];
                }else{
                    [UIUtils showInfoMessage:@"上传失败" withVC:self];
                }
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"上传失败" withVC:self];
            }];
        }else if ([_pictureType isEqualToString:@"SignPicture"]){
            NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"10",@"function",[NSString stringWithFormat:@"%@",_c.courseDetailId],@"relId",@"ture",@"deleteOld",nil];
            UIImage * image = [UIUtils addWatemarkTextAfteriOS7_WithLogoImage:resultImage watemarkText:[NSString stringWithFormat:@"%@-%@-%@",_user.userName,_user.studentId,[UIUtils getTime]]];
            [[NetworkRequest sharedInstance] POSTImage:FileUpload image:image dict:dict1 succeed:^(id data) {
                NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
                if ([code isEqualToString:@"0000"]) {
                    [UIUtils showInfoMessage:@"上传成功" withVC:self];
                }else{
                    [UIUtils showInfoMessage:@"上传失败" withVC:self];
                }
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"上传失败" withVC:self];
            }];
        }
    });
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
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
