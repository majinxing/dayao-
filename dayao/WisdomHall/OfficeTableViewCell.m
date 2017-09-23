//
//  OfficeTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/23.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "OfficeTableViewCell.h"
#import "DYHeader.h"
#import "ShareButton.h"

#define columns 4
#define buttonWH 60
#define marginHeight 25

@interface OfficeTableViewCell()
@property (strong, nonatomic) IBOutlet UIButton *signBtn;

@end
@implementation OfficeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _signBtn.layer.masksToBounds = YES;
    _signBtn.layer.cornerRadius = 40;
    _signBtn.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // Initialization code
}
-(void)addSecondContentView{
   NSArray * array = @[
                       Meeting,
                       Announcement,
                       Leave,
                       Business,
                       Lotus
                       ];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonWH * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < array.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonWH + marginWidth) * column;
        int y = oneY + (buttonWH + marginWidth) * row;
        
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:array[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}
- (void)shareButtonClicked:(UIButton *)button
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:)]) {
        [self.delegate shareButtonClickedDelegate:button.titleLabel.text];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
