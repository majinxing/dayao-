//
//  AskForLeaveModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveModel.h"

@implementation AskForLeaveModel
-(void)setValueWithDict:(NSDictionary *)dict{
    _name = [dict objectForKey:@"userName"];
    _askState = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
    _askTime = [UIUtils getTheTimeStamp:[NSString stringWithFormat:@"%@",[dict objectForKey:@"createTime"]]];
    _askText = [dict objectForKey:@"reason"];
    _askId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    _image = [NSString stringWithFormat:@"%@",[dict objectForKey:@"resourceId"]];
    _userId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
}

@end
