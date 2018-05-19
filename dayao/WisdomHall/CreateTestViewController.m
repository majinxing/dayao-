//
//  CreateTestViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateTestViewController.h"

#import "TextModel.h"
#import "DYHeader.h"

#import "QuestionBank.h"

#import "TestQuestionsViewController.h"

#import "ImportTextViewController.h"


@interface CreateTestViewController ()
@property(nonatomic,strong)TextModel * textModel;
@property(nonatomic,strong)QuestionBank * questionModel;
@end

@implementation CreateTestViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    [self addBtn];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(APPLICATION_WIDTH-50, APPLICATION_HEIGHT-50, 40, 40);
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#29a7e1"]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addTitle{
    ImportTextViewController * vc = [[ImportTextViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"创建测验";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"发布试卷" style:UIBarButtonItemStylePlain target:self action:@selector(createText)];
    [myButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)createText{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
