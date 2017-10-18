//
//  ClassTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassTableViewCell.h"

@interface ClassTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *weekDay;
@property (strong, nonatomic) IBOutlet UILabel *sclass;
@property (strong, nonatomic) IBOutlet UIButton *monday;
@property (strong, nonatomic) IBOutlet UIButton *tuesday;
@property (strong, nonatomic) IBOutlet UIButton *wednesday;
@property (strong, nonatomic) IBOutlet UIButton *thursday;
@property (strong, nonatomic) IBOutlet UIButton *friday;
@property (strong, nonatomic) IBOutlet UIButton *saturday;
@property (strong, nonatomic) IBOutlet UIButton *sunday;

@end
@implementation ClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)addFirstContentViewWith:(int)index withClass:(NSMutableArray *)classAry{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
