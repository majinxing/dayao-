//
//  EssayQuestionViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuestionModel.h"

@protocol EssayQuestionViewControllerDelegate<NSObject>
-(void)handleSwipeFromDelegate:(UISwipeGestureRecognizer *)recognizer;
@end

@interface EssayQuestionViewController : UIViewController

@property (nonatomic,weak)id<EssayQuestionViewControllerDelegate>delegate;

@property (nonatomic,assign)int titleNum;//题号

@property (nonatomic,strong)QuestionModel * questionModel;

@property (nonatomic,assign)BOOL editable;
@end
