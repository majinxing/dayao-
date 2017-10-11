//
//  OfficeViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "OfficeViewController.h"
#import "DYHeader.h"
#import "OfficeTableViewCell.h"
#import "AllTheMeetingViewController.h"
#import "NoticeViewController.h"
#import "GroupListViewController.h"

@interface OfficeViewController ()<UITableViewDelegate,UITableViewDataSource,OfficeTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation OfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableView];
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
    self.title = @"办公";
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark OfficeTableViewCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)str{
    if ([str isEqualToString:Meeting]) {
        self.hidesBottomBarWhenPushed = YES;
        AllTheMeetingViewController * s = [[AllTheMeetingViewController alloc] init];
        [self.navigationController pushViewController:s animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Announcement]){
        NoticeViewController * noticeVC = [[NoticeViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Group]){
        GroupListViewController * g = [[GroupListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:g animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        [UIUtils showInfoMessage:@"未完待续"];
    }
}
-(void)signBtnPressedDelegate:(UIButton *)btn{
    [UIUtils dailyCheck];
    [_tableView reloadData];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfficeTableViewCell * cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OfficeTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OfficeTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell signState];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"OfficeTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OfficeTableViewCell" owner:self options:nil] objectAtIndex:1];
            [cell addSecondContentView];
        }
        
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 160;
    }
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 20)];
        view.backgroundColor = RGBA_COLOR(236, 236, 236, 1);
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 20)];
        l.text = @"签到";
        l.font = [UIFont systemFontOfSize:14];
        [view addSubview:l];
        return view;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 20)];
        view.backgroundColor = RGBA_COLOR(236, 236, 236, 1);
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 20)];
        l.text = @"办公";
        l.font = [UIFont systemFontOfSize:14];
        [view addSubview:l];
        return view;

    }
    return nil;
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
