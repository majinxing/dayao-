//
//  peopleInfoTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/1.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "peopleInfoTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface peopleInfoTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *peopleName;

@end
@implementation peopleInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    // Initialization code
}
-(void)addContViewWith:(SignPeople *)s{
    _peopleName.text = s.name;
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",s.pictureId]]) {
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",user.host,FileDownload,s.pictureId]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
        
    }else{
        _headImageView.image = [UIImage imageNamed:@"PersonalChat"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
