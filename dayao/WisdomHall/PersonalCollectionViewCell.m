//
//  PersonalCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalCollectionViewCell.h"
#import "MeetingModel.h"
#import "SignPeople.h"

@interface PersonalCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workNo;


@end
@implementation PersonalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PersonalCollectionViewCell" owner:self options:nil].lastObject;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setPersonalInfo:(SignPeople *)sign{
    SignPeople * s = sign;
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",s.name];
    _workNo.text = [NSString stringWithFormat:@"学号：%@",s.workNo];
    _workNo.font = [UIFont systemFontOfSize:11];
    _workNo.textAlignment = NSTextAlignmentLeft;
}
@end
