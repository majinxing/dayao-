//
//  SignListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SignListViewController.h"
#import "PersonalInfoTableViewCell.h"
#import "DYHeader.h"
@interface SignListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * ary;
@end

@implementation SignListViewController

-(void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    _ary = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i<10; i++) {
        [_ary setObject:[NSString stringWithFormat:@"掌声%d",i] atIndexedSubscript:i];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH,APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
    self.title = @"签到";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInfoTableViewCell * cell = [PersonalInfoTableViewCell tempTableViewCellWith:tableView indexPath:indexPath array:_ary];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){
        return 50;
    }else if (indexPath.section == 2){
        return 50;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
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
