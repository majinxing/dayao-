//
//  QuestionModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property (nonatomic,copy) NSString * questionTitle;//题干
@property (nonatomic,strong)NSMutableArray * questionTitleImageAry;//题目图片
@property (nonatomic,strong)NSMutableArray * questionTitleImageIdAry;//题目图片id
@property (nonatomic,copy) NSString * qustionScore;//分值
@property (nonatomic,copy) NSString * questionDifficulty;//难度
@property (nonatomic,copy) NSString * questionAnswer;//题目答案
@property (nonatomic,strong) NSMutableArray * qustionOptionsAry;//选择题选项数组
@end
