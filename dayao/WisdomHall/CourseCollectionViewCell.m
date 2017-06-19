//
//  CourseCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CourseCollectionViewCell.h"
#import "DYHeader.h"

@implementation CourseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"CourseCollectionViewCell" owner:self options:nil].lastObject;
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    }
    return self;
    
}

@end
