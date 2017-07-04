//
//  PersonalInfoTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalInfoTableViewCell.h"

@implementation PersonalInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)ary{
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"PersonalInfoTableViewCellFirst";
            index = 0;
            break;
        case 1:
            identifier = @"PersonalInfoTableViewCellSecond";
            index = 1;
            break;
        case 2:
            identifier = @"PersonalInfoTableViewCellThird";
            index = 2;
            break;
        case 3:
            identifier = @"PersonalInfoTableViewCellFourth";
            index = 3;
        default:
            break;
    }
    PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalInfoTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    if (indexPath.section == 3) {
        cell.personalNameLabel.text = [NSString stringWithFormat:@"姓名：冷小凡%@",ary[(int)indexPath.row]];
    }
    return cell;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)signBtnPressed:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signBtnPressedPInfoDelegate)]) {
        [self.delegate signBtnPressedPInfoDelegate];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
