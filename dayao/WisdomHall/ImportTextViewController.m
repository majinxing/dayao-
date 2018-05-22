//
//  ImportTextViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ImportTextViewController.h"
#import "contactTool.h"

#import "Questions.h"
#import "QuestionsTableViewCell.h"
#import "ContactModel.h"
#import "QuestionBank.h"
#import "MJRefresh.h"
#import "DYHeader.h"
#import "QuestionBankListViewController.h"
#import "QuestionModel.h"
#import "ChoiceQuestionTableViewCell.h"
#import "QuestionModel.h"
#import "optionsModel.h"

@interface ImportTextViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionBankListViewControllerDelegate,ChoiceQuestionTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray * questionsAry;

@property (nonatomic,strong)NSMutableArray * selected;//是否被选中的状态

@property (nonatomic,strong)NSMutableArray * selectQuestiond;//已经选中的题，移除

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//该题库所有题


@property (nonatomic,strong)FMDatabase * db;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,assign) int temp;//记录题库是否展示

/** @brief 当前加载的页数 */
@property (nonatomic,assign) int page;

@property (nonatomic,copy) NSString * bankId;//当前题库id
@property (strong, nonatomic) IBOutlet UIButton *selectAllQuestionBtn;

@property (nonatomic,strong) QuestionBankListViewController * qBankVC;

@property (nonatomic,strong)UIBarButtonItem *myButton;

@end

@implementation ImportTextViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _questionsAry = [NSMutableArray arrayWithCapacity:1];
    
    _allQuestionAry = [NSMutableArray arrayWithCapacity:1];
    
    
    [self getData];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    _qBankVC = [[QuestionBankListViewController alloc] init];
    
    _qBankVC.delegate = self;
    
    [self addChildViewController:_qBankVC];
    
    _qBankVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, 300);
    
    _temp = 0;
    
    // Do any additional setup after loading the view from its vnib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"1000",@"length",nil];
    [[NetworkRequest sharedInstance] GET:QuertyQusetionBank dict:dict succeed:^(id data) {
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        
        NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([code isEqualToString:@"0000"]) {
            for (int i = 0; i<ary.count; i++) {
                QuestionBank * q = [[QuestionBank alloc] init];
                [q setSelfInfoWithDict:ary[i]];
                [_questionsAry addObject:q];
            }
            if (_questionsAry.count>0) {
                QuestionBank * q1 = _questionsAry[0];
                _page = 1;
                _bankId = q1.libId;
                [self getQuestionBanK:q1.libId WithPage:_page];
            }
        }else{
            [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
        }
        
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"网络连接失败，请检查网络" withVC:self];
    }];
}

-(void)returnAry:(returnSelectedQustion)block{
    _returnBlock = block;
}
-(void)viewWillDisappear:(BOOL)animated{
    if (self.returnBlock!=nil) {
        self.returnBlock(_selectQuestionAry);
    }
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.backgroundColor = [UIColor clearColor];
    //    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    
    __weak ImportTextViewController * weakSelf = self;
    
    [_tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
        
    }];
    [_tableView addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"题库";
    _myButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld导入",_selectQuestionAry.count] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = _myButton;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)headerRereshing{
    self.page = 1;
    [self fetchChatRoomsWithPage:self.page isHeader:YES];
}
-(void)footerRereshing{
    self.page +=1;
    [self fetchChatRoomsWithPage:self.page isHeader:NO];
}
- (void)fetchChatRoomsWithPage:(NSInteger)aPage
                      isHeader:(BOOL)aIsHeader{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            ImportTextViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [strongSelf hideHud];
                [strongSelf getQuestionBanK:_bankId WithPage:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.tableView headerEndRefreshing];
            }else{
                [strongSelf.tableView footerEndRefreshing];
            }
        }
    });
}
-(void)getQuestionBanK:(NSString *)bankId WithPage:(NSInteger)page{
    
//    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:bankId,@"libId",[NSString stringWithFormat:@"% ld",(long)page],@"start",@"50",@"length",nil];
    [_allQuestionAry removeAllObjects];
    [[NetworkRequest sharedInstance] GET:QuertyBankQuestionList dict:dict succeed:^(id data) {
        NSString *message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        
        if ([message isEqualToString:@"成功"]){
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                QuestionModel * q = [[QuestionModel alloc] init];
                
                [q addContenWithDict:ary[i]];
                
                q.edit = NO;
                
                [_allQuestionAry addObject:q];
            }
        }else{
            [UIUtils showInfoMessage:message withVC:self];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
        [UIUtils showInfoMessage:@"网络连接失败，请检查网络" withVC:self];

    }];
    
}
- (IBAction)chooseBank:(UIButton *)sender {
    
    if (_temp == 0) {
        [_qBankVC.bankListAry removeAllObjects];
        _qBankVC.bankListAry = [NSMutableArray arrayWithArray:_questionsAry];
        [_qBankVC viewDidLoad];
        [self.view addSubview:_qBankVC.view];
        _temp = 1;
    }else{
        _temp = 0;
        [_qBankVC.view removeFromSuperview];
    }
}
- (IBAction)allselectQuestionBtn:(id)sender {
    for (int i = 0; i<_allQuestionAry.count; i++) {
        
        QuestionModel * q = _allQuestionAry[i];
        
        for (int j = 0; j<_selectQuestionAry.count; j++) {
            QuestionModel * q1 = _selectQuestionAry[j];
            if ([q.questionId isEqualToString:q1.questionId]) {
                [_selectQuestionAry removeObjectAtIndex:j];
                break;
            }
        }
        [_selectQuestionAry addObject:q];
    }
    [_tableView reloadData];
    [_myButton setTitle:[NSString stringWithFormat:@"%ld导入",_selectQuestionAry.count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ChoiceQuestionTableViewCellDelegate
-(void)eighthSelectTitleDelegate:(UIButton *)btn{
    QuestionModel * q = _allQuestionAry[btn.tag-1];
    for (int i = 0; i<_selectQuestionAry.count; i++) {
        QuestionModel * q1 = _selectQuestionAry[i];
        if ([q.questionId isEqualToString:q1.questionId]) {
            [_selectQuestionAry removeObjectAtIndex:i];
            [_tableView reloadData];
            [_myButton setTitle:[NSString stringWithFormat:@"%ld导入",_selectQuestionAry.count]];
            return;
        }
    }
    [_selectQuestionAry addObject:q];
    [_tableView reloadData];
    [_myButton setTitle:[NSString stringWithFormat:@"%ld导入",_selectQuestionAry.count]];
}
#pragma mark QuestionBankListViewControllerDelegate
-(void)returnBankModelDelegate:(QuestionBank *)q{
    _temp = 0;
    [_qBankVC.view removeFromSuperview];
    _bankId = q.libId;
    
    [self headerRereshing];
    //    NSDictionary * dict
}
#pragma mark --UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _allQuestionAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //1.单选 2.多选 3.判断 4.填空 5.问答
    QuestionModel * q = _allQuestionAry[section];
    if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
        return 2+q.qustionOptionsAry.count;
    }
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoiceQuestionTableViewCell * cell ;
    
    QuestionModel * q = _allQuestionAry[indexPath.section];
    
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellEighth"];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:7];
        }else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        else if (indexPath.row == 2+q.qustionOptionsAry.count){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
    }
    if (indexPath.row == 0) {
        
        BOOL b = [self questionIsSelect:(int)indexPath.section];
        
        [cell eigthTitleType:q.titleTypeName withScore:q.qustionScore isSelect:b btnTag:(int)indexPath.section+1];
        
    }
    if (indexPath.row==1) {
        
        
        [cell addFirstTitleTextView:q.questionTitle withImageAry:q.questionTitleImageIdAry withIsEdit:NO];
        
    }else if (indexPath.row == 2+q.qustionOptionsAry.count){
        
        [cell addSeventhTextViewWithStr:[NSString stringWithFormat:@"答案：%@",q.questionAnswer]];
        
    }else if(indexPath.row>1&&indexPath.row<2+q.qustionOptionsAry.count) {
        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
        
        optionsModel * opt = q.qustionOptionsAry[indexPath.row-2];
        
        //字条串是否包含有某字符串
        if ([string rangeOfString:opt.index].location == NSNotFound) {
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withIndexRow:(int)indexPath.row-2 withISelected:NO];
        }else{
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withIndexRow:(int)indexPath.row-2 withISelected:YES];
        }
        
    }
    
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionModel * q = _allQuestionAry[indexPath.section];
    
    if (indexPath.row == 0) {
        return 50;
    }else if(indexPath.row == 1){
        
        return [q returnTitleHeight];
        
    }else if (indexPath.row == 2+q.qustionOptionsAry.count){
        
        return [q returnAnswerHeightZone];
        
    }else{
        return [q returnOptionHeight:(int)indexPath.row-2];
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(BOOL)questionIsSelect:(int)index{
    QuestionModel * q = _allQuestionAry[index];
    for (int i = 0; i<_selectQuestionAry.count; i++) {
        QuestionModel * q1 = _selectQuestionAry[i];
        if ([q.questionId isEqualToString:q1.questionId]) {
            return YES;
        }
    }
    return NO;
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
