//
//  AskForLeaveViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveViewController.h"
#import "AskForLeaveModel.h"
#import "AskForLeaveTableViewCell.h"
#import "AskForLeaveDetailsViewController.h"
#import "MJRefresh.h"

@interface AskForLeaveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataAry;
@end

@implementation AskForLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"请假列表";
    
    [self addTableView];
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
//    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_c.courseDetailId],@"detailId", nil];
    [[NetworkRequest sharedInstance] GET:QueryLeaveTeacher dict:dict succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        [_dataAry removeAllObjects];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++) {
                AskForLeaveModel * a = [[AskForLeaveModel alloc] init];
                [a setValueWithDict:ary[i]];
                [_dataAry addObject:a];
            }
            [_tableView reloadData];
        }else{
            [UIUtils showInfoMessage:str withVC:self];
        }
        [_tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"查询失败，请检查网络" withVC:self];
    }];
    
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewScrollPositionNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    [self.view addSubview:_tableView];
    __weak AskForLeaveViewController * weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf getData];
        
    }];
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
    return _dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AskForLeaveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AskForLeaveTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AskForLeaveTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    AskForLeaveModel * a = _dataAry[indexPath.row];
    
    [cell addContentView:a];
    cell.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AskForLeaveDetailsViewController * vc = [[AskForLeaveDetailsViewController alloc] init];
    vc.askModel =_dataAry[indexPath.row];
    vc.c = _c;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
