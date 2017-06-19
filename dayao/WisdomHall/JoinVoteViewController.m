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

@interface JoinVoteViewController ()<UITableViewDelegate,UITableViewDataSource,JoinVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * voteAnswer;
@end

@implementation JoinVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _voteAnswer = [NSMutableArray arrayWithCapacity:4];
    
    [self edicateVoteModel];
    
    [self setNavigationTitle];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}

-(void)edicateVoteModel{
    _vote = [[VoteModel alloc] init];
    _vote.title = @"你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？";
    _vote.time = @"2016-23-2";
    _vote.describe = @"那些游戏是受小伙伴们喜爱的呢你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？";
    _vote.largestNumbe = @"3";
    [_vote.selectAry addObject:@"英雄联盟你最喜欢的游戏是什么？你最喜欢的游戏是什么？你最喜欢的游戏是什么？"];
    [_vote.selectAry addObject:@"剑灵"];
    [_vote.selectAry addObject:@"Dota"];
    [_vote.selectAry addObject:@"穿越火线"];
    [_vote.selectAry addObject:@"梦幻西游"];
    [_vote.selectAry addObject:@"魔兽世界"];

    
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
    
    return 2+_vote.selectAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinVoteTableViewCell * cell;
    if (indexPath.row<2) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellFirst"];
    }else{
        cell = [_tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellSecond"];
    }
    if (indexPath.row<2) {
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
    }else{
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
    }
    if (indexPath.row == 0) {
        [cell setTileOrdescribe:_vote.title withLableText:_vote.time];
    }else if (indexPath.row == 1){
        [cell setTileOrdescribe:_vote.describe withLableText:[NSString stringWithFormat:@"最多可以选%@项",_vote.largestNumbe]];
    }else{
        [cell setSelectText:_vote.selectAry[indexPath.row-2] withTag:(int)indexPath.row];
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
    NSLog(@"%s",__func__);
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
