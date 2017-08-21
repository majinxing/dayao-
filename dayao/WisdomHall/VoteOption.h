//
//  VoteOption.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/21.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteOption : NSObject
@property (nonatomic,copy)NSString * optionId;
@property (nonatomic,copy)NSString * content;
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
