//
//  AskForLeaveTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveTableViewCell.h"

@interface AskForLeaveTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *askTime;
@property (weak, nonatomic) IBOutlet UILabel *askTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *askState;

@end

@implementation AskForLeaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect rect = CGRectMake(0, 0, 70, 30);
    
    CGSize radio = CGSizeMake(15, 15);//圆角尺寸
    
    UIRectCorner corner = UIRectCornerBottomRight;//这只圆角位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    
    //创建shapelayer
    masklayer.frame = _askState.bounds;
    
    masklayer.path = path.CGPath;
    //设置路径
    _askState.layer.mask = masklayer;
    
    _askTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _askTime.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    // Initialization code
}
-(void)addContentView:(AskForLeaveModel *)ask{
    _name.text = ask.name;
    _askTime.text = ask.askTime;
    _askTextLabel.text = ask.askText;
    if ([ask.askState isEqualToString:@"2"]) {
        _askState.text = @"已审核";
        _askState.backgroundColor = [UIColor greenColor];
    }else if ([ask.askState isEqualToString:@"3"]){
        _askState.text = @"未批准";
        _askState.backgroundColor = [UIColor redColor];
    }else{
        _askState.text = @"未审批";
        _askState.backgroundColor = RGBA_COLOR(250, 95, 6, 1);
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
