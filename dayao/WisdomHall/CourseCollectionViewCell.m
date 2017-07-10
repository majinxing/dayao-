//
//  CourseCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CourseCollectionViewCell.h"
#import "DYHeader.h"
#import "MeetingModel.h"
#import "ClassModel.h"

@interface CourseCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *classOrMeetingName;
@property (strong, nonatomic) IBOutlet UILabel *hostName;
@property (strong, nonatomic) IBOutlet UILabel *place;
@property (strong, nonatomic) IBOutlet UILabel *time;


@end
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
-(void)setInfoForContentView:(MeetingModel *)meetingModel{
    _classOrMeetingName.text = [NSString stringWithFormat:@"会议名：%@",meetingModel.meetingName];
    
    _hostName.text = [NSString stringWithFormat:@"主持人：%@",meetingModel.meetingHost];
    
    _place.text = [NSString stringWithFormat:@"会议地点：%@",meetingModel.meetingPlace];
    
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",meetingModel.meetingTime];
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];

    _time.text = [NSString stringWithFormat:@"时  间：%@",strUrl];
}

-(void)setClassInfoForContentView:(ClassModel *)classModel{
    _classOrMeetingName.text = [NSString stringWithFormat:@"课程名：%@",classModel.name];
    
    _hostName.text = [NSString stringWithFormat:@"老师：%@",classModel.teacherId];
    
    _place.text = [NSString stringWithFormat:@"上课地点：%@",classModel.address];
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",classModel.time];
    
    [strUrl deleteCharactersInRange:NSMakeRange(0,5)];
    
    _time.text = [NSString stringWithFormat:@"时  间：%@",strUrl];
}
@end
