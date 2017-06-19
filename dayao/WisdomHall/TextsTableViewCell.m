//
//  TextsTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextsTableViewCell.h"


@interface TextsTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *indexPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation TextsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}
-(void)addContentView:(TextModel *)t{
    _titleLabel.text = [NSString stringWithFormat:@"标    题：%@",t.title];
    _stateLabel.text = t.textState;
    _typeLabel.text = t.type;
    _indexPointLabel.text = [NSString stringWithFormat:@"指标点：%@",t.indexPoint];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
