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
        NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSString * ss = [[data objectForKey:@"body"] objectForKey:@"bind"];
            if ([ss isEqualToString:@"true"]) {
                [self bindPhoneBtn];
            }else{
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                dict = [data objectForKey:@"body"];
                
                [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:_password.text];
                
                ChatHelper * c =[ChatHelper shareHelper];
                
                DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
            }
        }else if ([str isEqualToString:@"1014"]){
            [UIUtils showInfoMessage:@"用户名或密码错误"];
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
-(void)bindPhoneBtn{
    if (_bindPhone == nil) {
        _bindPhone = [[BindPhone alloc] init];
        _bindPhone.delegate = self;
        _bindPhone.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        [self.view addSubview:_bindPhone];
    }
}
#pragma mark BindPhoneDelegate
-(void)bindPhoneBtnDelegate:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        [_bindPhone removeFromSuperview];
        _bindPhone = nil;
    }else if (btn.tag == 2){
        _phone = [NSString stringWithFormat:@"%@",_bindPhone.courseNumber.text];

        [JSMSSDK getVerificationCodeWithPhoneNumber:_bindPhone.courseNumber.text andTemplateID:@"144851" completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSLog(@"Get verification code success!");
                [_bindPhone addSecondContentView];
            }else{
                [UIUtils showInfoMessage:@"发送失败"];
            }
            }];
    }
}
-(void)bindDelegate:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        [_bindPhone removeFromSuperview];
        _bindPhone = nil;
    }else if (btn.tag == 2){
        //验证验证码
        [JSMSSDK commitWithPhoneNumber:_phone verificationCode:_bindPhone.courseNumber.text completionHandler:^(id resultObject, NSError *error) {
            
            if (!error)
            {
                [self bindPhoneA];
            }else
            {
                [UIUtils showInfoMessage:@"验证码错误"];
            }
        }];
        
    }

}
-(void)bindPhoneA{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_phone],@"phone",_workNumber.text,@"workNo", nil];
    [[NetworkRequest sharedInstance] POST:BindPhoe dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            dict = [data objectForKey:@"body"];
            
            [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:_password.text];
            
            ChatHelper * c =[ChatHelper shareHelper];
            
            DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
        }else if([str isEqualToString:@"1009"]){
            [UIUtils showInfoMessage:@"绑定失败：手机号已注册"];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"绑定失败请检查网络"];
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
