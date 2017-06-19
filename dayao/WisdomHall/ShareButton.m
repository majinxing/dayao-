//
//  ShareButton.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ShareButton.h"
#import "DYHeader.h"

#define IMAGE_WH 40

@implementation ShareButton
- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setContentWithType:type];
    }
    return self;
}

//设置显示内容
- (void)setContentWithType:(NSString *)type
{
    if ([type isEqualToString:ShareType_Copy])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_copy"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Email])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_email"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Message])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_sms"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_QQ_Friend])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_qqfriend"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_QQ_Zone])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_qzone"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Weibo])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_sinaweibo"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Weixin_Circle])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_weixinTimeline"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Weixin_Friend])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_weixin"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Test]) {
        [self setImage:[UIImage imageNamed:@"text"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Vote]) {
        [self setImage:[UIImage imageNamed:@"Vote"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Discuss]) {
        [self setImage:[UIImage imageNamed:@"discussed"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Responder]) {
        [self setImage:[UIImage imageNamed:@"answer"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Add]) {
        [self setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
    [self setTitle:type forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((self.bounds.size.width - IMAGE_WH) / 2, 0, IMAGE_WH, IMAGE_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, IMAGE_WH, self.bounds.size.width, self.bounds.size.height - IMAGE_WH);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
