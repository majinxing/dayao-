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
#import "VoteModel.h"

@interface VoteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,strong)NSMutableArray * dataAry;
@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    [self getData];
    [self addTableView];
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_user.peopleId],@"createUser",[NSString stringWithFormat:@"%@",_meetModel.meetingId],@"relId",@"1",@"start",@"10000",@"length",nil];
    [[NetworkRequest sharedInstance] GET:QueryVote dict:dict succeed:^(id data) {
//        NSLog(@"%@",data);
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            VoteModel * v = [[VoteModel alloc] init];
            [v setInfo:ary[i]];
            [_dataAry addObject:v];
        }
        [_tableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)addTableView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.estimatedRowHeight = 70;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
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
    self.title = @"投票";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"新建投票" style:UIBarButtonItemStylePlain target:self action:@selector(createVote)];
    
    self.navigationItem.rightBarButtonItem = myButton;

}

-(void)createVote{
    CreateVoteViewController * c = [[CreateVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    c.meetModel = _meetModel;
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
    if (_dataAry.count>0) {
        return _dataAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteTableViewCell * cell = [_tableview dequeueReusableCellWithIdentifier:@"VoteTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    VoteModel * v = _dataAry[indexPath.row];
    
    [cell voteTitle:v.title withCreateTime:v.time withState:nil];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JoinVoteViewController * j = [[JoinVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    
    j.vote = _dataAry[indexPath.row];
    
    [self.navigationController pushViewController:j animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70;
//}
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
