//
//  TestQuestionsViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"
#import "QuestionBank.h"

@interface TestQuestionsViewController : UIViewController
@property (nonatomic,strong)TextModel *t;
@property (nonatomic,strong)QuestionBank * qBank;
@end
