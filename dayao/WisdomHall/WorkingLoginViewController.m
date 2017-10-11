//
//  WorkingLoginViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "WorkingLoginViewController.h"
#import "TheLoginViewController.h"

@interface WorkingLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *workNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;

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
