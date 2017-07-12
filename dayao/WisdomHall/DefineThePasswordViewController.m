//
//  DefineThePasswordViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "DefineThePasswordViewController.h"
#import "DYTabBarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "DefinitionPersonalTableViewCell.h"
#import "SelectSchoolViewController.h"
#import "SchoolModel.h"
#import "DYHeader.h"
#import "TheLoginViewController.h"
@interface DefineThePasswordViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,DefinitionPersonalTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *uploadImageButton;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textFileAry;
@property (nonatomic,strong)SchoolModel * s;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign) int n;

@end

@implementation DefineThePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    self.title = @"创建用户";
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnPressed)];
    self.navigationItem.rightBarButtonItem = selection;
}
-(void)saveBtnPressed{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSArray * ary = [[NSArray alloc] initWithObjects:@"name",@"password",@"p",@"universityId",@"type",@"workNo",@"facultyId",@"majorId",@"classId",nil];
    for (int i = 0 ; i<ary.count; i++) {
        if ([_textFileAry[i] isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请填写完整" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }else if (i == 2){
            [dict setObject:_phoneNumber forKey:@"phone"];
        }else if(i == 3){
            [dict setObject:_s.schoolId forKey:@"universityId"];
        }else if (i == 4){
            [dict setObject:[NSString stringWithFormat:@"%d",_n] forKey:@"type"];
        }else if(i == 6){
            [dict setObject:[NSString stringWithFormat:@"%@",_s.departmentId] forKey:@"facultyId"];
        }else if (i == 7){
            [dict setObject:[NSString stringWithFormat:@"%@",_s.majorId] forKey:@"majorId"];
        }else if (i == 8){
            [dict setObject:[NSString stringWithFormat:@"%@",_s.sclassId] forKey:@"classId"];
        } else{
            [dict setObject:_textFileAry[i] forKey:ary[i]];
        }
    }
    [dict setObject:@"111111" forKey:@"imPswd"];
    
    [[NetworkRequest sharedInstance] POST:Register dict:dict succeed:^(id data) {
        NSLog(@"succeed:%@",data);
        if ([[[data objectForKey:@"header"] objectForKey:@"code"] isEqualToString:@"0000"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[TheLoginViewController class]]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册成功请登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败：%@",error);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)addTableView{
    _labelAry = [[NSMutableArray alloc] initWithObjects:@"用  户  名",@"密      码",@"确认密码",@"学      校",@"身      份",@"工号/学号",@"院      系",@"专      业",@"班      级", nil];
    _textFileAry = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0 ; i<10; i++) {
        [_textFileAry addObject:@""];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorColor:[UIColor colorWithHexString:@"#bfbfbf"]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_tableView];
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
    [self.view endEditing:YES];
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
    if (_n==0) {
        [_textFileAry setObject:@"老师" atIndexedSubscript:4];
    }else if(_n==1){
        [_textFileAry setObject:@"学生" atIndexedSubscript:4];
    }
    [_tableView reloadData];
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
#pragma mark pick

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_temp==4) {
        return 1;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_temp == 4) {
        return 2;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_temp == 4) {
        
        if (row==0) {
            return @"老师";
        }else if(row==1){
            return @"学生";
        }
    }
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_temp == 4) {
        if (row == 1) {
            _n = 1;
        }else{
            _n = 0;
        }
    }
    
}

#pragma mark UITextFileDelegae DefinitionPersonalTableViewCellDelegate
-(void)gggDelegate:(UIButton *)btn{
    _temp = 4;
    [self addPickView];
    [self.view endEditing:YES];
}
-(void)textFileDidChangeForDPTableViewCellDelegate:(UITextField *)textFile{
    [_textFileAry setObject:textFile.text atIndexedSubscript:textFile.tag];
}
-(void)textFieldDidBeginEditingDPTableViewCellDelegate:(UITextField *)textFile{
    if (textFile.tag == 3) {
        [textFile endEditing:YES];
        SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
        s.selectType = SelectSchool;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];
        [s returnText:^(SchoolModel *returnText) {
            if (returnText) {
                [self.view endEditing:YES];
                if (![UIUtils isBlankString:returnText.schoolId]) {
                    _s = returnText;
                    [_textFileAry setObject:_s.schoolName atIndexedSubscript:textFile.tag];
                    [_tableView reloadData];
                }
                
            }
        }];
    }else if (textFile.tag == 6){
        if ([UIUtils isBlankString:_s.schoolId]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择学校" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else{
            [textFile endEditing:YES];
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectDepartment;
            s.s = [[SchoolModel alloc] init];
            s.s.schoolId = _s.schoolId;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if (![UIUtils isBlankString:returnText.departmentId]) {
                        _s.department = returnText.department;
                        _s.departmentId = returnText.departmentId;
                        [_textFileAry setObject:_s.department atIndexedSubscript:textFile.tag];
                        [_tableView reloadData];
                    }
                }
            }];
        }
    }else if (textFile.tag == 7){
        if ([UIUtils isBlankString:_s.departmentId]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择院系" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else{
            [textFile endEditing:YES];
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectMajor;
            s.s = [[SchoolModel alloc] init];
            s.s.departmentId = _s.departmentId;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if (![UIUtils isBlankString:returnText.major]) {
                        _s.major = returnText.major;
                        _s.majorId = returnText.majorId;
                        [_textFileAry setObject:_s.major atIndexedSubscript:textFile.tag];
                        [_tableView reloadData];
                    }
                }
            }];
        }
        
    }else if (textFile.tag == 8){
        if ([UIUtils isBlankString:_s.departmentId]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择专业" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else{
            [textFile endEditing:YES];
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectClass;
            s.s = [[SchoolModel alloc] init];
            s.s.majorId = _s.majorId;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if (![UIUtils isBlankString:returnText.sclassId]) {
                        _s.sclass = returnText.sclass;
                        _s.sclassId = returnText.sclassId;
                        [_textFileAry setObject:_s.sclass atIndexedSubscript:textFile.tag];
                        [_tableView reloadData];
                    }
                }
            }];
        }
        
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
    DefinitionPersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell addContentView:_labelAry[indexPath.row] withTextFileText:_textFileAry[indexPath.row] withIndex:(int)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
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
