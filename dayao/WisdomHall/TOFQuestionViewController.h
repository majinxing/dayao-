//
//  TOFQuestionViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@protocol TOFQuestionViewControllerDelegate<NSObject>
-(void)handleSwipeFromDelegate:(UISwipeGestureRecognizer *)recognizer;
@end

@interface TOFQuestionViewController : UIViewController

@property(nonatomic,weak)id<TOFQuestionViewControllerDelegate>delegate;

@property (nonatomic,assign)int titleNum;//题号

@property (nonatomic,strong)QuestionModel * questionModel;

@property (nonatomic,assign)BOOL editable;
@end
