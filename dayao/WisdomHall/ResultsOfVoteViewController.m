//
//  ResultsOfVoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/7.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ResultsOfVoteViewController.h"
#import "DYHeader.h"
#import "VoteDrawView.h"

@interface ResultsOfVoteViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)VoteDrawView * drawView;
@property (nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic, strong)NSArray *x_arr;//x轴数据数组
@property(nonatomic, strong)NSArray *y_arr;//y轴数据数组
@property (nonatomic,assign)int n;
@end

@implementation ResultsOfVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.drawView];
    [self x_arr];
    [self y_arr];
    [self addScrollView];
    [self.drawView drawZhuZhuangtu:self.x_arr and:self.y_arr withAllPeople:@"100"];
    // Do any additional setup after loading the view from its nib.
}
-(void)addScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-80, APPLICATION_WIDTH, APPLICATION_HEIGHT+80)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(APPLICATION_WIDTH, self.drawView.frame.size.height+100);
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:self.drawView];
}

- (NSArray *)x_arr{
    
    if (!_x_arr) {
        
        _x_arr = @[@"北京", @"上海", @"广州", @"深圳", @"武汉", @"成都", @"南京",@"山东",@"潍坊",@"青岛",@"太原",@"四川",@"黑龙江",@"长沙"];
        
    }
    
    return _x_arr;
}


- (NSArray *)y_arr{
    
    if (!_y_arr) {
        
        _y_arr = @[@"80", @"70", @"90", @"60", @"40", @"30", @"60",@"36",@"67",@"34",@"63",@"47",@"67",@"89"];
    }
    
    return _y_arr;
}
- (VoteDrawView *)drawView{
    
    if (!_drawView) {
        
        _drawView = [[VoteDrawView alloc] init];
        _drawView.frame = CGRectMake(0,64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64);
        if (_x_arr.count>=8) {
            _drawView.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64+60*(_x_arr.count - 5));
        }
        //        _drawView.backgroundColor = [UIColor redColor];
    }
    
    return _drawView;
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
