//
//  CourseListALLViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/27.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CourseListALLViewController.h"
#import "SignInViewController.h"
#import "NavBarNavigationController.h"
#import "SelectClassViewController.h"
#import "SynchronousCourseView.h"
#import "CreateTemporaryCourseViewController.h"
#import "CreateCourseViewController.h"

@interface CourseListALLViewController ()<SynchronousCourseViewDelegate>
@property (nonatomic,strong)SignInViewController * OldVC;
@property (nonatomic,strong)SignInViewController * nVC;
@property (nonatomic,strong)NSMutableArray * FLDayAry;
@property (nonatomic,strong)SynchronousCourseView * synCourseView;
@property (nonatomic,strong)UserModel * userModel;
@end

@implementation CourseListALLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewVC];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    UISwipeGestureRecognizer * priv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [priv setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:priv];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    
    
    [self setNavigation];
    // Do any additional setup after loading the view from its nib.
}
-(void)setNavigation{
    
    self.title = @"课堂";
    
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"•••" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.rightBarButtonItem = selection;
}
/**
 * 搜索
 **/
-(void)selectionBtnPressed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"同步课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        
        if (!_synCourseView) {
            _synCourseView = [[SynchronousCourseView alloc] init];
        }
        _synCourseView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        _synCourseView.delegate = self;
        [self.view addSubview:_synCourseView];
        
    }]];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"创建课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self setAlterAction];
    }]];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"搜索课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SelectClassViewController * s = [[SelectClassViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    
}
-(void)setAlterAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"创建周期性课堂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        CreateCourseViewController * cCourseVC = [[CreateCourseViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        //    self.tabBarController.tabBar.hidden=YES;
        [self.navigationController pushViewController:cCourseVC animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"创建临时性课堂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        CreateTemporaryCourseViewController * c = [[CreateTemporaryCourseViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:c animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        
        _nVC = [[SignInViewController alloc] init];
        
        
        _nVC.view.frame = CGRectMake(APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        
        _nVC.selfNavigationVC = self;
        
        if (_FLDayAry.count==4) {
            _nVC.monthStr = _FLDayAry[3];
            
            NSMutableArray * ary = [NSMutableArray arrayWithArray:[UIUtils getWeekAllTimeWithType:_FLDayAry[2]]];
            
            _nVC.dictDay = [UIUtils getWeekTimeWithType:_FLDayAry[2]];
            
            _nVC.weekDayTime = [NSMutableArray arrayWithArray:ary];
            
            if (ary.count>=10) {
                [_FLDayAry removeAllObjects];
                [_FLDayAry addObject:ary[7]];
                [_FLDayAry addObject:ary[8]];
                [_FLDayAry addObject:ary[9]];
                [_FLDayAry addObject:ary[10]];
                
            }
        }
        
        [self addChildViewController:_nVC];
        
        
        [self.view addSubview:_nVC.view];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _OldVC.view.frame = CGRectMake(-APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);//CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
            
            _nVC.view.transform = CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
        } completion:^(BOOL finished) {
            
            [_OldVC.view removeFromSuperview];
            
            [_OldVC removeFromParentViewController];
            
            _OldVC = _nVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _OldVC.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
                
            });
            
            
        }];
        
        
    } if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        _nVC = [[SignInViewController alloc] init];
        
        [self addChildViewController:_nVC];
        
        _nVC.view.frame = CGRectMake(-APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        
        _nVC.selfNavigationVC = self;
        
        if (_FLDayAry.count==4) {
            _nVC.monthStr = _FLDayAry[1];
            
            NSMutableArray * ary = [NSMutableArray arrayWithArray:[UIUtils getWeekAllTimeWithType:_FLDayAry[0]]];
            
            _nVC.dictDay = [UIUtils getWeekTimeWithType:_FLDayAry[0]];
            
            _nVC.weekDayTime = [NSMutableArray arrayWithArray:ary];
            
            if (ary.count>=10) {
                [_FLDayAry removeAllObjects];
                [_FLDayAry addObject:ary[7]];
                [_FLDayAry addObject:ary[8]];
                [_FLDayAry addObject:ary[9]];
                [_FLDayAry addObject:ary[10]];
                
            }
        }
        
        
        [self.view addSubview:_nVC.view];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _OldVC.view.frame = CGRectMake(APPLICATION_WIDTH, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);//CGAffineTransformMakeTranslation(-APPLICATION_WIDTH, 0);
            
            _nVC.view.transform = CGAffineTransformMakeTranslation(APPLICATION_WIDTH, 0);
        } completion:^(BOOL finished) {
            
            [_OldVC removeFromParentViewController];
            
            _OldVC = _nVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _OldVC.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
                
            });
            
            
        }];
        
    }
    
    
}


-(void)addChildViewVC{
    
    NSDictionary * dictDay = [UIUtils getWeekTimeWithType:[UIUtils getTime]];
    
    self.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
    _OldVC = [[SignInViewController alloc] init];
    
    _OldVC.dictDay = [NSDictionary dictionaryWithDictionary:dictDay];
    
    _OldVC.monthStr = [UIUtils getMonth];
    
    NSMutableArray * ary = [NSMutableArray arrayWithArray:[UIUtils getWeekAllTimeWithType:[_OldVC.dictDay objectForKey:@"firstDay"]]];
    
    _FLDayAry = [NSMutableArray arrayWithCapacity:1];
    if (ary.count>=10) {
        [_FLDayAry addObject:ary[7]];
        [_FLDayAry addObject:ary[8]];
        [_FLDayAry addObject:ary[9]];
        [_FLDayAry addObject:ary[10]];
    }
    _OldVC.weekDayTime = [NSMutableArray arrayWithArray:ary];
    
    
    [self addChildViewController:_OldVC];
    
    _OldVC.view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
    _OldVC.selfNavigationVC = self;
    
    [self.view addSubview:_OldVC.view];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SynchronousCourseViewDelegate
-(void)submitDelegateWithAccount:(NSString *)count withPassword:(NSString *)password{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:count,@"loginStr",password,@"password",[NSString stringWithFormat:@"%@",_userModel.school],@"universityId", nil];
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    [[NetworkRequest sharedInstance] POST:SyncCourse dict:dict succeed:^(id data) {
        NSString * code  = [[data objectForKey:@"header"] objectForKey:@"code"];
        if (![UIUtils isBlankString:code]) {
            if ([code isEqualToString:@"0000"]) {
                [_nVC viewDidLoad];
                [_synCourseView removeFromSuperview];
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];

            }
        }else{
            [UIUtils showInfoMessage:@"同步课程失败，请稍后再试" withVC:self];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"同步课程失败，请稍后再试" withVC:self];
        [_synCourseView removeFromSuperview];
        [self hideHud];
    }];
}
-(void)outViewDelegate{
    [_synCourseView removeFromSuperview];
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
