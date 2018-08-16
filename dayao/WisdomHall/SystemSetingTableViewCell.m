//
//  SystemSetingTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SystemSetingTableViewCell.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"
#import "DYTabBarViewController.h"
#import "WorkingLoginViewController.h"

@interface SystemSetingTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *workNumber;

@property (weak, nonatomic) IBOutlet UIImageView *setingImage;
@property (strong, nonatomic) IBOutlet UIButton *outBtn;


@property (nonatomic,strong)NSArray * textAry;
@end
@implementation SystemSetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_textAry) {
      _textAry = [NSArray arrayWithObjects:@"个人资料",@"关于我们",@"意见反馈",@"帮助",nil];
    }
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 8;
    _userName.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _userName.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:83/255.0 alpha:1/1.0];
    _workNo.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    
    _workNo.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    
    _setingLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _setingLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _outBtn.layer.masksToBounds = YES;
    _outBtn.layer.cornerRadius = 20;
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
            break;
        case 2:
            identifier = @"SystemSetingTableViewCellFifth";
            index = 4;
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
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.userHeadImageId]]) {
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            NSString * baseUrl = user.host;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,user.userHeadImageId]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.headImage.frame = CGRectMake(18, 18, 110, 100);
        }
        
        if ([[NSString stringWithFormat:@"%@",user.identity] isEqualToString:@"1"]) {
            cell.workNo.text = [NSString stringWithFormat:@"工号%@",cell.user.studentId];
        }else{
            cell.workNo.text = [NSString stringWithFormat:@"%@",cell.user.studentId];
        }
    }
    return cell;
}
- (IBAction)outAppBtn:(UIButton *)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //i++
        NSNotification *notification =[NSNotification notificationWithName:@"OutOfApp" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [[Appsetting sharedInstance] getOut];
        
        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
        
        [rootVC attempDealloc];
        
        rootVC = nil;
        
        
        WorkingLoginViewController * userLogin = [[WorkingLoginViewController alloc] init];
        //    TheLoginViewController * userLogin = [[TheLoginViewController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController =[[UINavigationController alloc] initWithRootViewController:userLogin];
        
    });
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(outAPPBtnPressedDelegate)]) {
//        [self.delegate outAPPBtnPressedDelegate];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
