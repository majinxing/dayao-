//
//  JoinVoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "JoinVoteViewController.h"
#import "DYHeader.h"
#import "JoinVoteTableViewCell.h"
#import "ResultsOfVoteViewController.h"
#import "VoteOption.h"

@interface JoinVoteViewController ()<UITableViewDelegate,UITableViewDataSource,JoinVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * voteAnswer;
@property (nonatomic,assign)int temp;//记录投票数目
//@property 
@end

@implementation JoinVoteViewController
-(void)dealloc{
        NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _voteAnswer = [NSMutableArray arrayWithCapacity:4];
    
    _temp = 0;
    
    [self getData];
    
//    [self edicateVoteModel];
    
    [self setNavigationTitle];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_vote.voteId,@"themeId",@"1",@"start",@"10000",@"length",nil];
    [[NetworkRequest sharedInstance] GET:QueryListOption dict:dict succeed:^(id data) {
        [_vote.selectAry removeAllObjects];
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            VoteOption * v = [[VoteOption alloc] init];
            [v setInfoWithDict:ary[i]];
            [_vote.selectAry addObject:v];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
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
    self.title = @"投票";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveVote)];
    self.navigationItem.rightBarButtonItem = myButton;
    //    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //    self.navigationItem.leftBarButtonItem = backbtn;
}
-(void)saveVote{

}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH,APPLICATION_HEIGHT-50-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}
- (IBAction)seeVoteResult:(id)sender {
    ResultsOfVoteViewController * r = [[ResultsOfVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:r animated:YES];
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
    if (_vote.selectAry.count>0) {
        return 1+_vote.selectAry.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinVoteTableViewCell * cell;
    if (indexPath.row == 0) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellFirst"];
    }else{
        cell = [_tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellSecond"];
    }
    if (indexPath.row==0) {
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
    }else{
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
    }
    if (indexPath.row == 0) {
        [cell setTileOrdescribe:[NSString stringWithFormat:@"%@(最多选%@票)",_vote.title,_vote.largestNumbe] withLableText:_vote.time];
    }else{
        VoteOption * v = _vote.selectAry[indexPath.row-1];
        [cell setSelectText:v.content withTag:(int)indexPath.row];
    }
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark JoinVoteTableViewCellDelegate
-(void)voteBtnDelegatePressed:(UIButton *)btn{
    
    if (btn.titleLabel.textColor == [UIColor blueColor]) {
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
