//
//  CreateMeetingViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/11.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateMeetingViewController.h"
#import "DYHeader.h"
#import "DefinitionPersonalTableViewCell.h"
#import "QueryMeetingRoomViewController.h"
#import "SelectPeopleToClassViewController.h"
#import "SignPeople.h"
#import "MeetingChooseSeatViewController.h"

@interface CreateMeetingViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,DefinitionPersonalTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textFileAry;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,strong) NSMutableArray * selectPeopleAry;
@property (nonatomic,strong)SeatIngModel * seat;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign)int year;
@property (nonatomic,assign)int month;
@property (nonatomic,assign)int day;
@property (nonatomic,assign)int n;
@end

@implementation CreateMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _year = 0;
    
    _month = 0;
    
    _day = 0;
    
    _n = 0;
    
    _selectPeopleAry = [NSMutableArray arrayWithCapacity:1];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
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
    self.title = @"创建会议";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveMeeting)];
    self.navigationItem.rightBarButtonItem = myButton;
    
    //    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    //    self.navigationItem.leftBarButtonItem = selection;
}
-(void)saveMeeting{
    
}
-(void)addTableView{
    _labelAry = [[NSArray alloc] initWithObjects:@"会议主题",@"会议时间",@"会议室",@"签到方式",@"参加人员",@"座次安排", nil];//2
    _textFileAry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<6; i++) {
        [_textFileAry addObject:@""];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)addPickView{
    [self.view endEditing: YES];
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 200 - 30, APPLICATION_WIDTH, 200 + 30)];
        
        UIPickerView * pickerViewD = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,30,APPLICATION_WIDTH,200)];
        pickerViewD.backgroundColor=[UIColor whiteColor];
        pickerViewD.delegate = self;
        pickerViewD.dataSource =  self;
        pickerViewD.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor=[UIColor whiteColor];
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 50, 30);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(APPLICATION_WIDTH - 50, 0, 50, 30);
        [rightButton setTitle:@"确认" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:rightButton];
        [self.pickerView addSubview:pickerViewD];
    }
    [self.view addSubview:_bView];
    [self.view addSubview:self.pickerView];
}
-(void)outView{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}
-(void)leftButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}
-(void)rightButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    if (_temp == 1) {
        
        [_textFileAry setObject:[NSString stringWithFormat:@"%d-%d-%d",_year+2017,_month+1,_day+1] atIndexedSubscript:1];
        
        _year = 0;
        _month = 0;
        _day = 0;
        [_tableView reloadData];
    }else if (_temp == 3){
        if (_n == 0) {
            [_textFileAry setObject:@"一键签到" atIndexedSubscript:3];
        }else{
            [_textFileAry setObject:@"照片签到" atIndexedSubscript:3];
        }
        _n = 0;
        [_tableView reloadData];
    }
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
#pragma mark UIPickView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_temp == 1) {
        return 3;
    }else if (_temp == 3){
        return 1;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_temp == 1) {
        if (component == 0) {
            return 3;
        }else if (component == 1){
            return 12;
        }else if (component == 2){
            return 31;
        }
    }else if (_temp == 3){
        return 2;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_temp == 1) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%ld",2017+row];
        }else if (component == 1){
            return [NSString stringWithFormat:@"%ld月",1+row];
        }else if (component == 2){
            return [NSString stringWithFormat:@"%ld日",1+row];
        }
    }else if (_temp == 3){
        if (row == 0) {
            return @"一键签到";
        }else if (row == 1){
            return @"照片签到";
        }
    }
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_temp == 1) {
        if (component == 0) {
            _year = (int)row;
        }else if (component == 1){
            _month = (int)row;
        }else if (component == 2){
            _day = (int)row;
        }
    }else if (_temp == 3){
        _n = (int)row;
    }
}
#pragma mark DefinitionPersonalTableViewCellDelegate
-(void)gggDelegate:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        _temp = 1;
        [self addPickView];
    }else if (btn.tag == 2){
        QueryMeetingRoomViewController * q = [[QueryMeetingRoomViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:q animated:YES];
        
        [q returnText:^(SeatIngModel *returnText) {
            
            if (returnText) {
                if (![UIUtils isBlankString:returnText.seatTableNamel]) {
                    
                    [_textFileAry setObject:returnText.seatTableNamel atIndexedSubscript:2];
                    
                    _seat = returnText;
                    
                    if (![UIUtils isBlankString:_textFileAry[4]]) {
                        int allpeople = 0;
                        for (int i = 0; i<_seat.seatColumn.count; i++) {
                            allpeople = [_seat.seatColumn[i] intValue]+allpeople;
                        }
                        if (_selectPeopleAry.count>allpeople) {
                            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"会议室座次不够" message:@"您选择的会议室的座位数少于参加会议的人数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alter show];
                        }
                    }
                    
                    [_tableView reloadData];
                }
            }
        }];
    }else if (btn.tag == 3){
        _temp = 3;
        [self addPickView];
    }else if (btn.tag == 4){
        SelectPeopleToClassViewController * s = [[SelectPeopleToClassViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];
        
        [s returnText:^(NSMutableArray *returnText) {
            for (int i = 0; i<returnText.count; i++) {
                SignPeople * s = returnText[i];
                int n = 0;
                for (int j = 0; j<_selectPeopleAry.count; j++) {
                    SignPeople * sp = _selectPeopleAry[j];
                    if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sp.userId]]) {
                        n = 1;
                        break;
                    }
                }
                if (n == 0) {
                    [_selectPeopleAry addObject:s];
                }
            }
            if (_selectPeopleAry.count>0) {
                
                [_textFileAry setObject:[NSString stringWithFormat:@"已选择%ld人",_selectPeopleAry.count] atIndexedSubscript:btn.tag];
                
                if (![UIUtils isBlankString:_textFileAry[2]]) {
                    int allpeople = 0;
                    for (int i = 0; i<_seat.seatColumn.count; i++) {
                        allpeople = [_seat.seatColumn[i] intValue]+allpeople;
                    }
                    if (_selectPeopleAry.count>allpeople) {
                        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"会议室座次不够" message:@"您选择的会议室的座位数少于参加会议的人数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alter show];
                    }
                }

                [_tableView reloadData];
            }
            
        }];
    }else if (btn.tag == 5){
        if ([UIUtils isBlankString:_seat.seatTable]) {
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择会议室" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }else if ([UIUtils isBlankString:_textFileAry[4]]){
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择参加会议的人员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }else{
            MeetingChooseSeatViewController * z = [[MeetingChooseSeatViewController alloc] init];
            z.seatTable = _seat.seatTable;
            //        z.seat = _meetingModel.userSeat;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:z animated:YES];
        }
    }
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DefinitionPersonalTableViewCell * cell ;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellFirst"];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell addMeetingContentView:_labelAry[indexPath.row] withTextFileText:_textFileAry[indexPath.row] withIndex:(int)indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
