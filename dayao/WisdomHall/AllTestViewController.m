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

@interface AllTestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSMutableArray * textArray;
@property (nonatomic,assign)int temp;//标志位防止数据重复
@end

@implementation AllTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textArray = [NSMutableArray arrayWithCapacity:4];

    [self querTextTableData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self querTextTableData];
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark FMDB
/**
 * 创建数据库
 **/
-(void)createDB{
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
}

//创建表
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"textId" : @"text",
                                                    @"title" : @"text",
                                                    @"type" : @"text",
                                                    @"indexPoint" : @"text",
                                                    @"timeLimit" : @"text",
                                                    @"textState" : @"text",
                                                    @"redo" :@"text",
                                                    @"totalScore":@"text",
                                                    @"totalNumber" : @"text",
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}
-(void)querTextTableData{
    [_textArray removeAllObjects];
    [self createDB];
    [self creatTextTable:TEXT_TABLE_NAME];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@",TEXT_TABLE_NAME];
        FMResultSet * rs = [FMDBTool queryWithDB:_db withSqlStr:sql];
        while (rs.next) {
            TextModel * t =[[TextModel alloc] init];
            t.title = [rs stringForColumn:@"title"];
            t.indexPoint = [rs stringForColumn:@"indexPoint"];
            t.textState = [rs stringForColumn:@"textState"];
            t.type = [rs stringForColumn:@"type"];
            t.textId = [rs stringForColumn:@"textId"];
            t.timeLimit = [rs stringForColumn:@"timeLimit"];
            t.totalScore = [rs stringForColumn:@"totalScore"];
            t.totalNumber = [rs stringForColumn:@"totalNumber"];
            t.redo = [rs stringForColumn:@"redo"];
            [_textArray addObject:t];
        }
    }
    [_db close];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_textArray.count>0) {
        return _textArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    TextsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TextsTableViewCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TextsTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextsTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextsTableViewCell"];
    }
    [cell addContentView:_textArray[indexPath.row]];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TextListViewController * listVC = [[TextListViewController alloc] init];
    listVC.t = _textArray[indexPath.row];
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
