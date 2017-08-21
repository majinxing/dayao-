//
//  VoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteViewController.h"
#import "DYHeader.h"
#import "VoteTableViewCell.h"
#import "CreateVoteViewController.h"
#import "JoinVoteViewController.h"

@interface VoteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self addbutton];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}
-(void)addbutton{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(APPLICATION_WIDTH-60, APPLICATION_HEIGHT-60, 50, 50);
//    btn.backgroundColor = [UIColor greenColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createVote) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithHexString:@"#7FFFD4"];
    [self.view addSubview:btn];
}
-(void)createVote{
    CreateVoteViewController * c = [[CreateVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:c animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteTableViewCell * cell = [_tableview dequeueReusableCellWithIdentifier:@"VoteTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JoinVoteViewController * j = [[JoinVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:j animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
