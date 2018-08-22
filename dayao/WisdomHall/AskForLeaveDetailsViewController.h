//
//  AskForLeaveDetailsViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskForLeaveView.h"
#import "AskForLeaveModel.h"
#import "ClassModel.h"

@interface AskForLeaveDetailsViewController : UIViewController
@property (nonatomic,strong)AskForLeaveModel * askModel;
@property (nonatomic,strong)ClassModel * c;
@end
