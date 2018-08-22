//
//  NoticeView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NoticeView.h"
#import "DYHeader.h"

@interface NoticeView()
@property (nonatomic,strong) UILabel * nMessage;
@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong)CollectionHeadView *collectionHeadView;
@end
@implementation NoticeView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addContentView:nil];
    }
    return self;
}
-(void)addContentView:(NoticeModel *)noticeModel{
    //    if (!_nMessage) {
    //        _nMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2, 60, 20)];
    //    }
    //    _nMessage.text  =  @"最新通知";
    //
    //    _nMessage.font = [UIFont systemFontOfSize:14];
    //
    //    [self addSubview:_nMessage];
    //
    //    if (!_lineView) {
    //        _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nMessage.frame)+5, 10, 2, self.frame.size.height-20)];
    //    }
    //    _lineView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    //
    //    [self addSubview:_lineView];
    
    
    for (int i = 0; i<3; i++) {
        
        UIImageView * ii = [[UIImageView alloc] initWithFrame:CGRectMake(10+13*i, 20, 10, 10)];
        ii.image = [UIImage imageNamed:@"星 copy 2"];
        [self addSubview:ii];
    }
    UILabel * newNotic = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 56, 20)];
    newNotic.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    newNotic.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    newNotic.text = @"最新通知";
    [self addSubview:newNotic];
    
    UIView * line = [[UIView alloc] init];
    line.frame = CGRectMake(CGRectGetMaxX(newNotic.frame)+10, 20, 1, 30);
    line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self addSubview:line];
    //    _collectionHeadView.frame = CGRectMake(70,APPLICATION_HEIGHT-20-100-140-100, ScrollViewW-70,ScrollViewH);
    //
    //    [_collectionHeadView getData];
    //
    //    [self addSubview:_collectionHeadView];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
