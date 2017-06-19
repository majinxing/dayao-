//
//  MJXChatViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/17.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "MJXChatViewController.h"
#import "DYHeader.h"
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

@interface MJXChatViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UIView *btoView;

@property (nonatomic,strong) UITableView * tableView;
@end

@implementation MJXChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    [self keyboardNotification];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)addTableView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    [self.view addSubview:_tableView];
    
    _btoView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT-40, APPLICATION_WIDTH, 40)];
    _btoView.backgroundColor =
    _tableView.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    _btoView.layer.masksToBounds = YES;
    _btoView.layer.borderWidth = 1.f;
    _btoView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_btoView];
    
    UIButton * voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.frame = CGRectMake(0, 0, 40, 40);
    [_btoView addSubview:voice];
    UITextView * text = [[UITextView alloc] initWithFrame:CGRectMake(40, 2, APPLICATION_WIDTH-40-80, 36)];
    text.font = [UIFont systemFontOfSize:20];
    [_btoView addSubview:text];
    [_btoView addSubview:text];
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
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing: YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-40-keyBoardRect.size.height, APPLICATION_WIDTH, 40);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    _btoView.frame = CGRectMake(0, APPLICATION_HEIGHT-40, APPLICATION_WIDTH, 40);
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
