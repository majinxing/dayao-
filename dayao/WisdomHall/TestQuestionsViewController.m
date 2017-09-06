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
#import "QuestionsTableViewCell.h"
#import "QuestionListViewController.h"
#import "ImportTextViewController.h"


@interface TestQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CreateTextTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * questionArt;
@property (nonatomic,strong)Questions * q;
@property (nonatomic,strong)NSMutableArray * labelText;
@property (nonatomic,strong)NSArray * ary;
@end

@implementation TestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _labelText = [NSMutableArray arrayWithCapacity:1];
    
    [_labelText addObject:@"题目"];
    
    [_labelText addObject:@"答案"];

    _questionArt = [NSMutableArray arrayWithCapacity:1];
    
    _q = [[Questions alloc] init];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
    [self keyboardNotification];
    
    // Do any additional setup after loading the view from its nib.
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)more{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"提交创建试卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从题库导入试题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ImportTextViewController * VC = [[ImportTextViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"试题列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        QuestionListViewController * q = [[QuestionListViewController alloc] init];
        
        q.questionAry = [[NSMutableArray alloc] initWithArray:_questionArt];
        
        q.isSelect = NO;
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:q animated:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}


-(void)questionAnswer:(NSMutableArray*)ary{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------------------UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateTextTableViewCell * cell;
    if (indexPath.row<2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreateTextTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateTextTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            [cell addContentView:_labelText[indexPath.row] withTextViewStr:_q.title];
        }else{
            [cell addContentView:_labelText[indexPath.row] withTextViewStr:_q.answer];
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreateTextTableViewCellSecond"];
        if (!cell) {
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateTextTableViewCell" owner:nil options:nil] objectAtIndex:1];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
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
    Questions *q = [[Questions alloc] init];
    if ([UIUtils isBlankString:_q.title]||[UIUtils isBlankString:_q.answer]) {
        [UIUtils showInfoMessage:@"题目和答案请填写完整"];
        return;
    }
    q.title = _q.title;
    
    q.answer = _q.answer;
    
    [_questionArt addObject:q];
    
    _q = nil;
    
    _q = [[Questions alloc] init];
    
    [_tableView reloadData];
}
-(void)returnTextViewTextWithLabelDelegate:(NSString *)labelText withTextViewText:(NSString *)textViewText{
    if ([labelText isEqualToString:@"题目"]) {
        _q.title = textViewText;
    }else{
        _q.answer = textViewText;
    }
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
