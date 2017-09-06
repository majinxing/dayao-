//
//  QuestionListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QuestionListViewController.h"
#import "DYHeader.h"
#import "Questions.h"
#import "JoinVoteTableViewCell.h"

@interface QuestionListViewController ()<UITableViewDelegate,UITableViewDataSource,JoinVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * selectAry;
@end

@implementation QuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    _selectAry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<_questionAry.count; i++) {
        [_selectAry addObject:@"未选中"];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
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
    if (_questionAry.count>0) {
        return _questionAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinVoteTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellSecond"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    Questions * q = _questionAry[indexPath.row];
    if (_isSelect) {
         [cell setSelectText:[NSString stringWithFormat:@"题目:%@",q.title] withTag:(int)indexPath.row+1 withSelect:_selectAry[indexPath.row]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"题目:%@",q.title];
    }
   
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
