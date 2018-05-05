//
//  QuestionModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "QuestionModel.h"
#import "optionsModel.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"

@implementation QuestionModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _questionTitleImageAry = [NSMutableArray arrayWithCapacity:1];
        
        _questionTitleImageIdAry = [NSMutableArray arrayWithCapacity:1];
        
        _questionAnswerImageAry = [NSMutableArray arrayWithCapacity:1];
        
        _questionAnswerImageIdAry = [NSMutableArray arrayWithCapacity:1];
        
        _answerOptions = [NSMutableArray arrayWithCapacity:1];
        
        _qustionScore = @"5";
        
        _questionDifficulty = @"5";
        
        _blankAry = [NSMutableArray arrayWithCapacity:1];
        
        [self addOptions];
    }
    return self;
}
-(void)addOptions{
    _qustionOptionsAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<4; i++) {
        optionsModel * o = [[optionsModel alloc] init];
        [_qustionOptionsAry addObject:o];
    }
    
}
-(void)addContenWithDict:(NSDictionary *)dict{
//    _questionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@""]];
    _questionTitle = [dict objectForKey:@"content"];
    
    _titleType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"studentAnswer"]]]) {
        _questionAnswer  = [[NSString alloc] init];
    }else{
       _questionAnswer  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"studentAnswer"]];
    }
    
    _questionAnswerImageIdAry = [NSMutableArray arrayWithArray:[dict objectForKey:@"answerResourceList"]];
    
    
    [self setAnswerImage];
    
    _questionTitleImageIdAry = [dict objectForKey:@"resourceList"];
    
    _questionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];;
    
    NSString * answerOptionStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"answerOptions"]];
    
    _answerOptions = [[NSMutableArray alloc] initWithArray:[answerOptionStr componentsSeparatedByString:@","]];
    
    NSArray * ary = [dict objectForKey:@"choiceInfoList"];
    
    [_qustionOptionsAry removeAllObjects];
    
    for (int i = 0; i<ary.count; i++) {
        optionsModel * opt = [[optionsModel alloc] init];
        
        [opt setContentWithDict:ary[i]];
        
        opt.edit = NO;
        
        [_qustionOptionsAry addObject:opt];
    }
}
-(float)returnTitleHeight{
    if (_edit) {
        return 480;
    }else{
        if (_questionTitleImageAry.count>0||_questionTitleImageIdAry.count>0) {
            return 480;
        }else{
            return 200;
        }
    }
    return 0;
}
-(float)returnOptionHeight:(int)index{
    optionsModel * o = _qustionOptionsAry[index];
    return [o returnOptionHeight];
}
-(void)setAnswerImage{
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSString * baseUrl = user.host;
    
    for (int i = 0 ; i<_questionAnswerImageIdAry.count; i++) {
        
//        UIImageView * image = [[UIImageView alloc] init];
        UIImage * result;
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,_questionAnswerImageIdAry[i]]]];
        
        result = [UIImage imageWithData:data];
       
        if (result) {
            [_questionAnswerImageAry addObject:result];
        }
    }
}
@end
