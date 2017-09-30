//
//  WorkingLoginViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "WorkingLoginViewController.h"

@interface WorkingLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *workNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;

@end

@implementation WorkingLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _password.secureTextEntry = YES;
    
    [_workNumber setValue:[UIColor whiteColor] forKey:@"_placeholderLabel.textColor"];
    [_password setValue:[UIColor whiteColor] forKey:@"_placeholderLabel.textColor"];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
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
