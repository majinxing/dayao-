//
//  WorkingLoginViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "WorkingLoginViewController.h"
#import "TheLoginViewController.h"
#import "DYHeader.h"
#import "BindPhone.h"
#import "ChatHelper.h"
#import "DYTabBarViewController.h"
#import "JSMSConstant.h"
#import "JSMSSDK.h"
#import "RegisterViewController.h"

@interface WorkingLoginViewController ()<BindPhoneDelegate>
@property (strong, nonatomic) IBOutlet UITextField *workNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (nonatomic,strong)BindPhone * bindPhone;
@property (nonatomic,copy)NSString * phone;
@end

@implementation WorkingLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _password.secureTextEntry = YES;
    
    //    [_workNumber setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //
    //    [_password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    _workNumber.text = user.studentId;
    
    _password.text = user.userPassword;
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    [self showHudInView:self.view hint:NSLocalizedString(@"正在登陆请稍后……", @"Load data...")];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"500",@"universityId",_workNumber.text,@"loginStr",_password.text,@"password", nil];
    [[NetworkRequest sharedInstance] POST:Login dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSString * ss = [[data objectForKey:@"body"] objectForKey:@"bind"];
            if ([ss isEqualToString:@"true"]) {
                RegisterViewController * r = [[RegisterViewController alloc] init];
                r.type = @"bindPhone";
                r.workNo = _workNumber.text;
                r.password = _password.text;
                [self.navigationController pushViewController:r animated:YES];
            }else{
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                dict = [data objectForKey:@"body"];
                NSString * type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                if ([type isEqualToString:@"2"]) {
                    [UIUtils showInfoMessage:@"您登陆的是学生身份,本客户端只服务于老师，请登录“律动课堂”"];
                }else{
                    [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:_password.text];
                    
                    ChatHelper * c =[ChatHelper shareHelper];
                    
                    DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                }
                [self hideHud];
            }
        }else if ([str isEqualToString:@"1014"]){
            [UIUtils showInfoMessage:@"用户名或密码错误"];
        }else if ([str isEqualToString:@"9999"]){
            [UIUtils showInfoMessage:@"网络错误或者其他不可知错误"];
        }else{
            [UIUtils showInfoMessage:@"登录失败"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"登陆失败，请检查网络"];
        [self hideHud];
    }];
}
- (IBAction)phoneLogin:(id)sender {
    TheLoginViewController * login = [[TheLoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
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
