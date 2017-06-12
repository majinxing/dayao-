//
//  CourseCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CourseCollectionViewCell.h"

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
    }
    return self;
    
}

@end
