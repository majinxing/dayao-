//
//  RegisterViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "RegisterViewController.h"
#import "DefineThePasswordViewController.h"
#import "DYHeader.h"
#import "UIUtils.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (nonatomic,copy)NSString * phoneNumber;
@property (nonatomic,copy)NSString * Verification;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextFile;
@property (strong, nonatomic) IBOutlet UITextField *vTextFile;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.phoneTextFile addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.vTextFile addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   // [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"注册";
}
- (IBAction)getVerificationCodeButtonPressed:(id)sender {
    
    if ([UIUtils isSimplePhone:_phoneNumber]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber zone:@"86" result:^(NSError *error) {
            
            if (!error)
            {
                NSLog(@"成功");
            }
            else
            {
                NSLog(@"失败");
            }
        }];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
    
}
- (IBAction)registerButtonPressed:(id)sender {
//    DefineThePasswordViewController * definePWVC = [[DefineThePasswordViewController alloc] init];
//    [self.navigationController pushViewController:definePWVC animated:YES];
    
    [SMSSDK commitVerificationCode:_Verification phoneNumber:_phoneNumber zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            // 验证成功
            DefineThePasswordViewController * definePWVC = [[DefineThePasswordViewController alloc] init];
            definePWVC.phoneNumber = _phoneNumber;
            [self.navigationController pushViewController:definePWVC animated:YES];
        }else
        {
            NSLog(@"失败");
        }
    }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFile
- (void)passConTextChange:(UITextField *)textField{
    if (textField.tag == 1) {
        _phoneNumber = textField.text;
    }else{
        _Verification = textField.text;
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
