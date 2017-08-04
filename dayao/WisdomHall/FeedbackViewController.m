//
//  FeedbackViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedBackTableViewCell.h"
#import "DYHeader.h"
#import "sys/utsname.h"


@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,FeedBackTableViewCellDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textAry;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self setNavigationTitle];
    [self addTableView];
    _labelAry = [NSMutableArray arrayWithCapacity:1];
    [_labelAry addObject:@"请输入您的qq或者微信号以便我们联系:"];
    [_labelAry addObject:@"反馈意见:"];
    _textAry = [NSMutableArray arrayWithCapacity:1];
    [_textAry addObject:@""];
    [_textAry addObject:@""];
    
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
    self.title = @"意见反馈";
    UIBarButtonItem * myButton = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)saveInfo{
  //  [self.view endEditing:YES];

    for (int i = 0; i<_textAry.count; i++) {
        if ([UIUtils isBlankString:_textAry[i]]) {
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请把信息填写完整在提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }
    //手机型号
    NSString * phoneModel =  [self deviceVersion];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_textAry[0]],@"contact",[NSString stringWithFormat:@"%@",_textAry[1]],@"describe",phoneModel,@"phoneModels",app_build,@"version",user.peopleId,@"userId",nil];
    
    [[NetworkRequest sharedInstance] POST:FeedBack dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    　return deviceString;
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FeedBackTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedBackTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell addContentView:_labelAry[indexPath.row] withTextFiled:_textAry[indexPath.row] withIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark FeedBackTableViewCellDelegate
-(void)feedBackCellDelegateTextViewChange:(UITextView *)textFile{
    [_textAry setObject:textFile.text atIndexedSubscript:textFile.tag];
    //    [_tableView reloadData];
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