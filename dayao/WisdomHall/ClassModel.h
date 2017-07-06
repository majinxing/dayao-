//
//  ClassModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property (nonatomic,copy)NSString * sclassId;
@property (nonatomic,copy)NSString * signWay;
@property (nonatomic,copy)NSString * typeRoom;
@property (nonatomic,copy)NSString * teacherId;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * total;
@property (nonatomic,copy)NSString * pictureId;
@property (nonatomic,copy)NSString * roomId;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * creatTime;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * mck;
//@property (nonatomic,copy)NSString 

-(void)setInfoWithDict:(NSDictionary *)dict;
@end
