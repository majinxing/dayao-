//
//  AskForLeaveDetailsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveDetailsViewController.h"

@interface AskForLeaveDetailsViewController ()<AskForLeaveViewDelegate>

@end

@implementation AskForLeaveDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AskForLeaveView * viewq = [[AskForLeaveView alloc] initWithFrame:CGRectMake(0, NaviHeight, APPLICATION_WIDTH, APPLICATION_HEIGHT-(NaviHeight))];
    [viewq addContentViewWithAry:_askModel];
    viewq.delegate = self;
    [self.view addSubview:viewq];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark AskForLeaveViewDelegate
-(void)whetherOrNotApproveDelegate:(UIButton *)btn{
    NSMutableDictionary * dict;
    if ([btn.titleLabel.text isEqualToString:@"批准"]) {
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"2",@"status",[NSString stringWithFormat:@"%ld",(long)btn.tag],@"id", nil];
    }else if([btn.titleLabel.text isEqualToString:@"不批准"]){
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3",@"status",[NSString stringWithFormat:@"%ld",(long)btn.tag],@"id",@"理由不充足",@"auditIllustrate", nil];
    }else{
        return;
    }
    [[NetworkRequest sharedInstance] POST:AuditLeave dict:dict succeed:^(id data) {
        NSString * message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        if ([message isEqualToString:@"成功"]) {
            if ([btn.titleLabel.text isEqualToString:@"批准"]) {
//                [self changeStudentSignState];
                [UIUtils showInfoMessage:@"批准" withVC:self];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }else{
                [UIUtils showInfoMessage:@"已审批" withVC:self];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }
        }else{
            [UIUtils showInfoMessage:message withVC:self];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"请检查网络" withVC:self];

    }];
}
-(void)changeStudentSignState{
    NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_c.courseDetailId],@"courseDetailId",[NSString stringWithFormat:@"%@",_askModel.userId],@"userId",[NSString stringWithFormat:@"%@-%@",_askModel.userId,[UIUtils getTime]],@"mck",@"3",@"status",@"请假",@"reason", nil];
    [[NetworkRequest sharedInstance] POST:ClassSign dict:d succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        if ([str isEqualToString:@"成功"]) {
            [UIUtils showInfoMessage:@"已审批" withVC:self];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }else{
            [UIUtils showInfoMessage:str withVC:self];

        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"请检查网络" withVC:self];

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
