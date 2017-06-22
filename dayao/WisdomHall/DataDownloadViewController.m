//
//  DataDownloadViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/21.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DataDownloadViewController.h"
#import "DataDownloadTableViewCell.h"
#import "DYHeader.h"

@interface DataDownloadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation DataDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataDownloadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DataDownloadTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DataDownloadTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
