//
//  PersonalDataTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalDataTableViewCell.h"
#import "DYHeader.h"

@interface PersonalDataTableViewCell()


@end
@implementation PersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UserModel * userl = [[Appsetting sharedInstance] getUsetInfo];
    _placeholder = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",userl.userName],[NSString stringWithFormat:@"%@",userl.studentId],[NSString stringWithFormat:@"%@",userl.school],[NSString stringWithFormat:@"%@",userl.departments],[NSString stringWithFormat:@"%@",userl.professional], nil];
    _labelAry = [NSArray arrayWithObjects:@"姓名",@"学号",@"学校",@"院系",@"专业", nil];
    
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PersonalDataTableViewCellSecond";//对应xib中设置的identifier
    NSInteger index = 1; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"PersonalDataTableViewCellFirst";
            index = 0;
            break;
        case 1:
            identifier = @"PersonalDataTableViewCellSecond";
            index = 1;
        default:
            break;
    }
    PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalDataTableViewCell" owner:self options:nil] objectAtIndex:index];
        if (indexPath.section == 1) {
            cell.dataLabel.text = cell.labelAry[indexPath.row];
            cell.textFilePh.text = cell.placeholder[indexPath.row];
        }
    }
        return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
