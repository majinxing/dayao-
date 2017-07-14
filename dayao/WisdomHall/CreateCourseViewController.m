//
//  CreateCourseViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateCourseViewController.h"
#import "DYHeader.h"
#import "DefinitionPersonalTableViewCell.h"
#import "SelectClassRoomViewController.h"
#import "ClassRoomModel.h"
#import "SelectPeopleToClassViewController.h"
#import "SignPeople.h"

@interface CreateCourseViewController ()<UITableViewDelegate,UITableViewDataSource,DefinitionPersonalTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView * tabelView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textFileAry;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign) int n;
@property (nonatomic,assign) int m1;
@property (nonatomic,assign) int m2;
@property (nonatomic,assign) int m3;
@property (nonatomic,strong) ClassRoomModel * classRoom;
@property (nonatomic,strong) NSMutableArray * selectPeopleAry;



@end

@implementation CreateCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 0;
    _m1 = 0;
    _m2 = 0;
    _m3 = 0;
    _selectPeopleAry = [NSMutableArray arrayWithCapacity:1];
    [self setNavigationTitle];
    [self addTabelView];
    [self keyboardNotification];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTabelView{
    _labelAry = [[NSMutableArray alloc] initWithObjects:@"课堂封面",@"课  程  名",@"老师姓名",@"签到方式",@"课堂总人数",@"上课的人",@"教      室", @"课程周期",@"第一周星期一日期",nil];
    _textFileAry = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<10; i++) {
        [_textFileAry addObject:@""];
    }
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    [self.view addSubview:_tabelView];
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
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
    self.title = @"创建课堂";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(createAcourse)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)createAcourse{
//    [self.navigationController popViewControllerAnimated:YES];
    NSString * sign;
    if ([_textFileAry[3] isEqualToString:@"一键签到"]) {
            sign = @"1";
    }else{
            sign= @"2";
    }
    NSString * time = [UIUtils getTime];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_textFileAry[1],@"name",_classRoom.classRoomName,@"address", _textFileAry[2],@"time",sign,@"signWay",_textFileAry[4],@"teacherId",_textFileAry[5],@"total",_classRoom.classRoomId,@"room",@"",@"userList",@"1",@"type",@"no",@"pictureId",time,@"createTime",@"0",@"status",nil];
    
    [[NetworkRequest sharedInstance] POST:CreateClass dict:dict succeed:^(id data) {
        NSLog(@"succeed:%@",data);
    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
    }];
    
    
    
}
-(void)addPickView{
    [self.view endEditing: YES];
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 150 - 30, APPLICATION_WIDTH, 150 + 30)];
        
        UIPickerView * pickerViewD = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,30,APPLICATION_WIDTH,150)];
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
}
-(void)leftButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
}
-(void)rightButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    if (_temp == 3) {
        if (_n==0) {
            [_textFileAry setObject:@"一键签到" atIndexedSubscript:3];
        }else if(_n==1){
            [_textFileAry setObject:@"头像签到" atIndexedSubscript:3];
        }
    }else if (_temp == 7){
        NSString * str1;
        NSString * str2;
        NSString * str3;
        if (_m1 == 0) {
            str1 = [NSString stringWithFormat:@"1"];
        }else if(_m1!=0){
            str1 =  [NSString stringWithFormat:@"%d",_m1];
        }
        if (_m2 == 0) {
            str2 = [NSString stringWithFormat:@"1"];
        }else if(_m2!=0){
            str2 =  [NSString stringWithFormat:@"%d",_m2];
        }
        if (_m3 == 0) {
            str3 = [NSString stringWithFormat:@"全"];
        }else if(_m3==1){
            str3 =  [NSString stringWithFormat:@"单周"];
        }else if(_m3==2){
            str3 =  [NSString stringWithFormat:@"双周"];
        }
        [_textFileAry setObject:[NSString stringWithFormat:@"%@周-%@周-%@上课",str1,str2,str3] atIndexedSubscript:7];
    }
    
    [_tabelView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIPickViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_temp==3) {
        return 1;
    }else if (_temp==7){
        return 3;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_temp == 3) {
        return 2;
    }else if (_temp == 7){
        if (component == 0||component == 1) {
            return 25;
        }else if(component == 2){
            return 3;
        }
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_temp == 3) {
        
        if (row==0) {
            return @"一键签到";
        }else if(row==1){
            return @"照片签到";
        }
    }else if (_temp == 7){
        if (component == 0||component == 1) {
            return [NSString stringWithFormat:@"%ld",row+1];
        }else if (component == 2){
            if (row == 0) {
                return @"全";
            }else if (row == 1){
                return @"单周";
            }else if (row == 2){
                return @"双周";
            }
        }
    }
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_temp == 3) {
        if (row == 1) {
            _n = 1;
        }else{
            _n = 0;
        }
    }else if (_temp == 7){
        if (component == 0) {
            _m1 = (int) row;
        }else if (component == 1){
            _m2 = (int)row;
        }else if (component == 2){
            _m3 = (int)row;
        }
    }
    
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tabelView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tabelView.contentInset = UIEdgeInsetsZero;
}
#pragma mark DefinitionPersonalTableViewCellDelegate
-(void)textFileDidChangeForDPTableViewCellDelegate:(UITextField *)textFile{
    [_textFileAry setObject:textFile.text atIndexedSubscript:textFile.tag];
};
-(void)textFieldDidBeginEditingDPTableViewCellDelegate:(UITextField *)textFile{
    
}
-(void)gggDelegate:(UIButton *)btn{
    if (btn.tag == 3) {
        _temp = 3;
        [self addPickView];
    }else if (btn.tag == 6){
        [self.view endEditing: YES];
        SelectClassRoomViewController * s = [[SelectClassRoomViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];
        [s returnText:^(ClassRoomModel *returnText) {
            if (returnText) {
                [self.view endEditing:YES];
                if (![UIUtils isBlankString:returnText.classRoomId]) {
                    _classRoom = returnText;
                    [_textFileAry setObject:_classRoom.classRoomName atIndexedSubscript:6];
                    [_tabelView reloadData];
                }
            }
        }];
    }else if (btn.tag == 5){
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
                [_tabelView reloadData];
            }
            
        }];
    }else if (btn.tag == 7){
        _temp = 7;
        [self addPickView];
    }
    
}


#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DefinitionPersonalTableViewCell * cell ;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellSecond"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellFirst"];
    }
    
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:1];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
    }
    [cell addCourseContentView:_labelAry[indexPath.row] withTextFileText:_textFileAry[indexPath.row] withIndex:(int)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }
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
