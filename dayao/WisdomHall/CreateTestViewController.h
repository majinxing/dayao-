//
//  CreateTestViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TextModel.h"
#import "QuestionBank.h"
#import "ClassModel.h"

@interface CreateTestViewController : UIViewController



@property (nonatomic,strong)TextModel *t;

@property (nonatomic,strong)QuestionBank * qBank;

@property (nonatomic,strong)ClassModel *classModel;

@property (nonatomic,copy)NSString * textName;
@property (nonatomic,assign)BOOL editable;
@end
