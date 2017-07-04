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

static NSString *cellIdentifier = @"cellIdentifier";

@interface SignInViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong)NSMutableArray * classAry;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _classAry = [NSMutableArray arrayWithCapacity:4];
    
    [self setNavigationTitle];
    
    [self getData];
    
    [self addCollection];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addCollection{
    CollectionFlowLayout * flowLayout = [[CollectionFlowLayout alloc] init];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH,APPLICATION_HEIGHT-48) collectionViewLayout:flowLayout];
    flowLayout.headerReferenceSize = CGSizeMake(0, APPLICATION_HEIGHT/4);
    
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
    [self.view addSubview:_collection];
}
-(void)getData{
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_userModel.peopleId,@"teacherId",[UIUtils getTime],@"startTime",[UIUtils getTime],@"endTime",@"10000",@"page",nil];
    [[NetworkRequest sharedInstance] POST:QueryCourse dict:dict succeed:^(id data) {
//        NSLog(@"succeed %@",data);
        NSDictionary * dict = [data objectForKey:@"body"];
        NSArray * ary = [dict objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            ClassModel * classRoom = [[ClassModel alloc] init];
            [classRoom setInfoWithDict:ary[i]];
            [_classAry addObject:classRoom];
        }
        [_collection reloadData];
    } failure:^(NSError *error) {
        NSLog(@"失败%@",error);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    // [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    self.title = @"课堂";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createAcourse)];
    self.navigationItem.rightBarButtonItem = myButton;
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.leftBarButtonItem = selection;
}
/**
 * 搜索
 **/
-(void)selectionBtnPressed{

}
/**
 *  创建课程
 **/
-(void)createAcourse{
    CreateCourseViewController * cCourseVC = [[CreateCourseViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    //    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController pushViewController:cCourseVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
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
        return _classAry.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setClassInfoForContentView:_classAry[indexPath.row]];
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
    self.hidesBottomBarWhenPushed = YES;
    CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
    [self.navigationController pushViewController:cdetailVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
    [self.navigationController pushViewController:cdetailVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
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
