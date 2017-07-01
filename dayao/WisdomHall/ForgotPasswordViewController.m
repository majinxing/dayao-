//
//  ForgotPasswordViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "RedefineThePasswordViewController.h"
#import "DYHeader.h"
#import <SMS_SDK/SMSSDK.h>
@interface ForgotPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) IBOutlet UITextField *Verification;
@property (strong, nonatomic) IBOutlet UIButton *sendVerification;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    // [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"忘记密码";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendVerificationBtnPressed:(id)sender {
    if ([UIUtils isSimplePhone:_phoneNumber.text]) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber.text zone:@"86" result:^(NSError *error) {
            
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
- (IBAction)nextButtonPressed:(id)sender {
    
    RedefineThePasswordViewController * redeFineVC = [[RedefineThePasswordViewController alloc] init];
    redeFineVC.phoneNumber = _phoneNumber.text;
    [self.navigationController pushViewController:redeFineVC animated:YES];
    
    [SMSSDK commitVerificationCode:_Verification phoneNumber:_phoneNumber.text zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            // 验证成功
            RedefineThePasswordViewController * redeFineVC = [[RedefineThePasswordViewController alloc] init];
            redeFineVC.phoneNumber = _phoneNumber.text;
            [self.navigationController pushViewController:redeFineVC animated:YES];
        }else
        {
            NSLog(@"失败");
        }
    }];
   
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
