//
//  optionsModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "optionsModel.h"

@implementation optionsModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _optionsImageAry = [NSMutableArray arrayWithCapacity:1];
        _optionsImageIdAry = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
-(void)setContentWithDict:(NSDictionary *)dict{
    _questionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"questionId"]];
    _optionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    _optionsTitle = [dict objectForKey:@"content"];
    _index = [dict objectForKey:@"index"];
    _optionsImageIdAry = [dict objectForKey:@"resourceList"];
}
-(float)returnOptionHeight{
    if (_edit) {
        return 200;
    }else{
        if (_optionsImageAry.count>0||_optionsImageIdAry.count>0) {
            return 200;
        }else{
            return 70;
        }
    }
    return 0;
}
@end
