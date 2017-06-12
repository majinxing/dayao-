//
//  ImportTextViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ImportTextViewController.h"
#import "contactTool.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DYHeader.h"
#import "Questions.h"
#import "QuestionsTableViewCell.h"
#import "ContactModel.h"

@interface ImportTextViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionsTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray * questionsAry;
@property (nonatomic,strong)NSMutableArray * selected;//是否被选中的状态
@property (nonatomic,strong)NSMutableArray * selectQuestiond;//已经选中的题，移除
@property (nonatomic,strong)FMDatabase * db;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation ImportTextViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addQuestion];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its vnib.
}
-(void)addQuestion{
    //整个的数据操作都是在本地数据库完成的
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    _questionsAry = [NSMutableArray arrayWithCapacity:4];
    
    _questionsAry = [contactTool returnQuestion:_db];
    
    _selected = [NSMutableArray arrayWithCapacity:4];
    
    _selectQuestiond = [NSMutableArray arrayWithCapacity:4];
    
    _selectQuestiond = [contactTool querContactTableData:_db withTextId:_t.textId];
    
    //把列表中已经被选中的题目移除
    
    for (int i = 0; i<_selectQuestiond.count; i++) {
        ContactModel * c = _selectQuestiond[i];
        for (int j = 0; j<_questionsAry.count; j++) {
            Questions * q = _questionsAry[j];
            if ([c.questionsID  isEqualToString:q.questionsID]) {
                [_questionsAry removeObjectAtIndex:j];
                break;
            }
        }
    }
    for (int i =0; i<_questionsAry.count; i++) {
        NSString * str = @"未选中";
        [_selected addObject:str];
    }
    
        NSLog(@"%s",__func__);
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
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
    self.title = @"试题";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"添加试题" style:UIBarButtonItemStylePlain target:self action:@selector(saveQuestion)];
    self.navigationItem.rightBarButtonItem = myButton;
    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backbtn;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveQuestion{
    for (int i = 0; i<_selected.count; i++) {
        if ([_selected[i] isEqualToString:@"选中"]) {
            Questions * q = _questionsAry[i];
            [self insertedIntoTextTable:_t.textId questionsID:q.questionsID qid:[NSString stringWithFormat:@"%ld",[_t.totalNumber integerValue]+1]];
            [_t changeTotalNumberWithTitle:q.score];
            _t.totalNumber = [NSString stringWithFormat:@"%ld",[_t.totalNumber integerValue]+1];
            _t.totalScore = [NSString stringWithFormat:@"%ld",[_t.totalScore integerValue]+[q.score integerValue]];
        }
    }
    [self back];
}
-(void)insertedIntoTextTable:(NSString *)textID questionsID:(NSString *)questionsID qid:(NSString *)qid{
    
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    [self creatTextTable:CONTACT_TABLE_NAME];
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (questionsID, textId,qid) values ('%@', '%@','%@')",CONTACT_TABLE_NAME,questionsID,textID,qid];
        BOOL rs = [FMDBTool insertWithDB:_db tableName:QUESTIONS_TABLE_NAME withSqlStr:sql];
        if (!rs) {
            NSLog(@"失败");
        }
    }
    [_db close];
}
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"questionsID" : @"text",
                                                    @"textId" : @"text",
                                                    @"qid" : @"text",
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------------------UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_questionsAry.count>0) {
        return _questionsAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionsTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"QuestionsTableViewCellSecond"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    cell.delegate = self;
    
    Questions * q = _questionsAry[indexPath.row];
    
    [cell setOptionsText:@"" WithOptionsText:q.title WithSelectState:_selected[indexPath.row] indexRow:(int)indexPath.row];
    
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
#pragma mark ---------------------QuestionsTableViewCellDelegate
-(void)selectBtnPressedDelegate:(UIButton *)btn{
    if ([_selected[btn.tag] isEqualToString:@"未选中"]) {
        _selected[btn.tag] = @"选中";
    }else{
        _selected[btn.tag] = @"未选中";
    }
    [_tableView reloadData];
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
