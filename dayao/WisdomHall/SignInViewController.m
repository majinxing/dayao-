//
//  SignInViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SignInViewController.h"
#import "SignPromptView.h"
#import "CreateCourseViewController.h"

#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
#import "CourseDetailsViewController.h"

#import "CollectionHeadView.h"
#import "UserModel.h"
#import "ClassModel.h"
#import "MJRefresh.h"
#import "CreateTemporaryCourseViewController.h"
#import "SelectClassViewController.h"
#import "AlterView.h"
#import "DYTabBarViewController.h"
#import "TheLoginViewController.h"
#import "JoinCours.h"
#import "WorkingLoginViewController.h"
#import "ClassTableViewCell.h"
#import "SynchronousCourseView.h"


static NSString *cellIdentifier = @"cellIdentifier";

@interface SignInViewController ()<AlterViewDelegate,JoinCoursDelegate,UITableViewDelegate,UITableViewDataSource,ClassTableViewCellDelegate,SynchronousCourseViewDelegate>

//@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong) NSMutableArray * classAry;
/** @brief 当前加载的页数 */
@property (nonatomic,assign) int page;

@property (nonatomic,assign) int temp;

@property (nonatomic,strong)AlterView * alterView;

@property (nonatomic,strong)JoinCours * join;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableDictionary * dict;

@property (nonatomic,strong)SynchronousCourseView * synCourseView;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    
    self.temp = 0;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];//RGBA_COLOR(231, 231, 231, 1);

    _synCourseView = [[SynchronousCourseView alloc] initWithFrame: CGRectMake(0, 0, APPLICATION_WIDTH, 0)];
    
    _synCourseView.delegate = self;
    
    _classAry = [NSMutableArray arrayWithCapacity:10];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    [self addAlterView];
    
    
    //    [self addCollection];
    [self headerRereshing];
    
    
    [self addTableView];
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTheClassPage) name:@"UpdateTheClassPage" object:nil];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    // Do any additional setup after loading the view from its nib.
}
-(void)UpdateTheClassPage{
    [self headerRereshing];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SafeAreaTopHeight, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak SignInViewController * weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
        
    }];
//    [_tableView addFooterWithCallback:^{
//        [weakSelf footerRereshing];
//    }];
    [self.view addSubview:_tableView];
    
}
-(void)addAlterView{
    _alterView = [[AlterView alloc] initWithFrame:CGRectMake(60, 200, APPLICATION_WIDTH-120, 120) withLabelText:@"暂无课程"];
    _alterView.layer.masksToBounds = YES;
    _alterView.layer.cornerRadius = 10;
    _alterView.delegate = self;
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
            SignInViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                [_classAry removeAllObjects];
                _classAry = [NSMutableArray arrayWithCapacity:1];
                [_dict removeAllObjects];
                _dict = [[NSMutableDictionary alloc] init];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf hideHud];
                [strongSelf getDataWithPage:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.tableView headerEndRefreshing];
            }else{
                [strongSelf.tableView footerEndRefreshing];
            }
        }
    });
}
#pragma mark 获取数据
-(void)getDataWithPage:(NSInteger)page{
    
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"1");
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        
            [self getSelfJoinClass:page];

        }else if ([str isEqualToString:@"无效token"]){
            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIUtils accountWasUnderTheRoof];
            });
        }else{
            [UIUtils showInfoMessage:str withVC:self];
            [self hideHud];
            [_tableView reloadData];
            return ;
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
        
        [UIUtils showInfoMessage:@"请求失败，请检查网络" withVC:self];
    }];
}
-(void)getSelfJoinClass:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        [self getSelfCreateClassType:page];
    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
    }];
}
//临时
-(void)getSelfCreateClassType:(NSInteger)page{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",@"2",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        [self getSelfJoinClassType:page];
    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
    }];
}
//临时
-(void)getSelfJoinClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",@"2",@"courseType",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"4");
        [self hideHud];
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        for (int i = 0 ; i<_classAry.count; i++) {
            ClassModel * c = _classAry[i];
            
            for (int j = i; j<_classAry.count; j++) {
                ClassModel * c1 = _classAry[j];
                //date02比date01小
                if ([[UIUtils compareTimeStartTime:c.actStarTime withExpireTime:c1.actStarTime] isEqualToString:@"-1"]) {
                    //                    c2 = c1;
                    ClassModel *c2 = [[ClassModel alloc] init];
                    c2 = c;
                    [_classAry setObject:c1 atIndexedSubscript:i];
                    [_classAry setObject:c2 atIndexedSubscript:j];
                    c = _classAry[i];
                }
            }
        }
        
        _dict = [[NSMutableDictionary alloc] initWithDictionary:[UIUtils CurriculumGroup:_classAry]];
        
        [_tableView reloadData];

        
    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
    }];
    
}
-(void)deleteTheDuplicateData{
    for (int i = 0; i<_classAry.count; i++) {
        ClassModel * c = _classAry[i];
        for (int j = i+1; j<_classAry.count; j++) {
            ClassModel * d = _classAry[j];
            NSString * s1 = [NSString stringWithFormat:@"%@",c.sclassId];
            NSString * s2 = [NSString stringWithFormat:@"%@",d.sclassId];
            if ([s1 isEqualToString:s2]) {
                [_classAry removeObjectAtIndex:j];
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTableViewCell * cell ;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    NSString * str = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    NSMutableArray * ary = _dict[str];
    [cell addFirstContentViewWith:(int)indexPath.row withClass:ary];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor whiteColor];//RGBA_COLOR(201, 242, 253, 1);
    
    NSString * month = [NSString stringWithFormat:@"%@月",_monthStr];//[UIUtils getMonth];
    
    NSMutableArray * day = [NSMutableArray arrayWithArray:_weekDayTime];//[UIUtils getWeekAllTimeWithType:nil];
    
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];;
    if (day.count>=7) {
        NSArray *  a = @[month,@"M",@"T",@"W",@"T",@"F",@"S",@"S"];
        for (int i = 0; i<8; i++) {
            if (i == 0) {
                [ary addObject:month];
            }else
                [ary addObject: [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@\n%@",a[i],day[i-1]]]];
        }
    }else{
        ary = [[NSMutableArray alloc] initWithArray:@[month,@"M",@"T",@"W",@"T",@"F",@"S",@"S"]];
    }
    for (int i =0; i<8; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i*APPLICATION_WIDTH/8, 0, APPLICATION_WIDTH/8, 50)];
        label.backgroundColor = [UIColor clearColor];
        
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];;
        
        label.text = ary[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [view addSubview:label];
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)-1, 0, 1, 50)];
        
        v.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
        
        [view addSubview:v];
    }
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    v.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    [view addSubview:v];
    return view;
}
#pragma mark Class
-(void)intoTheCurriculumDelegate:(NSString *)str withNumber:(NSMutableArray *)btn{
    NSMutableArray * ary = [_dict objectForKey:str];
    if (btn.count == 1) {
        _selfNavigationVC.hidesBottomBarWhenPushed = YES;
        CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
        int n = [btn[0] intValue];
        cdetailVC.c = ary[n];
        [_selfNavigationVC.navigationController pushViewController:cdetailVC animated:YES];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有重复课程请选择要查看的课" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
        for (int i = 0; i<btn.count; i++) {
            //分别按顺序放入每个按钮；
            int n = [btn[i] intValue];
            ClassModel * c =ary[n];
            NSString * str = c.name;
            
            [alert addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _selfNavigationVC.hidesBottomBarWhenPushed = YES;
                CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
                int n = [btn[i] intValue];
                cdetailVC.c = ary[n];
                [_selfNavigationVC.navigationController pushViewController:cdetailVC animated:YES];
            }]];

        }
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
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
