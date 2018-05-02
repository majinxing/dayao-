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

@interface TestQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ChooseTopicViewDelegate>
@property (nonatomic,strong)UITableView *tableView;



@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)ChooseTopicView * chooseTopic;

@property (nonatomic,strong)ChoiceQuestionViewController * choiceQVC;

@property (nonatomic,strong)EssayQuestionViewController * essayQVC;

@property (nonatomic,strong)TOFQuestionViewController * tOFQVC;

@end

@implementation TestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    _allQuestionAry = [NSMutableArray arrayWithCapacity:1];
    
//    // 1.注册通知
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectQuestion:) name:@"selectQuestion" object:nil];
    
    // Do any additional setup after loading the view from its nib.
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
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    
    [myButton setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)more{
    
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
-(void)titleClick:(UIButton *)btn{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ChooseTopicDelegate
-(void)chooseDelegateOutOfChooseTopicView{
    [_chooseTopic removeFromSuperview];
}
-(void)chooseDelegateSelectTopic:(UIButton *)btn{
        if (!_scrollView) {
            [_allQuestionAry addObject:@" "];
            [self addQidScrollView];
        }else{
            [_allQuestionAry addObject:@" "];
            [self addScrollViewBtn:(int)_allQuestionAry.count];
        }
    
    [_chooseTopic removeFromSuperview];
    if (btn.tag == 100) {
        [_essayQVC.view removeFromSuperview];
        [_tOFQVC.view removeFromSuperview];
        
        if (!_choiceQVC) {
            _choiceQVC = [[ChoiceQuestionViewController alloc] init];
        }
        _choiceQVC.editable = NO;
        
        [self addChildViewController:_choiceQVC];
        
        _choiceQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        
        [self.view addSubview:_choiceQVC.view];
        
        [self.view sendSubviewToBack:_choiceQVC.view];
        
    }else if (btn.tag == 103){
        [_choiceQVC.view removeFromSuperview];
        [_tOFQVC.view removeFromSuperview];
        if (!_essayQVC) {
            _essayQVC = [[EssayQuestionViewController alloc] init];
        }
        
        
        [self addChildViewController:_essayQVC];
        
        _essayQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        
        [self.view addSubview:_essayQVC.view];
        
        [self.view sendSubviewToBack:_essayQVC.view];
    }else if (btn.tag == 102){
        [_choiceQVC.view removeFromSuperview];
        [_essayQVC.view removeFromSuperview];
        if (!_tOFQVC) {
            _tOFQVC = [[TOFQuestionViewController alloc] init];
        }
        
        [self addChildViewController:_essayQVC];
        
        _tOFQVC.view.frame = CGRectMake(0, 104, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        
        [self.view addSubview:_tOFQVC.view];
        
        [self.view sendSubviewToBack:_tOFQVC.view];
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
