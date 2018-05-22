//
//  ImportTextViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"

typedef void (^returnSelectedQustion)(NSMutableArray * allAry);

@interface ImportTextViewController : UIViewController

@property (nonatomic,strong)NSMutableArray * selectQuestionAry;

@property (nonatomic,strong)TextModel * t;

@property (nonatomic,copy) returnSelectedQustion returnBlock;

-(void)returnAry:(returnSelectedQustion)block;

@end
