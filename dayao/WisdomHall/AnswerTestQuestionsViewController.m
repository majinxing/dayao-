//
//  AnswerTestQuestionsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AnswerTestQuestionsViewController.h"
#import "DYHeader.h"

#import "QuestionsTableViewCell.h"

#import "ImportTextViewController.h"

#import "AnswerChoiceQuestionViewController.h"
#import "AnswerEssayQuestionViewController.h"
#import "AnswerTOFQuestionViewController.h"

#import "ChooseTopicView.h"

@interface AnswerTestQuestionsViewController ()<UITextViewDelegate,ChooseTopicViewDelegate,AnswerTOFQuestionViewControllerDelegate,AnswerEssayQuestionViewControllerDelegate,AnswerChoiceQuestionViewControllerDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UserModel * user;

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)ChooseTopicView * chooseTopic;

@property (nonatomic,strong)AnswerChoiceQuestionViewController * choiceQVC;

@property (nonatomic,strong)AnswerEssayQuestionViewController * essayQVC;

@property (strong, nonatomic) IBOutlet UIButton *addTitleBtn;//增加题目按钮

@property (nonatomic,strong)AnswerTOFQuestionViewController * tOFQVC;

@property (nonatomic,assign) int temp;//标志位 标明所在的题目

@end

@implementation AnswerTestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavigationTitle];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _temp = 0;

    
    _allQuestionAry = [NSMutableArray arrayWithCapacity:1];
   
    if (!_editable) {
        [_addTitleBtn removeFromSuperview];
        
        [self getData];
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}  
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"examId",[NSString stringWithFormat:@"%@",_user.peopleId],@"userId",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryQuestionList dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++) {
                QuestionModel * q = [[QuestionModel alloc] init];
                
                [q addContenWithDict:ary[i]];
                
                q.edit = NO;
                
                [_allQuestionAry addObject:q];
            }
            
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
        }else{
            [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
        }
        
    } failure:^(NSError *error) {
        
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
    
    self.title = _titleStr;

    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    
    
//    self.navigationItem.rightBarButtonItem = myButton;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [backItem setTintColor:[UIColor whiteColor]];
    
//    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)back{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"返回后将不保存答题信息，若想保存请提交保存" preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"退出页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated: YES];
    
    }]];
    

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)more{
    NSMutableArray * dataAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0;i<_allQuestionAry.count; i++) {
        QuestionModel *q = _allQuestionAry[i];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",q.questionId],@"examQuestionId",[NSString stringWithFormat:@"%@",q.questionAnswer],@"answer",nil];
        if (q.questionAnswerImageIdAry.count>0) {
            [dict setObject:q.questionAnswerImageIdAry forKey:@"resourceList"];
        }
        
        [dataAry addObject:dict];
    }
    NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"id",dataAry,@"examAnswerList",nil];
    
    [[NetworkRequest sharedInstance] POST:HandIn dict:d succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        [UIUtils showInfoMessage:message withVC:self];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);

    }];
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
                _choiceQVC = [[AnswerChoiceQuestionViewController alloc] init];
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
                _tOFQVC = [[AnswerTOFQuestionViewController alloc] init];
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
                _essayQVC = [[AnswerEssayQuestionViewController alloc] init];
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
-(void)chooseDelegateSelectTopic:(UIButton *)btn{
    
    //     1.单选 2.多选 3.判断 4.填空 5.问答
    
    QuestionModel * q = [[QuestionModel alloc] init];
    
    if (!_scrollView) {
        
        [_allQuestionAry addObject:q];
        
        [self addQidScrollView];
    }else{
        
        [_allQuestionAry addObject:q];
        
        [self addScrollViewBtn:(int)_allQuestionAry.count];
    }
    
    [_chooseTopic removeFromSuperview];
    
    if (btn.tag == 100||btn.tag == 101) {
        [_essayQVC.view removeFromSuperview];
        [_tOFQVC.view removeFromSuperview];
        
        if (!_choiceQVC) {
            _choiceQVC = [[AnswerChoiceQuestionViewController alloc] init];
        }
        _choiceQVC.editable = _editable;
        
        _choiceQVC.selectMore = NO;
        
        q.selectMore = NO;
        if (btn.tag == 100) {
            q.titleType = @"1";
            
        }else{
            q.titleType = @"2";
            
        }
        
        _choiceQVC.questionModel = q;
        
        [_choiceQVC viewDidLoad];
        
        [self addChildViewController:_choiceQVC];
        
        _choiceQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        
        [self.view addSubview:_choiceQVC.view];
        
        [self.view sendSubviewToBack:_choiceQVC.view];
        
    }else if (btn.tag == 102){
        [_choiceQVC.view removeFromSuperview];
        
        [_essayQVC.view removeFromSuperview];
        
        if (!_tOFQVC) {
            _tOFQVC = [[AnswerTOFQuestionViewController alloc] init];
        }
        _tOFQVC.editable = _editable;
        
        q.titleType = @"3";
        
        _tOFQVC.questionModel = q;
        
        [self addChildViewController:_tOFQVC];
        
        _tOFQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        
        [self.view addSubview:_tOFQVC.view];
        
        [self.view sendSubviewToBack:_tOFQVC.view];
        
    }else if (btn.tag == 103||btn.tag == 104){
        [_choiceQVC.view removeFromSuperview];
        [_tOFQVC.view removeFromSuperview];
        if (!_essayQVC) {
            _essayQVC = [[AnswerEssayQuestionViewController alloc] init];
        }
        
        _essayQVC.editable = _editable;
        if (btn.tag == 103) {
            q.titleType = @"5";
        }else{
            q.titleType = @"4";
        }
        _essayQVC.questionModel = q;
        
        [_essayQVC viewDidLoad];
        
        [self addChildViewController:_essayQVC];
        
        _essayQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        
        [self.view addSubview:_essayQVC.view];
        
        [self.view sendSubviewToBack:_essayQVC.view];
    }
    
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
