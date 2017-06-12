//
//  CreateVoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateVoteViewController.h"
#import "DYHeader.h"
#import "CreateVoteTableViewCell.h"
#import "VoteModel.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface CreateVoteViewController ()<UITableViewDataSource,UITableViewDelegate,CreateVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)VoteModel * voteModel;
@property (nonatomic,strong)NSMutableArray * labeAry;
@property (nonatomic,assign)int rowNumber;
@end

@implementation CreateVoteViewController

-(void)dealloc{
     NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
    [self addInfo];
    
    [self addSelect];
    
    [self keyboardNotification];
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
    self.title = @"投票";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveVote)];
    self.navigationItem.rightBarButtonItem = myButton;
//    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backbtn;
}
-(void)saveVote{
    
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)addInfo{
    _voteModel = [[VoteModel alloc] init];
    
    _labeAry = [NSMutableArray arrayWithCapacity:4];
    
    [_labeAry addObject:@"请输入主题"];
    
    [_labeAry addObject:@"请输入描述"];
    
    _rowNumber = 3;
}
-(void)addSelect{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50);
    [btn addTarget:self action:@selector(addSelects:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = RGBA_COLOR(63,187,168, 1);
    [btn setTitle:@"添加选项" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}
-(void)addSelects:(UIButton *)btn{
    _rowNumber = _rowNumber +1;
    [_voteModel.selectAry addObject:@""];
    [_tableView reloadData];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_rowNumber>0) {
        return _rowNumber;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateVoteTableViewCell * cell;
    if (indexPath.row == 2) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellSecond"];
    }else{
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellFirst"];
    }
    if (!cell) {
        if (indexPath.row == 2) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell addTableTextWithTextFile:_labeAry[indexPath.row] with:_voteModel.title withTag:(int)indexPath.row];
    }else if(indexPath.row == 1){
        [cell addTableTextWithTextFile:_labeAry[indexPath.row] with:_voteModel.describe withTag:(int)indexPath.row];
    }else if (indexPath.row == 2){
        [cell addSelectNumeberWithNumer:_voteModel.largestNumbe withTag:(int)indexPath.row];
    }else if (indexPath.row>2){
        [cell addTableTextWithTextFile:@"输入选项内容" with:_voteModel.selectAry[indexPath.row-3] withTag:(int)indexPath.row];
    }
    cell.delegate = self;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark textFileTextChangeDelegate
-(void)textFileTextChangeDelegate:(UITextView *)textFile{
    NSLog(@"%ld",textFile.tag);
    [_voteModel changeText:textFile];
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
