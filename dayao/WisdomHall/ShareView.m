//
//  ShareView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ShareView.h"
#import "DYHeader.h"
#import "ShareButton.h"
#import "DetailsButton.h"

#define CONTENT_VIEW_HEIGHT 250

#define columns 4
#define buttonWH 60
#define marginHeight 25

@interface ShareView ()
{
    UIView *_contentView;
    NSArray *_shareTypeArray;
    NSArray *_interactionTypeArray;
}
@end
@implementation ShareView
- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addContentViewWithType:type];
    }
    return self;
}

- (void)addContentViewWithType:(NSString *)type
{
    //设置起始状态下的背景颜色
    [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0]];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT, APPLICATION_WIDTH, CONTENT_VIEW_HEIGHT)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_contentView];
    //给_contentView添加手势
    UITapGestureRecognizer *tapDoNothingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [_contentView addGestureRecognizer:tapDoNothingGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tapGesture];
    
    if ([type isEqualToString:@"share"]) {
        //添加分享按钮
        [self addShareButton];
    }else if ([type isEqualToString:@"interaction"]){
        //添加互动按钮
        [self addInteractionButton];
    }else if ([type isEqualToString:@"meetingInteraction"]){
        [self addMeeting];
    }else if ([type isEqualToString:@"vote"]){
        [self addVote];
    }else if ([type isEqualToString:@"text"]){
        [self addText];
    }

}
-(void)addMeeting{
    _interactionTypeArray = @[
                              InteractionType_Vote,
                              InteractionType_Data,
                              InteractionType_Responder,
                              ];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonWH * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < _interactionTypeArray.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonWH + marginWidth) * column;
        int y = oneY + (buttonWH + marginWidth) * row;
        
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:_interactionTypeArray[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }

}
//添加分享按钮
- (void)addShareButton
{
    _shareTypeArray = @[
                        ShareType_Weixin_Friend,
                        ShareType_Weixin_Circle,
                        ShareType_QQ_Friend,
                        ShareType_QQ_Zone,
                        ];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonWH * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < _shareTypeArray.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonWH + marginWidth) * column;
        int y = oneY + (buttonWH + marginWidth) * row;
        
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:_shareTypeArray[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }
}
//添加互动按钮
- (void)addInteractionButton
{
    _interactionTypeArray = @[
                              InteractionType_Data,
                              InteractionType_Vote,
                              InteractionType_Responder,
                              InteractionType_Test,
                              InteractionType_Discuss
                              ];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonWH * columns) / (columns + 1);
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    for (int i = 0; i < _interactionTypeArray.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        
        int x = oneX + (buttonWH + marginWidth) * column;
        int y = oneY + (buttonWH + marginWidth) * row;
        
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:_interactionTypeArray[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }
}
//投票
-(void)addVote{
    _shareTypeArray = @[Vote_delecate,
                        Vote_Stare,
                        Vote_Stop];
    //水平间距
    int marginWidth = (APPLICATION_WIDTH - buttonWH * columns) / (columns + 1);
    //起始XY坐标
    int oneX = 0;
    int oneY = 50;
    
    for (int i = 0; i < _shareTypeArray.count; i++)
    {
        //行
//        int row = i / columns;
        //列
//        int column = i % columns;
        
        int x = oneX;
        int y = oneY + buttonWH * i;
        
        DetailsButton * button = [[DetailsButton alloc] initWithFrame:CGRectMake(x, y,APPLICATION_WIDTH - 20, buttonWH) andType:_shareTypeArray[i]];
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_contentView addSubview:button];
    }
}
//测试
-(void)addText{
    _shareTypeArray = @[Vote_delecate,
                        Vote_Stare,
                        Vote_Stop,
                        ];
    //水平间距
    
    //起始XY坐标
    int oneX = 0;
    int oneY = 50;
    
    for (int i = 0; i < _shareTypeArray.count; i++)
    {
        int x = oneX;
        int y = oneY + buttonWH * i;
        
        DetailsButton * button = [[DetailsButton alloc] initWithFrame:CGRectMake(x, y,APPLICATION_WIDTH - 20, buttonWH) andType:_shareTypeArray[i]];
        
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.textAlignment = NSTextAlignmentLeft;

        [_contentView addSubview:button];
    }
}
- (void)addCancleButtonWith:(NSString *)str
{
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 150, 20)];
    title.text = str;
    [_contentView addSubview:title];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 50, APPLICATION_WIDTH-40, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [_contentView addSubview:line];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
 
    [cancleButton setFrame:CGRectMake(APPLICATION_WIDTH-40, 15, 20,20)];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:cancleButton];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4]];
        
        [self addCancleButtonWith:_name];

        [_contentView setFrame:CGRectMake(0, APPLICATION_HEIGHT - CONTENT_VIEW_HEIGHT, APPLICATION_WIDTH, CONTENT_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor clearColor]];
        [_contentView setFrame:CGRectMake(0, APPLICATION_HEIGHT, APPLICATION_WIDTH, CONTENT_VIEW_HEIGHT)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)shareButtonClicked:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:
                          @selector(shareViewButtonClick:)])
    {
        [self.delegate shareViewButtonClick:button.titleLabel.text];
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
