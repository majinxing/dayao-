//
//  AllTestViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AllTestViewController.h"
#import "DYHeader.h"
#import "TextsTableViewCell.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DYHeader.h"
#import "TextModel.h"
//#import "TextListViewController.h"
#import "CreateTestViewController.h"
#import "MJRefresh.h"
#import "ShareView.h"
#import "StudentSorce.h"
#import "StudentScoreViewController.h"

#import "AnswerTestQuestionsViewController.h"

#import "NewAnswerViewController.h"

#import "SelfAnswerViewController.h"

#import "TestCompletedViewController.h"

@interface AllTestViewController ()<UITableViewDelegate,UITableViewDataSource,TextsTableViewCellDelegate,ShareViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSMutableArray * dataAry;//数据源
@property (nonatomic,assign)int temp;//标志位防止数据重复
@property (nonatomic,strong)ShareView * vote;
@property (nonatomic,strong)TextModel * t;


@end

@implementation AllTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    [self getData];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)addTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    __weak AllTestViewController * weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf getData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        [weakSelf getData];
    }];
}

-(void)getData{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_classModel.sclassId,@"relId",@"1",@"relType",nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    [[NetworkRequest sharedInstance] GET:QueryTest dict:dict succeed:^(id data) {
        //        NSLog(@"%@",data);
        [_dataAry removeAllObjects];
        NSArray * ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count; i++) {
            TextModel * text = [[TextModel alloc] init];
            [text setSelfInfoWithDict:ary[i]];
            
            if ([text.title rangeOfString:@"【拍照问答】"].location!=NSNotFound) {
                //  [_dataAry addObject:text];
            }else if ([_typeText isEqualToString:@"HaveTest"]){
                if ([text.statusName isEqualToString:@"已完成"]) {
                    [_dataAry addObject:text];
                }
            }else{
                if (![text.statusName isEqualToString:@"已完成"]) {
                    [_dataAry addObject:text];
                }
            }
        }
        [_tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        
        [self hideHud];
        
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
    }];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)delectText:(TextModel *)t{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_t.textId,@"id", nil];
    [[NetworkRequest sharedInstance] POST:DelecateText dict:dict succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            [self getData];
        
        }else{
            [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
        }
        [_vote hide];

    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
        
    }];
}
-(void)closeText:(TextModel *)t{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_t.textId,@"id", nil];
    [[NetworkRequest sharedInstance] POST:CloseText dict:dict succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            [self delectText:nil];
        }else{
            [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
            [_vote hide];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
        
    }];
}
#pragma mark TextsTableViewCellDelegate
-(void)moreBtnPressedDelegate:(UIButton *)btn{
    if ([_typeText isEqualToString:@"HaveTest"]) {
        _t = _dataAry[btn.tag-1];
        [self alterDelectBtn];
    }else{
        _t = _dataAry[btn.tag - 1];
        
        if (!_vote)
        {
            _vote = [[ShareView alloc] initWithFrame:self.navigationController.view.bounds withType:@"text"];
            _vote.name = _t.title;

            _vote.delegate = self;
        }
        [_vote showInView:self.navigationController.view];
    }
}
-(void)alterDelectBtn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];

    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"删除测试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self closeText:nil];

    }]];
  
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark ShareDelegate
- (void)shareViewButtonClick:(NSString *)platform
{
    if ([platform isEqualToString:Vote_delecate]){
        
        [self closeText:nil];
        //
    }else if ([platform isEqualToString:Vote_Stop]){
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_t.textId,@"id",nil];
        
        [[NetworkRequest sharedInstance] POST:StopText dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"6676"]) {
                [UIUtils showInfoMessage:@"考试已结束" withVC:self];
            }else{
                [self getData];
            }
            [_vote hide];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
            
        }];
        
    }else if ([platform isEqualToString:Vote_Stare]){
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_t.textId,@"id",nil];
        [[NetworkRequest sharedInstance] POST:StartText dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"6676"]) {
                [UIUtils showInfoMessage:@"考试已结束" withVC:self];
            }else{
                [self getData];
            }
            [_vote hide];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
        }];
        
    }else if ([platform isEqualToString:Test_Scores_Query]){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_t.textId,@"id", nil];
        [[NetworkRequest sharedInstance] GET:QuertyTestScores dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
                NSArray * a = [data objectForKey:@"body"];
                for (int i = 0; i<a.count; i++) {
                    StudentSorce * s = [[StudentSorce alloc] init];
                    [s setSelfInfoWithDict:a[i]];
                    [ary addObject:s];
                }
                StudentScoreViewController * s = [[StudentScoreViewController alloc] init];
                s.ary = ary;
                self.hidesBottomBarWhenPushed = YES;
                [_vote hide];
                [self.navigationController pushViewController:s animated:YES];
            }else{
                [UIUtils showInfoMessage:@"暂无数据" withVC:self];
            }
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        }];
    }
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
    //TextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    TextsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TextsTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TextsTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    TextModel * t = _dataAry[indexPath.row];
    [cell addContentView:t withIndex:(int)indexPath.row+1];
    if (![[NSString stringWithFormat:@"%@",_classModel.teacherId] isEqualToString:[NSString stringWithFormat:@"%@",_userModel.peopleId]]) {
        cell.moreImage.image = [UIImage imageNamed:@""];
        [cell.moreBtn setEnabled:NO];
    }
    cell.delegate = self;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    TextModel * text = _dataAry[indexPath.row];
//    if ([text.statusName isEqualToString:@"进行中"]) {
//        NewAnswerViewController * vc= [[NewAnswerViewController alloc] init];
//        
//        vc.t = _dataAry[indexPath.row];
////        if ([vc.t.statusName isEqualToString:@"已完成"]) {
//            vc.isAbleAnswer = NO;
////        }else{
////            vc.isAbleAnswer = YES;
////        }
//        vc.editable = NO;
//        
//        vc.typeStr = @"测试";
//        
//        if ([vc.t.statusName isEqualToString:@"未进行"]) {
//            [UIUtils showInfoMessage:@"考试未进行，不能查看" withVC:self];
//        }else{
//            self.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else{
//        TestCompletedViewController * vc= [[TestCompletedViewController alloc] init];
//        
//        vc.t = _dataAry[indexPath.row];
//        if ([vc.t.statusName isEqualToString:@"已完成"]) {
//            vc.isAbleAnswer = NO;
//        }else{
//            vc.isAbleAnswer = YES;
//        }
//        vc.editable = NO;
//        
//        vc.titleStr = @"试题";
//        
//        if ([vc.t.statusName isEqualToString:@"未进行"]) {
//            [UIUtils showInfoMessage:@"考试未进行，不能查看" withVC:self];
//        }else{
//            self.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
