//
//  NoticeViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "DYHeader.h"
#import "FMDBTool.h"
#import "NoticeModel.h"
#import "DYTabBarViewController.h"
#import "ChatHelper.h"

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)FMDatabase * db;
@property (nonatomic,strong)NSMutableArray * noticeAry;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeAry = [NSMutableArray arrayWithCapacity:1];
    
    [self selectFMDBTable];
    
    [self addTableView];
    
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
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
    self.title = @"个人资料";
   UIBarButtonItem * myButton = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = myButton;
}
-(void)back{
    if ([_backType isEqualToString:@"TabBar"]) {
        
        ChatHelper * c =[ChatHelper shareHelper];
        
        DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)selectFMDBTable{
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@",NOTICE_TABLE_NAME];
        FMResultSet * rs = [FMDBTool queryWithDB:_db withSqlStr:sql];
        while (rs.next) {
            NoticeModel * notice = [[NoticeModel alloc] init];
            notice.noticeTime = [rs stringForColumn:@"noticeTime"];
            notice.noticeContent = [rs stringForColumn:@"noticeContent"];
            [_noticeAry addObject:notice];
        }
        if (_noticeAry.count>0) {
            
        }else{
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"暂无通知" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }
        [_tableView reloadData];
    }
    [_db close];
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
    if (_noticeAry.count>0) {
        return _noticeAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    if ((_noticeAry.count-indexPath.row-1)<_noticeAry.count) {
        NoticeModel * notice = _noticeAry[_noticeAry.count-indexPath.row-1];
        [cell setContentView:notice.noticeTime withNoticContent:notice.noticeContent];
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}
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
