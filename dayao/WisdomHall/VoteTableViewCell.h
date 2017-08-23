//
//  VoteTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoteTableViewCellDelegate <NSObject>
-(void)moreVoteTableViewCellDelegate:(UIButton *)btn;


@end
@interface VoteTableViewCell : UITableViewCell
@property (nonatomic,weak)id<VoteTableViewCellDelegate>delegate;
-(void)voteTitle:(NSString *)title withCreateTime:(NSString *)time withState:(NSString *)state withIndex:(int)n;
@end
