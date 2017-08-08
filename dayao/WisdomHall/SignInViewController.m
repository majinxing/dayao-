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

#import <Hyphenate/Hyphenate.h>

#import "CollectionHeadView.h"
#import "UserModel.h"
#import "ClassModel.h"
#import "MJRefresh.h"
#import "CreateTemporaryCourseViewController.h"
#import "SelectClassViewController.h"
#import "AlterView.h"
#import "DYTabBarViewController.h"
#import "ChatHelper.h"
#import "TheLoginViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface SignInViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AlterViewDelegate>
@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong) NSMutableArray * classAry;
/** @brief 当前加载的页数 */
@property (nonatomic,assign) int page;

@property (nonatomic,assign) int temp;

@property (nonatomic,strong)AlterView * alterView;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.temp = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _classAry = [NSMutableArray arrayWithCapacity:10];
    
    [self addAlterView];
    
    [self setNavigationTitle];
    
    [self addCollection];
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTheClassPage) name:@"UpdateTheClassPage" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)UpdateTheClassPage{
    [self headerRereshing];
}
-(void)viewWillAppear:(BOOL)animated{
    BOOL B = [UIUtils tokenThePeriodOfValidity];
    if (B) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"登录过期请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [[Appsetting sharedInstance] getOut];
        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
        rootVC = nil;
        ChatHelper * c =[ChatHelper shareHelper];
        [c getOut];
        TheLoginViewController * userLogin = [[TheLoginViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController =[[UINavigationController alloc] initWithRootViewController:userLogin];
    }
}
-(void)addAlterView{
    _alterView = [[AlterView alloc] initWithFrame:CGRectMake(60, 200, APPLICATION_WIDTH-120, 120) withLabelText:@"暂无课程"];
    _alterView.layer.masksToBounds = YES;
    _alterView.layer.cornerRadius = 10;
    _alterView.delegate = self;
}

-(void)addCollection{
    CollectionFlowLayout * flowLayout = [[CollectionFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH,APPLICATION_HEIGHT-48-64) collectionViewLayout:flowLayout];
    flowLayout.headerReferenceSize = CGSizeMake(0, APPLICATION_HEIGHT/4);
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册
    [_collection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collection.backgroundColor = [UIColor clearColor];
    self.collection.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    __weak SignInViewController * weakSelf = self;
    
    [self.collection addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    
    [self.collection addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    
    [self headerRereshing];
    
    [self.view addSubview:_collection];
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
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf hideHud];
                [strongSelf getDataWithPage:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.collection headerEndRefreshing];
            }else{
                [strongSelf.collection footerEndRefreshing];
            }
        }
    });
}
#pragma mark 获取数据
-(void)getDataWithPage:(NSInteger)page{
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",[UIUtils getTime],@"actStartTime",[UIUtils getMoreMonthTime],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
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
        }
        //        [_collection reloadData];
        [self getSelfJoinClass:page];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}
-(void)getSelfJoinClass:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[UIUtils getTime],@"actStartTime",[UIUtils getMoreMonthTime],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"2");
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        //        [_collection reloadData];
        [self getSelfCreateClassType:page];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}
//临时
-(void)getSelfCreateClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",[UIUtils getTime],@"actStartTime",[UIUtils getMoreMonthTime],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",@"2",@"courseType",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"3");
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        //        [_collection reloadData];
        [self getSelfJoinClassType:page];
    } failure:^(NSError *error) {
       [self hideHud];
        NSLog(@"%@",error);
    }];
}
//临时
-(void)getSelfJoinClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[UIUtils getTime],@"actStartTime",[UIUtils getMoreMonthTime],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",@"2",@"courseType",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"4");
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            [_collection reloadData];
            
        });
        
    } failure:^(NSError *error) {
        [self hideHud];
        
        NSLog(@"%@",error);
    }];
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"当天课程";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createAcourse)];
    self.navigationItem.rightBarButtonItem = myButton;
    
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.leftBarButtonItem = selection;
}
/**
 * 搜索
 **/
-(void)selectionBtnPressed{
    
    SelectClassViewController * s = [[SelectClassViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:s animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
/**
 *  创建课程
 **/
-(void)createAcourse{
    [self setAlterAction];
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
        self.hidesBottomBarWhenPushed = NO;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"创建临时性课堂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        CreateTemporaryCourseViewController * c = [[CreateTemporaryCourseViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:c animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark AlterViewDelegate
-(void)alterViewDeleageRemove{
    [_alterView removeFromSuperview];
}
#pragma mark ---- UIAlterAction
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionViewDataSource
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);//分别为上、左、下、右
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_classAry.count>0) {
        [_alterView removeFromSuperview];
        return _classAry.count;
    }else if(_classAry.count == 0) {
        [self.view addSubview:_alterView];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row<_classAry.count) {
        [cell setClassInfoForContentView:_classAry[indexPath.row]];
    }
    return cell;
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
    
    headView.backgroundColor = [UIColor redColor];
    CollectionHeadView * v = [[CollectionHeadView alloc] init];
    v.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4);
    [headView addSubview:v];
    
    return headView;
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_classAry.count) {
        self.hidesBottomBarWhenPushed = YES;
        CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
        cdetailVC.c = _classAry[indexPath.row];
        [self.navigationController pushViewController:cdetailVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_classAry.count) {
        self.hidesBottomBarWhenPushed = YES;
        CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
        cdetailVC.c = _classAry[indexPath.row];
        [self.navigationController pushViewController:cdetailVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(APPLICATION_WIDTH/2-20, Collection_height);
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
