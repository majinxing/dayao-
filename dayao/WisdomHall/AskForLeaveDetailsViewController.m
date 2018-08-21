//
//  AskForLeaveDetailsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveDetailsViewController.h"

@interface AskForLeaveDetailsViewController ()

@end

@implementation AskForLeaveDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AskForLeaveView * viewq = [[AskForLeaveView alloc] initWithFrame:CGRectMake(0, NaviHeight, APPLICATION_WIDTH, APPLICATION_HEIGHT-(NaviHeight))];
    [viewq addContentViewWithAry:_askModel];
    [self.view addSubview:viewq];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
