//
//  AllTheMeetingViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AllTheMeetingViewController.h"
#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "MJRefresh.h"
#import "SelectMeetingOrClassViewController.h"

static NSString * cellIdentifier = @"cellIdentifier";

@interface AllTheMeetingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) NSMutableArray * meetingModelAry;
@property (nonatomic,strong) UserModel * userModel;
/** @brief 当前加载的页数 */
@property (nonatomic) int page;
@end

@implementation AllTheMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _meetingModelAry = [NSMutableArray arrayWithCapacity:12];
    
    [self setNavigationTitle];
    
    [self addCollection];
    // Do any additional setup after loading the view from its nib.
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
    self.title = @"会议";
    
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.leftBarButtonItem = selection;
    
};
-(void)selectionBtnPressed{
    SelectMeetingOrClassViewController * s = [[SelectMeetingOrClassViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:s animated:YES];
}
/**
 * 添加collection
 **/
-(void)addCollection{
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64,APPLICATION_WIDTH,APPLICATION_HEIGHT-64-48) collectionViewLayout:[[CollectionFlowLayout alloc] init]];
    //注册
    [_collection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collection.backgroundColor = [UIColor clearColor];
    __weak AllTheMeetingViewController * weakSelf = self;
    [self.collection addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [self.collection addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    
    [self headerRereshing];
    [self.view addSubview:_collection];
}
#pragma mrak MJR
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
            AllTheMeetingViewController * strongSelf = weakSelf;
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
-(void)getDataWithPage:(NSInteger)page{
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"teacherId",@"1990-01-01",@"startTime",@"3000-01-01",@"endTime",[NSString stringWithFormat:@"%ld",(long)page],@"pageNo",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeeting dict:dict succeed:^(id data) {
        NSDictionary * dict = [data objectForKey:@"header"];
        if ([[dict objectForKey:@"code"] isEqualToString:@"0000"]) {
            [_meetingModelAry removeAllObjects];
            NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<d.count; i++) {
                MeetingModel * m = [[MeetingModel alloc] init];
                [m setMeetingInfoWithDict:d[i]];
                [_meetingModelAry addObject:m];
            }
            [_collection reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
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
    if (_meetingModelAry.count>0) {
        return _meetingModelAry.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setInfoForContentView:_meetingModelAry[indexPath.row]];
    return cell;
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TheMeetingInfoViewController * mInfo = [[TheMeetingInfoViewController alloc] init];
    mInfo.hidesBottomBarWhenPushed = YES;
    mInfo.meetingModel = _meetingModelAry[indexPath.row];
    [self.navigationController pushViewController:mInfo animated:YES];
     self.hidesBottomBarWhenPushed=NO;
    
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TheMeetingInfoViewController * mInfo = [[TheMeetingInfoViewController alloc] init];
    mInfo.hidesBottomBarWhenPushed = YES;
    mInfo.meetingModel = _meetingModelAry[indexPath.row];
    [self.navigationController pushViewController:mInfo animated:YES];
     self.hidesBottomBarWhenPushed=NO;
    
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
