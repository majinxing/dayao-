//
//  TestQuestionsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
// 展示试卷内容的

#import "TestQuestionsViewController.h"
#import "DYHeader.h"
#import "CreateTextTableViewCell.h"
#import "Questions.h"
#import "UIUtils.h"
#import "contactTool.h"
#import "FMDBTool.h"
#import "FMDatabase.h"

@interface TestQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CreateTextTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary * labelTextDict;
@property (nonatomic,strong)Questions * q;
@property (nonatomic,strong)UIView * answerBack;
@property (nonatomic,strong)NSMutableArray * btnState;
@property (nonatomic,strong)NSArray * ary;
@property (nonatomic,strong)FMDatabase * db;
@end

@implementation TestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _answerBack = [[UIView alloc] init];
    _btnState = [NSMutableArray arrayWithCapacity:4];
    
    [self initBtnState];
    
    _ary = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"确定",nil];;
    
    _answerBack.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    _answerBack.backgroundColor = [UIColor clearColor];
    _labelTextDict = [[NSMutableDictionary alloc] init];
    _q = [[Questions alloc] init];
    [self setNavigationTitle];
    [self addTableView];
    [self keyboardNotification];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)initBtnState{
    [_btnState setObject:@"" atIndexedSubscript:0];
    [_btnState setObject:@"" atIndexedSubscript:1];
    [_btnState setObject:@"" atIndexedSubscript:2];
    [_btnState setObject:@"" atIndexedSubscript:3];
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 *  添加tableView
 **/
-(void)addTableView{
    NSArray * ary1 = [[NSArray alloc] initWithObjects:@"测试题目：",@"试题分值：",@"难易程度：",nil];
    NSArray * ary3 = [[NSArray alloc] initWithObjects:@"A:",@"B:",@"C:",@"D:",@"题目答案:", nil];
    [_labelTextDict setObject:ary1 forKey:@"0"];
    [_labelTextDict setObject:ary3 forKey:@"1"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent
                                                *)event{
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"试题";
}
-(void)theImportQuestionBtn{
    
}
//答案点击构造页面
-(void)addAnswerBackView{
    
    [self initBtnState];
    
    UIButton * backcolorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backcolorBtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    backcolorBtn.backgroundColor = [UIColor blackColor];
    backcolorBtn.alpha = 0.3;
    backcolorBtn.tag = 1;
    [backcolorBtn addTarget:self action:@selector(answerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_answerBack addSubview:backcolorBtn];
    for (int i = 0; i<5; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, 200+i*40, APPLICATION_WIDTH-60, 40);
        btn.tag = i+2;
        [btn addTarget:self action:@selector(answerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:[NSString stringWithFormat:@"%@",_ary[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_answerBack addSubview:btn];
    }
    [self.view addSubview:_answerBack];
}
-(void)answerBtnPressed:(UIButton *)btn{
    if (btn.tag != 6&&btn.tag!=1) {
        if (btn.backgroundColor == [UIColor whiteColor]) {
            btn.backgroundColor = [UIColor colorWithHexString:@"#00F5FF"];
            _btnState[btn.tag-2] = _ary[btn.tag-2];
        }else{
            _btnState[btn.tag-2] = @"";
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    else if(btn.tag == 6){
        [self questionAnswer:_btnState];
    }
    if (btn.tag == 1||btn.tag == 6) {
        [_answerBack removeFromSuperview];
    }
}
-(void)questionAnswer:(NSMutableArray*)ary{
    _q.answer = @"";
    for (int i = 0; i<ary.count; i++) {
        if (![UIUtils isBlankString:ary[i]]) {
            if ([UIUtils isBlankString:_q.answer]) {
                _q.answer = [NSString stringWithFormat:@"%@",ary[i]];
            }else
                _q.answer = [NSString stringWithFormat:@"%@,%@",_q.answer,ary[i]];
        }
    }
    if (_q.answer.length>1) {
        _q.multiSelect = @"多选";
    }else if(_q.answer.length == 1){
        _q.multiSelect = @"单选";
    }else{
        _q.multiSelect = @"";
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------------------------FMDB
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
#pragma mark ---------------------------UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 5;
    }else if (section == 2){
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateTextTableViewCell * cell;
    if (indexPath.section == 2) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateTextTableViewCellSecond"];
    }else{
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateTextTableViewCell"];
    }
    if (!cell)
    {
        if (indexPath.section == 2) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateTextTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateTextTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
    }
    cell.delegate = self;
    NSString * text = [_labelTextDict valueForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]][indexPath.row];
    [cell textLabelText:text];
    [cell textViewText:[_q returnQuestionAttribute:text]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 2) {
//        return 50;
//    }
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark ----------------------CreateTextTableViewCellDelegate
-(void)createTopicPressedDelegate{
    [self.view endEditing:YES];
    if (![_q whetherIsEmpty]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        [_q insertedIntoTextTable];
        
        [self insertedIntoTextTable:_t.textId questionsID:_q.questionsID qid:[NSString stringWithFormat:@"%d",[_t.totalNumber integerValue]+1]];
        
        [_t changeTotalNumberWithTitle:_q.score];
        
        _t.totalNumber = [NSString stringWithFormat:@"%ld",[_t.totalNumber integerValue]+1];
        _t.totalScore = [NSString stringWithFormat:@"%ld",[_t.totalScore integerValue]+[_q.score integerValue]];
        
        //重新加载页面
        [self initBtnState];
        _q = nil;
        _q = [[Questions alloc] init];
        [_tableView reloadData];
    }
}
-(void)returnTextViewTextWithLabelDelegate:(NSString *)labelText withTextViewText:(NSString *)textViewText{
    [_q setAttributeFromStr:labelText withTextView:textViewText];
}
-(void)retuanAnswerDelegate{
    [self addAnswerBackView];
    [self.view endEditing:NO];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
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
