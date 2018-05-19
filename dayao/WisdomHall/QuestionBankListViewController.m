//
//  QuestionBankListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/17.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "QuestionBankListViewController.h"
#import "DYHeader.h"
#import "QuestionBank.h"

@interface QuestionBankListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation QuestionBankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, 300) style:UITableViewStylePlain];
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
    return _bankListAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    QuestionBank * q = _bankListAry[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"题库：%@",q.libName];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionBank * q = _bankListAry[indexPath.row];

    [self returnBankModel:q];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark QuestionBankListViewControllerDelegate
-(void)returnBankModel:(QuestionBank *)q{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(returnBankModelDelegate:)]) {
        [self.delegate returnBankModelDelegate:q];
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
