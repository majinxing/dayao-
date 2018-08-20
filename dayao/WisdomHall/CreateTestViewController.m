//
//  CreateTestViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateTestViewController.h"


#import "DYHeader.h"

#import "contactTool.h"

#import "QuestionsTableViewCell.h"

#import "ImportTextViewController.h"

#import "AllTestViewController.h"
#import "ChoiceQuestionViewController.h"
#import "EssayQuestionViewController.h"
#import "TOFQuestionViewController.h"

#import "ChooseTopicView.h"


#import "QuestionBank.h"

#import "ChoiceQuestionTableViewCell.h"

@interface CreateTestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TextModel * textModel;
@property(nonatomic,strong)QuestionBank * questionModel;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UserModel * user;

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)ChooseTopicView * chooseTopic;

@property (nonatomic,strong)ChoiceQuestionViewController * choiceQVC;

@property (nonatomic,strong)EssayQuestionViewController * essayQVC;

@property (strong, nonatomic) IBOutlet UIButton *addTitleBtn;//增加题目按钮

@property (nonatomic,strong)TOFQuestionViewController * tOFQVC;

@property (nonatomic,copy) NSString * testType;

@property (nonatomic,assign)int  temp;

@property (nonatomic,assign)int questionNumber;//问题编号

@property (nonatomic,copy)NSString *textName;
@end

@implementation CreateTestViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    _temp = 0;
    
    _questionNumber = 0;
    
    [self setNavigationTitle];
    
    
    [self addTableView];
    
    [self addBtn];

    // Do any additional setup after loading the view from its nib.
}
-(void)addBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(APPLICATION_WIDTH-100, APPLICATION_HEIGHT-120, 60, 60);
    [btn setTitle:@"+" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:40];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
    [btn setBackgroundImage:[UIImage imageNamed:@"Rectangle3"] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 30;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(void)addTitle{
    ImportTextViewController * vc = [[ImportTextViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    
    vc.selectQuestionAry = [NSMutableArray arrayWithArray:_allQuestionAry];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc returnAry:^(NSMutableArray *allAry) {
        _allQuestionAry = [NSMutableArray arrayWithArray:allAry];
        [_tableView reloadData];
    }];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"创建测验";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"发布试卷" style:UIBarButtonItemStylePlain target:self action:@selector(createText)];
    
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)createText{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<_allQuestionAry.count; i++) {
        QuestionModel * q = _allQuestionAry[i];
        NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys: q.qustionScore,@"score",q.questionId,@"questionId",[NSString stringWithFormat:@"%d",i+1],@"order",q.questionDifficulty,@"difficulty",nil];
        [ary addObject:d];
    }
    if (ary.count>0) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_textName,@"name",@"2",@"status",_classModel.sclassId,@"relId",@"1",@"relType",@"2",@"autoCorrecting",ary,@"examQuestionList",[UIUtils getTime],@"startTime",nil];
        [[NetworkRequest sharedInstance] POST:CreateText dict:dict succeed:^(id data) {
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            if ([str isEqualToString:@"成功"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIUtils showInfoMessage:str withVC:self];
            }
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"网络连接失败，请检查网络" withVC:self];
        }];
    }else{
        [UIUtils showInfoMessage:@"发布试卷题目不能为空" withVC:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_testType isEqualToString:@"single"]) {
        return 1;
    }else{
        if (_allQuestionAry>0) {
            return _allQuestionAry.count;
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_testType isEqualToString:@"single"]) {
        if (_allQuestionAry.count>0) {
            //1.单选 2.多选 3.判断 4.填空 5.问答
            QuestionModel * q = _allQuestionAry[_temp];
            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
                return 2+q.qustionOptionsAry.count;
            }
            return 3;
        }
    }else{
        if (_allQuestionAry>0) {
            //1.单选 2.多选 3.判断 4.填空 5.问答
            QuestionModel * q = _allQuestionAry[section];
            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
                return 2+q.qustionOptionsAry.count;
            }
            return 3;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoiceQuestionTableViewCell * cell ;
    
    QuestionModel * q;
    
    if ([_testType isEqualToString:@"single"]) {
        q = _allQuestionAry[_temp];
    }else{
        q = _allQuestionAry[indexPath.section];
    }
    
    
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellEighth"];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:7];
            
        }else if (indexPath.row == 1){
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        else if (indexPath.row == 2+q.qustionOptionsAry.count){
            if ([q.titleType  isEqualToString:@"5"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
    }
    if (indexPath.row == 0) {
        
        [cell eigthTitleType:q.titleTypeName withScore:q.qustionScore isSelect:NO isEnableSelect:NO btnTag:(int)indexPath.section+1];
        
    }
    if (indexPath.row==1) {
        
        [cell addFirstTitleTextView:q.questionTitle withImageAry:q.questionTitleImageIdAry withIsEdit:NO withIndexRow:(int)indexPath.section];
        
    }else if(indexPath.row>1&&indexPath.row<2+q.qustionOptionsAry.count) {
        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
        
        optionsModel * opt = q.qustionOptionsAry[indexPath.row-2];
        
        if (![_testType isEqualToString:@"single"]) {
            _questionNumber = (int)(indexPath.section*1000+indexPath.row-2);
        }else{
            _questionNumber = (int)indexPath.row-2;
        }
        //字条串是否包含有某字符串
        if ([string rangeOfString:opt.index].location == NSNotFound) {
            
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withEdit:_editable withIndexRow:_questionNumber withISelected:NO];
            
        }else{
            
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withEdit:_editable withIndexRow:_questionNumber withISelected:YES];
        }
    }else if (indexPath.row == 2+q.qustionOptionsAry.count){
        if ([q.titleType  isEqualToString:@"5"]) {
            //问答。可上传图片
            if (NO) {
                [cell addFirstTitleTextView:q.questionAnswer withImageAry:q.questionAnswerImageAry withIsEdit:YES withIndexRow:(int)indexPath.section];
            }else{
                
                [cell addFirstTitleTextView:q.questionAnswer withImageAry:q.questionAnswerImageIdAry withIsEdit:NO withIndexRow:(int)indexPath.section];
                
            }
            //
        }else{
            if (![_testType isEqualToString:@"single"]) {
                _questionNumber = (int)(indexPath.section);
            }else{
                _questionNumber = _temp;
            }
            
            [cell addSeventhTextViewWithStr:q.questionAnswer withIndexRow:_questionNumber];
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
    if (_allQuestionAry.count>0) {
        
        QuestionModel * q ;//= _allQuestionAry[indexPath.section];
        if ([_testType isEqualToString:@"single"]) {
            q = _allQuestionAry[_temp];
        }else{
            q = _allQuestionAry[indexPath.section];
        }
        if (indexPath.row == 0) {
            return 60;
        }else if(indexPath.row == 1){
            
            return [q returnTitleHeight];
            
        }else if (indexPath.row == 2+q.qustionOptionsAry.count){
            if ([q.titleType isEqualToString:@"5"]) {
                float h = [q returnAnswerHeight];
                if (h<400) {
                    return 400;
                }else{
                    return h;
                }
            }else{
                float h = [q returnAnswerHeightZone];
                
                if (h<60) {
                    return 60;
                }else{
                    return h;
                }
            }
        }else{
            return [q returnOptionHeight:(int)indexPath.row-2];
        }
        return 60;
    }
    return 0;
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
