//
//  PersonalInfoTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *personalNameLabel;

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)ary;
@end
