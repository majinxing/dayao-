//
//  PersonalCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalCollectionViewCell.h"

@implementation PersonalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PersonalCollectionViewCell" owner:self options:nil].lastObject;
        //self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}
@end
