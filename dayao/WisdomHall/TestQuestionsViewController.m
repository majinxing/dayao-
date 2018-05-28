//
//  TestQuestionsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
// 展示试卷内容的

#import "TestQuestionsViewController.h"
#import "DYHeader.h"

#import "UIUtils.h"
#import "contactTool.h"

#import "QuestionsTableViewCell.h"

#import "ImportTextViewController.h"

#import "AllTestViewController.h"
#import "ChoiceQuestionViewController.h"
#import "EssayQuestionViewController.h"
#import "TOFQuestionViewController.h"

#import "ChooseTopicView.h"

@interface TestQuestionsViewController ()<UITextViewDelegate,ChooseTopicViewDelegate,ChoiceQuestionViewControllerDelegate,EssayQuestionViewControllerDelegate,TOFQuestionViewControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UserModel * user;

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)ChooseTopicView * chooseTopic;

@property (nonatomic,strong)ChoiceQuestionViewController * choiceQVC;

@property (nonatomic,strong)EssayQuestionViewController * essayQVC;
@property (strong, nonatomic) IBOutlet UIButton *addTitleBtn;//增加题目按钮

@property (nonatomic,strong)TOFQuestionViewController * tOFQVC;

@property (nonatomic,assign) int temp;
@end

@implementation TestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _allQuestionAry = [NSMutableArray arrayWithCapacity:1];

    if (!_editable) {
        [_addTitleBtn removeFromSuperview];
        
        [self getData];
    }

    [self addBtn];
    
   
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
  
}
-(void)addBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(APPLICATION_WIDTH-70, APPLICATION_HEIGHT-100, 50, 50);
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:30];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 25;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
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
}
-(void)addQidScrollView{
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
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"试题";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"发布试卷" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    
    [myButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)more{
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
- (IBAction)addQuestion:(UIButton *)sender {
    if (!_chooseTopic) {
        
        _chooseTopic = [[ChooseTopicView alloc] init];
        _chooseTopic.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64);
        _chooseTopic.delegate = self;
    }
    [self.view addSubview:_chooseTopic];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 问题代理方法
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
