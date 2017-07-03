//
//  UserModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,copy) NSString * userPhone;
@property (nonatomic,copy) NSString * userPassword;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * userHeadImage;
@property (nonatomic,copy) NSString * school;
@property (nonatomic,copy) NSString * identity;//身份
@property (nonatomic,copy) NSString * studentId;//学号，工号
@property (nonatomic,copy) NSString * departments;
@property (nonatomic,copy) NSString * professional;
@property (nonatomic,copy) NSString * classNumber;
@property (nonatomic,copy) NSString * peopleId;
@end
