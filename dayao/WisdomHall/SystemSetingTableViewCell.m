//
//  SystemSetingTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SystemSetingTableViewCell.h"
#import "DYHeader.h"
@interface SystemSetingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *setingImage;

@property (nonatomic,strong)NSArray * textAry;
@end
@implementation SystemSetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_textAry) {
      _textAry = [NSArray arrayWithObjects:@"个人资料", @"学校通知",@"系统设置",@"关于我们",nil];
    }
    _user = [[Appsetting sharedInstance] getUsetInfo];
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"SystemSetingTableViewCellSecond";
            index = 1;
            break;
        case 1:
            identifier = @"SystemSetingTableViewCellThird";
            index = 2;
        default:
            break;
    }
    SystemSetingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetingTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
  
    if (indexPath.section == 1) {
        cell.setingLabel.text = cell.textAry[indexPath.row];
    }else if (indexPath.section == 0){
        cell.userName.text = cell.user.userName;
        cell.workNo.text = cell.user.studentId;
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
