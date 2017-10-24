//
//  MeetingTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"

@protocol MeetingTableViewCellDelegate <NSObject>
-(void)shareButtonClickedDelegate:(NSString *)platform;
-(void)peopleManagementDelegate;
-(void)signNOPeopleDelegate;
-(void)signBtnPressedDelegate:(UIButton *)btn;
@end
@interface MeetingTableViewCell : UITableViewCell
@property(nonatomic,weak)id<MeetingTableViewCellDelegate>delegate;
-(void)addFirstContentView:(MeetingModel *)meetModel;
-(void)addSecondContentView:(MeetingModel *)meetModel;
-(void)addFourthContentView:(MeetingModel *)meetModel;
-(void)addThirdContentView:(MeetingModel *)meetModel;
@end
