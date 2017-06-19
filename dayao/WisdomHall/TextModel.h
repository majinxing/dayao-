//
//  TextModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextModel : NSObject
@property (nonatomic,copy) NSString * textId;//试卷主键
@property (nonatomic,copy) NSString * title;//试卷标题
@property (nonatomic,copy) NSString * type;//试卷内容
@property (nonatomic,copy) NSString * indexPoint;//指标点
@property (nonatomic,copy) NSString * timeLimit;//限时
@property (nonatomic,copy) NSString * textState;//试卷状态
@property (nonatomic,copy) NSString * redo;//重做次数
@property (nonatomic,copy) NSString * totalScore;//试卷总分
@property (nonatomic,copy) NSString * totalNumber;//试卷总题数
-(BOOL)whetherIsEmpty;
-(void)changeTotalNumberWithTitle:(NSString *)titleScore;
@end
