//
//  QuestionBankListViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/17.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionBank.h"

@protocol QuestionBankListViewControllerDelegate<NSObject>
-(void)returnBankModelDelegate:(QuestionBank *)q;
@end

@interface QuestionBankListViewController : UIViewController

@property (nonatomic,weak)id<QuestionBankListViewControllerDelegate>delegate;

@property (nonatomic,strong)NSMutableArray * bankListAry;

@end
