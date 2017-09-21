//
//  TheLoginViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TheLoginViewController.h"
#import "DYHeader.h"
#import "DYTabBarViewController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "NetworkRequest.h"
#import "ChatHelper.h"

@interface TheLoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *personalAccount;
@property (strong, nonatomic) IBOutlet UITextField *personalPassword;
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;


@end

@implementation TheLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//secureTextEntry
    _personalPassword.secureTextEntry = YES;
    [_personalAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_personalPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_personalAccount setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_personalPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    _personalAccount.text = user.userPhone;
    _personalPassword.text = user.userPassword;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
- (IBAction)LoginButtonPressed:(id)sender {
    //15243670131
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载", @"Load data...")];
    if ([UIUtils isSimplePhone:_personalAccount.text]) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_personalAccount.text,@"phone",_personalPassword.text,@"password", nil];
        NSString * str = _personalPassword.text;
        [[NetworkRequest sharedInstance] POST:Login dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSDictionary * d = [data objectForKey:@"header"];
            if ([[d objectForKey:@"code"] isEqualToString:@"0000"]) {
                [self hideHud];

                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                dict = [data objectForKey:@"body"];
                
                [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:str];
                
                ChatHelper * c =[ChatHelper shareHelper];

                DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                
                
            }else{
                [self hideHud];

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            
        } failure:^(NSError *error) {
            [self hideHud];

            NSLog(@"%@",error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器连接失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }];
    }else{
        [self hideHud];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}
/**
 * 注册
 **/
- (IBAction)registeredButtonPressed:(id)sender {
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"取消";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
/**
 * 忘记密码
 **/
- (IBAction)forgotPasswordPressed:(id)sender {
    ForgotPasswordViewController * forgetVC = [[ForgotPasswordViewController alloc] init];
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    // 方式二
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFileDelegate
-(void)textFieldDidChange:(UITextField *)textFile{
    
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
