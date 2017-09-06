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
#import "QuestionBank.h"

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
    
    _questionsAry = [NSMutableArray arrayWithCapacity:1];
    
    [self getData];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its vnib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"1000",@"length",nil];
    [[NetworkRequest sharedInstance] GET:QuertyQusetionBank dict:dict succeed:^(id data) {
        NSArray * ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count; i++) {
            QuestionBank * q = [[QuestionBank alloc] init];
            [q setSelfInfoWithDict:ary[i]];
            [_questionsAry addObject:q];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"添加试题" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = myButton;
    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backbtn;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
