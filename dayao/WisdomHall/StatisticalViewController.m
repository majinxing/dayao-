//
//  StatisticalViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalViewController.h"
#import "DYHeader.h"
#import "StatisticalTableViewCell.h"
#import "SelectSchoolViewController.h"
#import "StatisticalModel.h"
#import "CalendarViewController.h"
#import "StatisticalResultModel.h"
#import "StatisticalResultViewController.h"

@interface StatisticalViewController ()<UITableViewDelegate,UITableViewDataSource,StatisticalTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * titleAry;
@property (nonatomic,strong)NSMutableArray * textAry;
@property (nonatomic,strong)StatisticalModel * statistl;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign) int temp;
@property (nonatomic,strong)NSMutableArray * statisticalAry;
@end

@implementation StatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA_COLOR(231, 231, 231, 1);
    
    [self setNavigationTitle];
    
    [self setTableView];
    
    _statistl = [[StatisticalModel alloc] init];
    
    _titleAry = @[@[@"选择院系",@"选择专业(选填)",@"选择班级(选填)"],
                  @[@"开始时间",@"结束时间"],
                  @[@"结果形式"]];
    
    _textAry = [[NSMutableArray alloc] init];
    
    _statisticalAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int j = 0; j<3; j++) {
        NSMutableArray * ary = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
        [_textAry addObject:ary];
    }
    _textAry[1][0] = [UIUtils getTime];
    
    _textAry[1][1] = [UIUtils getTime];
    
    _statistl.endTime = [UIUtils getTime];
    
    _statistl.startTime = [UIUtils getTime];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    _textAry[0][0] = user.departmentsName;
    
    _statistl.departments = [NSString stringWithFormat:@"%@",user.departments];
    
    _temp = 0;
    
    _textAry[2][0] = @"按部门";
    // Do any additional setup after loading the view from its nib.
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
-(void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
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
    self.title = @"统计";
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
    if (_temp == 0) {
        _textAry[2][0] = @"按部门";
    }else if (_temp == 1){
        _textAry[2][0] = @"按课程";
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark StatisticalTableViewCellDelegate
-(void)selectBtnPressedDelegate:(UIButton *)btn{
    if ([_statistl statisticalModelIsNil]) {
        NSMutableDictionary * dict = [_statistl returnDict];
        if (_temp==0) {
            [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
            
            [[NetworkRequest sharedInstance] POST:QuertyStatistics dict:dict succeed:^(id data) {
                NSLog(@"%@",data);
                
                NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
                [_statisticalAry removeAllObjects];
                for (int i = 0; i<ary.count; i++) {
                    StatisticalResultModel * s = [[StatisticalResultModel alloc] init];
                    [s setValueWithDict:ary[i]];
                    [_statisticalAry addObject:s];
                }
                StatisticalResultViewController * vc = [[StatisticalResultViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                vc.statisticalResultAry = _statisticalAry;
                [self.navigationController pushViewController:vc animated:YES];
                [self hideHud];
            } failure:^(NSError *error) {
                [self hideHud];

                [UIUtils showInfoMessage:@"请检查网络状态"];
            }];
        }else if(_temp == 1){
            [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];

            [[NetworkRequest sharedInstance] POST:QuertyClass dict:dict succeed:^(id data) {
                [self hideHud];

                NSArray * ary = [data objectForKey:@"body"];
                [_statisticalAry removeAllObjects];
                for (int i = 0; i<ary.count; i++) {
                    StatisticalResultModel * s = [[StatisticalResultModel alloc] init];
                    [s setValueWithDict:ary[i]];
                    [_statisticalAry addObject:s];
                }
                StatisticalResultViewController * vc = [[StatisticalResultViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                vc.statisticalResultAry = _statisticalAry;
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(NSError *error) {
                [self hideHud];
                [UIUtils showInfoMessage:@"请检查网络状态"];
            }];
        }else{
            [UIUtils showInfoMessage:@"请选择查询结果形式"];
        }
    }else{
        [UIUtils showInfoMessage:@"请把信息填写完整"];
    }
}
#pragma mark pick

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0) {
        return @"按部门";
    }else if(row==1){
        return @"按课程";
    }
    
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row==0) {
        _temp = 0;
    }else if (row == 1){
        _temp = 1;
    }
 
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatisticalTableViewCell * cell;
    
    if (indexPath.section == 2&&indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell addContentView:_titleAry[indexPath.section][indexPath.row] withText:_textAry[indexPath.section][indexPath.row]];
    }
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCell:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==2&&indexPath.row==1) {
        return 120;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 20)];
    view.backgroundColor = RGBA_COLOR(236, 236, 236, 1);
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    l.font = [UIFont systemFontOfSize:14];
    [view addSubview:l];
    
    if (section == 0) {
        
        l.text = @"部门";
        return view;
    }else if(section == 1){
        
        l.text = @"时间段";
        return view;
    }
    return nil;
}
-(void)selectTableViewCell:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
        s.selectType = SelectDepartment;
        s.s = [[SchoolModel alloc] init];
        s.s.schoolId = @"500";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];
        [s returnText:^(SchoolModel *returnText) {
            if (returnText) {
                [self.view endEditing:YES];
                if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",returnText.departmentId]]) {
                    //                    _s.department = returnText.department;
                    //                    _s.departmentId = returnText.departmentId;
                    //                    [_textFileAry setObject:_s.department atIndexedSubscript:btn.tag];
                    _statistl.departments = [NSString stringWithFormat:@"%@",returnText.departmentId];
                    _textAry[0][0] = returnText.department;
                    [_tableView reloadData];
                }
            }
        }];
    }else if (indexPath.section == 0&&indexPath.row ==1){
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",_statistl.departments]]) {
            [UIUtils showInfoMessage:@"请先选择院系"];
        }else{
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectMajor;
            s.s = [[SchoolModel alloc] init];
            s.s.departmentId = _statistl.departments;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if (![UIUtils isBlankString:returnText.major]) {
                        _statistl.professional = [NSString stringWithFormat:@"%@",returnText.majorId];
                        _textAry[0][1] = returnText.major;
                        [_tableView reloadData];
                    }
                }
            }];
        }
    }else if (indexPath.section == 0&&indexPath.row == 2){
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",_statistl.professional]]) {
            [UIUtils showInfoMessage:@"请先选择专业"];
        }else{
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectClass;
            s.s = [[SchoolModel alloc] init];
            s.s.majorId = _statistl.professional;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",returnText.sclassId]]) {
                        _statistl.theClass = [NSString stringWithFormat:@"%@",returnText.sclassId];
                        _textAry[0][2] = returnText.sclass;
                        [_tableView reloadData];
                    }
                }
            }];
        }
    }else if (indexPath.section==1&&indexPath.row==0){
        CalendarViewController * vc = [[CalendarViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc returnText:^(NSString *str) {
            if (![UIUtils isBlankString:str]) {
                _textAry[1][0] = str;
                _statistl.startTime = str;
                [_tableView reloadData];
            }
        }];
    }else if (indexPath.section==1&&indexPath.row==1){
        CalendarViewController * vc = [[CalendarViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc returnText:^(NSString *str) {
            if (![UIUtils isBlankString:str]) {
                _textAry[1][1] = str;
                _statistl.endTime = str;
                [_tableView reloadData];
            }
        }];
    }else if (indexPath.section==2&&indexPath.row==0){
        [self addPickView];
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
