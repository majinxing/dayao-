//
//  Appsetting.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "Appsetting.h"
#import "UserModel.h"

@implementation Appsetting
+(Appsetting *)sharedInstance{
    static Appsetting * shareInstance = nil;
    if (shareInstance == nil) {
        shareInstance = [[Appsetting alloc] init];
    }
    return shareInstance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _mySettingData = [NSUserDefaults standardUserDefaults];//本地化，归档的一种
    }
    return self;
}
-(void)sevaUserInfoWithDict:(NSDictionary *)dict{
    [_mySettingData setValue:[dict objectForKey:@"id"] forKey:@"user_id"];
    [_mySettingData setValue:[dict objectForKey:@"name"] forKey:@"user_name"];
    [_mySettingData setValue:[dict objectForKey:@"phone"] forKey:@"user_phone"];
    [_mySettingData setValue:[dict objectForKey:@"type"] forKey:@"user_type"];
    [_mySettingData setValue:[dict objectForKey:@"universityCode"] forKey:@"user_universityCode"];
    [_mySettingData setValue:[dict objectForKey:@"workNo"] forKey:@"user_workNo"];
    [_mySettingData setValue:[dict objectForKey:@"majorCode"] forKey:@"user_majorCode"];
    [_mySettingData setValue:[dict objectForKey:@"facultyCode"] forKey:@"user_facultyCode"];
    [_mySettingData setValue:[dict objectForKey:@"classCode"] forKey:@"user_classCode"];
    [_mySettingData synchronize];
    
}
-(UserModel *)getUsetInfo{
    UserModel * userInfo = [[UserModel alloc] init];
    userInfo.userPhone = [_mySettingData objectForKey:@"user_phone"];
    userInfo.userName = [_mySettingData objectForKey:@"user_name"];
    userInfo.school = [_mySettingData objectForKey:@"user_universityCode"];
    userInfo.identity = [_mySettingData objectForKey:@"user_type"];
    userInfo.departments = [_mySettingData objectForKey:@"user_facultyCode"];
    userInfo.professional = [_mySettingData objectForKey:@"user_majorCode"];
    userInfo.classNumber = [_mySettingData objectForKey:@"user_classCode"];
    userInfo.studentId = [_mySettingData objectForKey:@"user_workNo"];
    userInfo.peopleId = [_mySettingData objectForKey:@"user_id"];
    return userInfo;
}







@end















