//
//  TextListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/15.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextListViewController.h"
#import "TestQuestionsViewController.h"
#import "TextViewController.h"
#import "DYHeader.h"
#import "Questions.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "QuestionsTableViewCell.h"
#import "contactTool.h"
#import "AnswerModel.h"
#import "ImportTextViewController.h"

@interface TextListViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionsTableViewCellDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UILabel * qNumLabel;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UIButton * allBtn;
@property (nonatomic,strong) UIView * bottom;
@property (nonatomic,strong) NSMutableArray * questionsAry;
@property (nonatomic,strong) NSMutableArray * answerAry;
@property (nonatomic,strong) FMDatabase * db;
@property (nonatomic,strong) Questions * q;//问题
@property (nonatomic,assign) int temp;//标志位
@property (nonatomic,assign) int tempSecond;//标志位 表明不是第一次加载数据
@property (nonatomic,assign) BOOL teacherOrStudent;
@property (nonatomic,strong) NSArray * op;
@end

@implementation TextListViewController

-(void)dealloc{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _teacherOrStudent = YES;

    [self setNavigationTitle];

    [self addTableView];

    [self addNextBtnOrOnBtnView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
  
}
-(void)viewDidAppear:(BOOL)animated{

}

-(void)viewDidDisappear:(BOOL)animated{

}
-(void)addQuestions{
 
}
-(void)addTableView{
    _op =[NSArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    UISwipeGestureRecognizer * priv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextBtn:)];
    [priv setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_tableView addGestureRecognizer:priv];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextBtn:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_tableView addGestureRecognizer:recognizer];

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
    self.title = @"试题列表";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"添加试题" style:UIBarButtonItemStylePlain target:self action:@selector(theImportQuestionBtn)];
    if (!_teacherOrStudent) {
        [myButton setTitle:@"交卷"];
    }
    self.navigationItem.rightBarButtonItem = myButton;
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = leftButton;
}
-(void)theImportQuestionBtn{
    
    if (!_teacherOrStudent) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要交卷" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
        [alertView show];
        alertView.tag = 1;
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加试题" message:nil delegate:self cancelButtonTitle:@"题库导入" otherButtonTitles: @"创建新题", nil];
    [alertView show];
    alertView.tag = 2;
    return;
}
-(void)back{
    //    if (!_teacherOrStudent) {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要交卷" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
    //        [alertView show];
    //        return;
    //    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TextViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
/**
 * 下一题、上一题、全部试题
 **/
-(void)addNextBtnOrOnBtnView{
    if (!_qNumLabel) {
        _qNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT-50, 100, 50)];
    }
    _qNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_temp+1,(unsigned long)_questionsAry.count];
    _qNumLabel.backgroundColor = [UIColor whiteColor];
    _qNumLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_qNumLabel];
    
    if (!_time) {
        _time = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-100, APPLICATION_HEIGHT-50, 100, 50)];
    }
    _time.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_time];
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _allBtn.frame = CGRectMake(100, APPLICATION_HEIGHT-50, APPLICATION_WIDTH-200, 50);
    [_allBtn setTitle:@"全部试题" forState:UIControlStateNormal];
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _allBtn.backgroundColor = [UIColor whiteColor];
    [_allBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    _allBtn.tag = 2;
    [self.view addSubview:_allBtn];
    
}
-(void)nextBtn:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_temp == _questionsAry.count-1) {
            
        }else{
            _temp = _temp + 1;
            _q = _questionsAry[_temp];
            [_tableView reloadData];
        }
        NSLog(@"swipe left");
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_temp==0) {
            _temp = 0;
        }else{
            _temp = _temp - 1;
            _q = _questionsAry[_temp];
            [_tableView reloadData];
        }
        NSLog(@"swipe right");
    }
    _qNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_temp+1,(unsigned long)_questionsAry.count];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark QuestionsTableViewCellDelegate
//答案收集
-(void)selectBtnPressedDelegate:(UIButton *)btn{
    AnswerModel * a = _answerAry[_temp];
    [a changeAnswerWithBtn:btn];
    [a answerAryChange];
    _answerAry[_temp] = a;
    [_tableView reloadData];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_questionsAry.count>=1) {
        return 5;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionsTableViewCell * cell ;
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
