//
//  AskForLeaveView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AskForLeaveView.h"
#import "UIImageView+WebCache.h"
#import "imageBigView.h"

@interface AskForLeaveView()<imageBigViewDelegate>
@property (nonatomic,strong)UIButton * addPeopleBtn;

@property (nonatomic,strong)IMGroupModel * imGroupModel;

@property (nonatomic,strong)UITextField * inputName;

@property (nonatomic,strong)UITextView * introductionView;

@property (nonatomic,strong)UILabel * askState;

@property (nonatomic,strong)imageBigView * v;

@end
@implementation AskForLeaveView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)addMask{
    _askState = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-80, 10, 70, 40)];
    if ([_askModel.askState isEqualToString:@"2"]) {
        _askState.text = @"已审核";
        _askState.backgroundColor = RGBA_COLOR(30, 143, 78, 1);
    }else if ([_askModel.askState isEqualToString:@"3"]){
        _askState.text = @"未批准";
        _askState.backgroundColor = [UIColor redColor];
    }else{
        _askState.text = @"未审批";
        _askState.backgroundColor = RGBA_COLOR(250, 95, 6, 1);
        
    }
    _askState.textColor = [UIColor whiteColor];
    
    _askState.textAlignment = NSTextAlignmentCenter;
    
    CGRect rect = CGRectMake(0, 0, 70, 40);
    
    CGSize radio = CGSizeMake(15, 15);//圆角尺寸
    
    UIRectCorner corner = UIRectCornerTopRight;//这只圆角位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    
    //创建shapelayer
    masklayer.frame = _askState.bounds;
    
    masklayer.path = path.CGPath;
    //设置路径
    _askState.layer.mask = masklayer;
    
    [self addSubview:_askState];
}

-(void)addContentViewWithAry:(AskForLeaveModel *)askModel {
//    UIButton * blackView = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    blackView.frame =  CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
//    blackView.backgroundColor = [UIColor blackColor];
//    blackView.alpha = 0.5;
//    [blackView addTarget:self action:@selector(outSelfView) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:blackView];
    _askModel = askModel;
    
    UIButton * whiteView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    whiteView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-(NaviHeight));
    
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
//    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView addTarget:self action:@selector(endEdite) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:whiteView];
    
    UIView * back = [[UIView alloc] init];
    
    back.backgroundColor = [UIColor whiteColor];
    
    [whiteView addSubview:back];
    
    whiteView.layer.masksToBounds = YES;
    
    whiteView.layer.cornerRadius = 14;
    
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    UILabel * groupName = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 60, 21)];
    
    groupName.text = @"请假人:";
    
    groupName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    groupName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:groupName];
    
    _inputName = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(groupName.frame)+20, 20, 200, 20)];
    
    _inputName.text = askModel.name;
    
    _inputName.font = [UIFont systemFontOfSize:15];
    
//    [_inputName endEditing:NO];
    
    [_inputName endEditing:YES];
    
    [whiteView addSubview:_inputName];
    
    [self addMask];
    
    UIView * viewLine = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(groupName.frame)+10, APPLICATION_WIDTH-50, 1)];
    
    viewLine.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
    [whiteView addSubview:viewLine];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(viewLine.frame)+10, 70, 20)];
    
    timeLabel.text = @"请假时间:";
    
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    timeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:timeLabel];
    
    UILabel * actTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame)+20, CGRectGetMaxY(viewLine.frame)+10, 200, 20)];
    
    actTime.text = askModel.askTime;
    
    actTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    actTime.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:actTime];
    
    UIView * viewLine2 = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(timeLabel.frame)+10, APPLICATION_WIDTH-50, 1)];
    
    viewLine2.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
    [whiteView addSubview:viewLine2];
    
    UILabel * groupIntroduction = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(viewLine2.frame)+20, 80, 20)];
    
    groupIntroduction.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    
    groupIntroduction.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [whiteView addSubview:groupIntroduction];
    
    groupIntroduction.text = @"请假原因:";
    
    [whiteView addSubview:groupIntroduction];
    
    _introductionView = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(groupIntroduction.frame)+10, APPLICATION_WIDTH-50, 200)];
    _introductionView.backgroundColor =  [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1/1.0];
    _introductionView.text = askModel.askText;
    [_introductionView setEditable:NO];
    _introductionView.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:_introductionView];
    

    UILabel * pictureLable = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_introductionView.frame)+10, 100, 20)];
//    pictureLable.text = @"照片证明";
    pictureLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];

    
    _picturebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _picturebtn.frame = CGRectMake(25, CGRectGetMaxY(pictureLable.frame)+10, 70, 70);
    
    [_picturebtn addTarget:self action:@selector(picturebtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    back.frame = CGRectMake(10, _askState.frame.origin.y, APPLICATION_WIDTH-20, CGRectGetMaxY(_picturebtn.frame)+20);
    back.layer.masksToBounds = YES;
    back.layer.cornerRadius = 15;
    
    if (![UIUtils isBlankString:askModel.image]) {
        
//        [imag  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",user.host,FileDownload,askModel.image]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        UIImage *result;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",user.host,FileDownload,askModel.image]]];
        
        result = [UIImage imageWithData:data];
        
        [_picturebtn setBackgroundImage:result forState:UIControlStateNormal];

        [whiteView addSubview:pictureLable];

        [whiteView addSubview:_picturebtn];
        
    }
    
//    if ([askModel.askState isEqualToString:@"1"]) {
        UIButton * refusedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        refusedBtn.frame = CGRectMake(20,CGRectGetMaxY(_picturebtn.frame)+40, APPLICATION_WIDTH/2-25, 50);
        refusedBtn.backgroundColor = RGBA_COLOR(249, 0, 7, 1);
        [refusedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refusedBtn setTitle:@"不批准" forState:UIControlStateNormal];
        [whiteView addSubview:refusedBtn];
        
        [self btnMask:refusedBtn withRectCorner:UIRectCornerTopLeft|UIRectCornerBottomLeft];
        UIButton * agreed = [UIButton buttonWithType:UIButtonTypeSystem];
        agreed.frame = CGRectMake(APPLICATION_WIDTH/2+5,CGRectGetMaxY(_picturebtn.frame)+40, APPLICATION_WIDTH/2-25, 50);
        [agreed setTitle:@"批准" forState:UIControlStateNormal];

        agreed.backgroundColor = RGBA_COLOR(30, 143, 78, 1);
        [agreed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [whiteView addSubview:agreed];
    
        [self btnMask:agreed withRectCorner:UIRectCornerTopRight|UIRectCornerBottomRight];
        
        [refusedBtn addTarget:self action:@selector(whetherOrNotApprove:) forControlEvents:UIControlEventTouchUpInside];
        
        [agreed addTarget:self action:@selector(whetherOrNotApprove:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
}
-(void)whetherOrNotApprove:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(whetherOrNotApproveDelegate:)]) {
        btn.tag = [_askModel.askId intValue];
        [self.delegate whetherOrNotApproveDelegate:btn];
    }
}
-(void)btnMask:(UIButton *) btn withRectCorner:(UIRectCorner )a{
    CGRect rect = CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height);
    
    CGSize radio = CGSizeMake(15, 15);//圆角尺寸
    
    UIRectCorner corner = a;//这只圆角位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    
    //创建shapelayer
    masklayer.frame = btn.bounds;
    
    masklayer.path = path.CGPath;
    
    btn.layer.mask = masklayer;

}
-(void)picturebtnPressed:(UIButton *)btn{
    if (!_v) {
        _v = [[imageBigView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        _v.delegate = self;
        
    }
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    UIImage *result;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",user.host,FileDownload,_askModel.image]]];
    
    result = [UIImage imageWithData:data];
    
    [_v addImageViewWithImage:result];
    [self addSubview:_v];
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(picturebtnPressedDelegate:)]) {
//        [self.delegate picturebtnPressedDelegate:btn];
//    }
}
-(void)addPeopleBtnPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addPeopleBtnPressedDelegae)]) {
        [self.delegate addPeopleBtnPressedDelegae];
    }
}
-(void)outSelfView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(outSelfViewDelegate)]) {
        [self.delegate outSelfViewDelegate];
    }
}
-(void)endEdite{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(endEditeDelegate)]) {
        [self.delegate endEditeDelegate];
    }
}
-(void)createGroupBtnPressed:(UIButton *)btn{
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(askForLeaveWithReationDelegate:)]) {
        [self.delegate askForLeaveWithReationDelegate:_introductionView.text];
    }
}
#pragma mark imageBigViewDelegate
-(void)outViewDelegate{
    [_v removeFromSuperview];
    _v = nil;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
