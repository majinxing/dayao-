//
//  StatisticalResultTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalResultTableViewCell.h"
#import "StatisticalResultModel.h"
#import "DYHeader.h"

@interface StatisticalResultTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *actLabel;
@property (strong, nonatomic) IBOutlet UIView *bView;
@property (strong, nonatomic) IBOutlet UILabel *attendanceLabel;
@property (nonatomic,strong) UIView * colorView;

@property (strong, nonatomic) IBOutlet UILabel *nameSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *absenceSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *leaveSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *actSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *attendanceRateSecLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateSecLabel;
@property (strong, nonatomic) IBOutlet UIView *bSecView;

@property (strong, nonatomic) IBOutlet UILabel *teacherSecName;
@property (strong, nonatomic) IBOutlet UILabel *leaveEarlyLab;
@property (strong, nonatomic) IBOutlet UILabel *lateLab;

@end

@implementation StatisticalResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bView.layer.masksToBounds = YES;
    _bView.layer.borderColor = RGBA_COLOR(231, 231, 231, 0.7).CGColor;
    _bView.layer.borderWidth = 1;
    _colorView = [[UIView alloc] init];
    _bSecView.layer.masksToBounds = YES;
    _bSecView.layer.borderColor = RGBA_COLOR(231, 231, 231, 0.7).CGColor;
    _bSecView.layer.borderWidth = 1;
    
    _nameSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _totalSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _absenceSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _leaveSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _actSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _attendanceRateSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _rateSecLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _leaveEarlyLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _lateLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    // Initialization code
}
-(void)addContentView:(StatisticalResultModel *)s{
    _nameLabel.text = [NSString stringWithFormat:@"名        称：   %@",s.resultName];
    
    int actInt = [[NSString stringWithFormat:@"%@",s.actNum] intValue]+[[NSString stringWithFormat:@"%@",s.leaveEarlyNum] intValue]+[[NSString stringWithFormat:@"%@",s.lateNum] intValue];
    
    _totalLabel.text = [NSString stringWithFormat:@"应到人数：   %@人",s.totalNum];
    
    _actLabel.text = [NSString stringWithFormat:@"实到人数：   %d人",actInt];
    
    
    
    double n = [s.actNum doubleValue] + [s.lateNum doubleValue] + [s.leaveEarlyNum doubleValue];
    
    s.attendanceRate = [NSString stringWithFormat:@"%lf",n/([s.totalNum doubleValue] + [s.leaveNum doubleValue])*100];
    
    _attendanceLabel.text = [NSString stringWithFormat:@"%.0f%%",[s.attendanceRate doubleValue]];
    
    _colorView.frame = CGRectMake(0, 0, self.bView.frame.size.width*[s.attendanceRate doubleValue]/100, 21);
    
    if (0<=[s.attendanceRate doubleValue]&&[s.attendanceRate doubleValue]<=20) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#e51c23"];
        _attendanceLabel.textColor = [UIColor colorWithHexString:@"#e51c23"];

    }else if (20<[s.attendanceRate doubleValue]&&[s.attendanceRate doubleValue]<=60) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#eb3d52"];
        _attendanceLabel.textColor = [UIColor colorWithHexString:@"#eb3d52"];
    }else if (60<[s.attendanceRate doubleValue]&&[s.attendanceRate doubleValue]<=80) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#45b033"];
        _attendanceLabel.textColor = [UIColor colorWithHexString:@"#45b033"];
    }else if (80<[s.attendanceRate doubleValue]&&[s.attendanceRate doubleValue]<=100) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#259b24"];
        _attendanceLabel.textColor = [UIColor colorWithHexString:@"#259b24"];
    }
    
    [self.bView addSubview:_colorView];
}
-(void)addSecContentView:(StatisticalResultModel *)s{
    _nameSecLabel.text = [NSString stringWithFormat:@"名      称：   %@",s.resultName];
    
    _totalSecLabel.text = [NSString stringWithFormat:@"应到人数：   %@人",s.totalNum];
    
    int actInt = [[NSString stringWithFormat:@"%@",s.actNum] intValue]+[[NSString stringWithFormat:@"%@",s.leaveEarlyNum] intValue]+[[NSString stringWithFormat:@"%@",s.lateNum] intValue];
    
    _actSecLabel.text = [NSString stringWithFormat:@"实到人数：   %d人",actInt];
    
    _leaveSecLabel.text = [NSString stringWithFormat:@"请假人数：   %@人",s.leaveNum];
    
    int absenceInt = [[NSString stringWithFormat:@"%@",s.totalNum] intValue] - actInt;
    
    _absenceSecLabel.text = [NSString stringWithFormat:@"缺勤人数：   %d人",absenceInt];
    
    _leaveEarlyLab.text = [NSString stringWithFormat:@"早退人数：   %@",s.leaveEarlyNum];
    
    _lateLab.text = [NSString stringWithFormat:@"迟到人数：   %@",s.lateNum];
    
    _teacherSecName.text = [NSString stringWithFormat:@"教师名字：   %@",s.teacherName];
    
    if ([UIUtils isBlankString:_teacherSecName.text]) {
//        _teacherSecName.frame.size.height = 0;
    }
    
    double attendanceRate = (double)actInt/[[NSString stringWithFormat:@"%@",s.totalNum] doubleValue]*100;
    
    _colorView.frame = CGRectMake(0, 0, self.bSecView.frame.size.width*attendanceRate/100, 21);
    
    _rateSecLabel.text = [NSString stringWithFormat:@"%.0f%%",attendanceRate];
    
    [self.bSecView addSubview:_colorView];
    
    if (0<=attendanceRate&&attendanceRate<=20) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#e51c23"];
        _rateSecLabel.textColor = [UIColor colorWithHexString:@"#e51c23"];
        
    }else if (20<attendanceRate&&attendanceRate<=60) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#eb3d52"];
        _rateSecLabel.textColor = [UIColor colorWithHexString:@"#eb3d52"];
    }else if (60<attendanceRate&&attendanceRate<=80) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#45b033"];
        _rateSecLabel.textColor = [UIColor colorWithHexString:@"#45b033"];
    }else if (80<attendanceRate&&attendanceRate<=100) {
        _colorView.backgroundColor = [UIColor colorWithHexString:@"#259b24"];
        _rateSecLabel.textColor = [UIColor colorWithHexString:@"#259b24"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
