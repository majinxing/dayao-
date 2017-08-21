//
//  VoteTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteTableViewCell : UITableViewCell
-(void)voteTitle:(NSString *)title withCreateTime:(NSString *)time withState:(NSString *)state;
@end
