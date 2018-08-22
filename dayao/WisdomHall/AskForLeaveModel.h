//
//  AskForLeaveModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AskForLeaveModel : NSObject
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * askTime;
@property (nonatomic,copy)NSString * askText;
@property (nonatomic,copy)NSString * askState;
@property (nonatomic,copy)NSString * image;
@property (nonatomic,copy)NSString * askId;
@property (nonatomic,copy)NSString * userId;
-(void)setValueWithDict:(NSDictionary *)dict;
@end
