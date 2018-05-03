//
//  EssayQuestionViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionModel.h"

@interface EssayQuestionViewController : UIViewController
@property (nonatomic,strong)QuestionModel * questionModel;

@property (nonatomic,assign)BOOL editable;
@end
