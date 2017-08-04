//
//  AlterView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AlterView.h"
#import "DYHeader.h"

@implementation AlterView
-(instancetype)initWithFrame:(CGRect)frame withLabelText:(NSString *)textStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addContentViewWithLabelText:textStr];
    }
    return self;
}
-(void)addContentViewWithLabelText:(NSString *)textStr{
    UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40)];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:20];
    text.text = textStr;
    text.textColor = [UIColor blackColor];
    [self addSubview:text];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(text.frame),self.frame.size.width, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(removeSubView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
-(void)removeSubView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(alterViewDeleageRemove)]) {
        [self.delegate alterViewDeleageRemove];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
