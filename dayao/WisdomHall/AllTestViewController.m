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
#import "TextListViewController.h"
#import "CreateTestViewController.h"
#import "MJRefresh.h"

@interface AllTestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSMutableArray * dataAry;//数据源
@property (nonatomic,assign)int temp;//标志位防止数据重复
@end

@implementation AllTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    [self getData];
        
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
    self.title = @"测试";
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    if ([[NSString stringWithFormat:@"%@",_classModel.teacherId] isEqualToString:[NSString stringWithFormat:@"%@",_userModel.peopleId]]) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"创建测试" style:UIBarButtonItemStylePlain target:self action:@selector(createText)];
        self.navigationItem.rightBarButtonItem = myButton;
    }
    
}
-(void)createText{
    CreateTestViewController * c = [[CreateTestViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:c animated:YES];
}
-(void)addTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
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
    
    [[NetworkRequest sharedInstance] GET:QueryTest dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        [_dataAry removeAllObjects];
        NSArray * ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count; i++) {
            TextModel * text = [[TextModel alloc] init];
            [text setSelfInfoWithDict:ary[i]];
            [_dataAry addObject:text];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [UIUtils showInfoMessage:@"请求失败"];
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
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TextListViewController * listVC = [[TextListViewController alloc] init];
    listVC.t = _dataAry[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
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
