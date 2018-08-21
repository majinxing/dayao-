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

@interface CreateTestViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceQuestionViewControllerDelegate,EssayQuestionViewControllerDelegate,TOFQuestionViewControllerDelegate>
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


@end

@implementation CreateTestViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    _temp = 0;
    
    _questionNumber = 0;
    
    [self setNavigationTitle];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _allQuestionAry = [NSMutableArray arrayWithCapacity:1];
    
    if (!_editable) {
        [_addTitleBtn removeFromSuperview];
        
    }
    
    [self addBtn];
    
//    [self addTableView];
    
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
        
        if (_allQuestionAry.count == 1) {
            [self addQidScrollView];
        }else if(_allQuestionAry.count>1){
            [self addQidScrollView];
            for (int i = 1 ; i<_allQuestionAry.count; i++) {
                
                [self addScrollViewBtn:i+1];
            }
        }
        [_scrollView setContentOffset:CGPointMake(0,0) animated:NO];
        
        UIButton * btn = [[UIButton alloc] init];
        
        btn.tag = 1;
        
        [self titleClick:btn];
    }];
    
//    ImportTextViewController * vc = [[ImportTextViewController alloc] init];
//    self.hidesBottomBarWhenPushed = YES;
//
//    vc.selectQuestionAry = [NSMutableArray arrayWithArray:_allQuestionAry];
//
//    [self.navigationController pushViewController:vc animated:YES];
//
//    [vc returnAry:^(NSMutableArray *allAry) {
//        _allQuestionAry = [NSMutableArray arrayWithArray:allAry];
//        [_tableView reloadData];
//    }];
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
-(void)addScrollViewBtn:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //        button.backgroundColor = [UIColor greenColor];
    
    button.frame = CGRectMake(APPLICATION_WIDTH/3*(tag-1),0,APPLICATION_WIDTH/3,40);
    
    _scrollView.contentSize = CGSizeMake(APPLICATION_WIDTH/3*tag, 40);
    if (tag>3) {
        [_scrollView setContentOffset:CGPointMake(APPLICATION_WIDTH/3*(tag-3),0) animated:YES];
    }
    
    [button setTitle:[NSString stringWithFormat:@"第%d题",tag] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    button.tag = tag;
    //设置点击事件
    [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:button];
}
//顶部滑框选择试题
-(void)titleClick:(UIButton *)btn{
    [self.view endEditing:YES];
    
    int num  = (int)btn.tag;
    
    _temp = (int)btn.tag;
    
    if (btn.tag-1<_allQuestionAry.count) {
        QuestionModel * q = _allQuestionAry[btn.tag-1];
        if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
            [_essayQVC.view removeFromSuperview];
            [_tOFQVC.view removeFromSuperview];
            
            if (!_choiceQVC) {
                _choiceQVC = [[ChoiceQuestionViewController alloc] init];
            }
            _choiceQVC.editable = _editable;
            
            _choiceQVC.selectMore = q.selectMore;
            
            _choiceQVC.questionModel = q;
            
            _choiceQVC.titleNum = num;
            
            [_choiceQVC viewDidLoad];
            
            [self addChildViewController:_choiceQVC];
            
            _choiceQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
            
            [self.view addSubview:_choiceQVC.view];
            
            [self.view sendSubviewToBack:_choiceQVC.view];
            
        }else if ([q.titleType isEqualToString:@"3"]){
            [_choiceQVC.view removeFromSuperview];
            [_essayQVC.view removeFromSuperview];
            if (!_tOFQVC) {
                _tOFQVC = [[TOFQuestionViewController alloc] init];
            }
            _tOFQVC.editing = _editable;
            
            _tOFQVC.questionModel = q;
            
            [_tOFQVC viewDidLoad];
            
            _tOFQVC.titleNum = num;
            
            [self addChildViewController:_tOFQVC];
            
            _tOFQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
            
            [self.view addSubview:_tOFQVC.view];
            
            [self.view sendSubviewToBack:_tOFQVC.view];
        }else if ([q.titleType isEqualToString:@"5"]||[q.titleType isEqualToString:@"4"]){
            
            [_choiceQVC.view removeFromSuperview];
            [_tOFQVC.view removeFromSuperview];
            if (!_essayQVC) {
                _essayQVC = [[EssayQuestionViewController alloc] init];
            }
            
            _essayQVC.editable = _editable;
            
            [_essayQVC viewDidLoad];
            
            _essayQVC.questionModel = q;
            
            _essayQVC.titleNum = num;
            
            [self addChildViewController:_essayQVC];
            
            _essayQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
            
            [self.view addSubview:_essayQVC.view];
            
            [self.view sendSubviewToBack:_essayQVC.view];
        }
    }
    _choiceQVC.delegate = self;
    _essayQVC.delegate = self;
    _tOFQVC.delegate = self;
}
-(void)addQidScrollView{
  
        [_scrollView removeFromSuperview];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 40)];
        
        
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
        
        self.scrollView.bounces = YES;
        
        [self.view addSubview:_scrollView];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        
        self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self addScrollViewBtn:1];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent
                                                *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 问题代理方法
-(void)removeTitleBtnPressedTOFQVCDelegate:(UIButton *)btn{
    [self removeTitleBtnPressed:btn];
}
-(void)removeTitleBtnPressedEQVCDelegate:(UIButton *)btn{
    [self removeTitleBtnPressed:btn];

}
-(void)removeTitleBtnPressedCQVCDelegate:(UIButton *)btn{
    [self removeTitleBtnPressed:btn];

}
-(void)removeTitleBtnPressed:(UIButton *)btn{
    int n = 0;
    if ((btn.tag-1)<_allQuestionAry.count) {
        
        [_choiceQVC.view removeFromSuperview];
        
        [_tOFQVC.view removeFromSuperview];
        
        [_essayQVC.view removeFromSuperview];
        
        if (btn.tag == _allQuestionAry.count) {
            if (btn.tag == 1) {
                [_scrollView removeFromSuperview];
                [_allQuestionAry removeObjectAtIndex:btn.tag-1];

                return;
            }else{
                n = (int)btn.tag - 1;
            }
        }else{
            n = (int)btn.tag;
        }
        [_allQuestionAry removeObjectAtIndex:btn.tag-1];
        
    }else{
        return;
    }
    
    
    
    if (_allQuestionAry.count == 1) {
        [self addQidScrollView];
    }else if(_allQuestionAry.count>1){
        [self addQidScrollView];
        for (int i = 1 ; i<_allQuestionAry.count; i++) {
            
            [self addScrollViewBtn:i+1];
        }
    }
//    [_scrollView setContentOffset:CGPointMake(0,0) animated:NO];

    UIButton * btna = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btna.tag = n;
    
    [self titleClick:btna];
    
    [_scrollView setContentOffset:CGPointMake(APPLICATION_WIDTH*((btna.tag-1)/3),0) animated:NO];
}
-(void)handleSwipeFromDelegate:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        if (_temp<_allQuestionAry.count) {
            UIButton * btn = [[UIButton alloc] init];
            
            btn.tag = _temp +1;
            
            [self titleClick:btn];
        }
        //        }
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if (_temp>1) {
            UIButton * btn = [[UIButton alloc] init];
            
            btn.tag = _temp -1;
            
            [self titleClick:btn];
        }
    }
    
    //    if (_temp>3) {
    
    [_scrollView setContentOffset:CGPointMake(APPLICATION_WIDTH*((_temp-1)/3),0) animated:YES];
    
    //    }
    
    //    [_scrollView];
}
#pragma mark ChooseTopicDelegate
-(void)chooseDelegateOutOfChooseTopicView{
    [_chooseTopic removeFromSuperview];
}

//#pragma mark UITableViewdelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if ([_testType isEqualToString:@"single"]) {
//        return 1;
//    }else{
//        if (_allQuestionAry>0) {
//            return _allQuestionAry.count;
//        }
//    }
//    return 0;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if ([_testType isEqualToString:@"single"]) {
//        if (_allQuestionAry.count>0) {
//            //1.单选 2.多选 3.判断 4.填空 5.问答
//            QuestionModel * q = _allQuestionAry[_temp];
//            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
//                return 2+q.qustionOptionsAry.count;
//            }
//            return 3;
//        }
//    }else{
//        if (_allQuestionAry>0) {
//            //1.单选 2.多选 3.判断 4.填空 5.问答
//            QuestionModel * q = _allQuestionAry[section];
//            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
//                return 2+q.qustionOptionsAry.count;
//            }
//            return 3;
//        }
//    }
//
//    return 0;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ChoiceQuestionTableViewCell * cell ;
//
//    QuestionModel * q;
//
//    if ([_testType isEqualToString:@"single"]) {
//        q = _allQuestionAry[_temp];
//    }else{
//        q = _allQuestionAry[indexPath.section];
//    }
//
//
//    if (!cell) {
//        if (indexPath.row == 0) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellEighth"];
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:7];
//
//        }else if (indexPath.row == 1){
//
//            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
//
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
//        }
//        else if (indexPath.row == 2+q.qustionOptionsAry.count){
//            if ([q.titleType  isEqualToString:@"5"]) {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
//
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
//            }else{
//                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
//
//                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
//            }
//        }else{
//            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
//
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
//        }
//    }
//    if (indexPath.row == 0) {
//
//        [cell eigthTitleType:q.titleTypeName withScore:q.qustionScore isSelect:NO isEnableSelect:NO btnTag:(int)indexPath.section+1];
//
//    }
//    if (indexPath.row==1) {
//
//        [cell addFirstTitleTextView:q.questionTitle withImageAry:q.questionTitleImageIdAry withIsEdit:NO withIndexRow:(int)indexPath.section];
//
//    }else if(indexPath.row>1&&indexPath.row<2+q.qustionOptionsAry.count) {
//        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
//
//        optionsModel * opt = q.qustionOptionsAry[indexPath.row-2];
//
//        if (![_testType isEqualToString:@"single"]) {
//            _questionNumber = (int)(indexPath.section*1000+indexPath.row-2);
//        }else{
//            _questionNumber = (int)indexPath.row-2;
//        }
//        //字条串是否包含有某字符串
//        if ([string rangeOfString:opt.index].location == NSNotFound) {
//
//            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withEdit:_editable withIndexRow:_questionNumber withISelected:NO];
//
//        }else{
//
//            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withEdit:_editable withIndexRow:_questionNumber withISelected:YES];
//        }
//    }else if (indexPath.row == 2+q.qustionOptionsAry.count){
//        if ([q.titleType  isEqualToString:@"5"]) {
//            //问答。可上传图片
//            if (NO) {
//                [cell addFirstTitleTextView:q.questionAnswer withImageAry:q.questionAnswerImageAry withIsEdit:YES withIndexRow:(int)indexPath.section];
//            }else{
//
//                [cell addFirstTitleTextView:q.questionAnswer withImageAry:q.questionAnswerImageIdAry withIsEdit:NO withIndexRow:(int)indexPath.section];
//
//            }
//            //
//        }else{
//            if (![_testType isEqualToString:@"single"]) {
//                _questionNumber = (int)(indexPath.section);
//            }else{
//                _questionNumber = _temp;
//            }
//
//            [cell addSeventhTextViewWithStr:q.questionAnswer withIndexRow:_questionNumber];
//        }
//
//    }
//
//    cell.delegate = self;
//
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_allQuestionAry.count>0) {
//
//        QuestionModel * q ;//= _allQuestionAry[indexPath.section];
//        if ([_testType isEqualToString:@"single"]) {
//            q = _allQuestionAry[_temp];
//        }else{
//            q = _allQuestionAry[indexPath.section];
//        }
//        if (indexPath.row == 0) {
//            return 60;
//        }else if(indexPath.row == 1){
//
//            return [q returnTitleHeight];
//
//        }else if (indexPath.row == 2+q.qustionOptionsAry.count){
//            if ([q.titleType isEqualToString:@"5"]) {
//                float h = [q returnAnswerHeight];
//                if (h<400) {
//                    return 400;
//                }else{
//                    return h;
//                }
//            }else{
//                float h = [q returnAnswerHeightZone];
//
//                if (h<60) {
//                    return 60;
//                }else{
//                    return h;
//                }
//            }
//        }else{
//            return [q returnOptionHeight:(int)indexPath.row-2];
//        }
//        return 60;
//    }
//    return 0;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
