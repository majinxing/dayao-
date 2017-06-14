//
//  DiscussViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/31.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DiscussViewController.h"
#import "DiscussListTableViewCell.h"
#import "DYHeader.h"
#import <Hyphenate/EMCursorResult.h>
#import <Hyphenate/Hyphenate.h>
#import "MJRefresh.h"
#define FetchChatroomPageSize   20

@interface DiscussViewController ()<UITableViewDelegate,UITableViewDataSource,EMChatroomManagerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * imageAry;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * dataArray;

/** @brief 当前加载的页数 */
@property (nonatomic) int page;

@end

@implementation DiscussViewController

-(void)dealloc{
    [[EMClient sharedClient].roomManager removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray arrayWithCapacity:4];
    
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];

    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _imageAry = [NSMutableArray arrayWithCapacity:1];
    [_imageAry addObject:@"group_creategroup"];
    [_imageAry addObject:@"group_joinpublicgroup"];
    [_imageAry addObject:@"group_header"];
    
    _labelAry = [NSMutableArray arrayWithCapacity:1];
    [_labelAry addObject:@"创建讨论室"];
    [_labelAry addObject:@"添加公开讨论室"];
    [_labelAry addObject:@"数学"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    __weak DiscussViewController * weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [self.tableView addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    
    [self headerRereshing];
    [self.view addSubview:_tableView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        EMError * error = nil;
        EMPageResult * result = [[EMClient sharedClient].roomManager getChatroomsFromServerWithPage:aPage pageSize:FetchChatroomPageSize error:&error];
        if (weakSelf) {
            DiscussViewController * strongDelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongDelf hideHud];
                if (!error) {
                    if (aIsHeader) {
                        NSMutableArray * oldChatrooms = [self.dataArray mutableCopy];
                        [self.dataArray removeAllObjects];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [oldChatrooms removeAllObjects];
                        });
                    }
                    [strongDelf.dataArray addObjectsFromArray:result.list];
                    [strongDelf.tableView reloadData];
                    if (aIsHeader) {
                        [strongDelf.tableView headerEndRefreshing];
                    }
                    else{
                        [strongDelf.tableView footerEndRefreshing];
                    }
                }
            });
        }
    });

}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        return 2+self.dataArray.count;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscussListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DiscussListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscussListTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    if (indexPath.row>1) {
        EMChatroom *chatroom = [self.dataArray objectAtIndex:indexPath.row-2];
        [cell setImage:_imageAry[2] withLableTitle:chatroom.subject];
    }else{
        [cell setImage:_imageAry[indexPath.row] withLableTitle:_labelAry[indexPath.row]];
;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
