/*
 Copyright (c) 2014-2015, GoBelieve
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "InMessageCell.h"
#import "MessageTextView.h"
#import "MessageImageView.h"
#import "MessageAudioView.h"
#import "MessageNotificationView.h"
#import "MessageLocationView.h"
#import "MessageLinkView.h"
#import "MessageVOIPView.h"
#import "MessageUnknownView.h"
#import "TriangleView.h"
#import "UIImageView+WebCache.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import <Masonry/Masonry.h>
#import "Masonry.h"
@interface InMessageCell()

@property (nonatomic) TriangleView *triangleView;
@property(nonatomic,strong)UserModel * user;
@end

@implementation InMessageCell
-(id)initWithType:(int)type reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithType:type reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect frame = CGRectMake(52,
                                  0,
                                  self.contentView.frame.size.width - 24,
                                  NAME_LABEL_HEIGHT);
        
        self.nameLabel = [[UILabel alloc] initWithFrame:frame];
        self.nameLabel.font =  [UIFont systemFontOfSize:14.0f];
        self.nameLabel.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:self.nameLabel];
        
        
        frame = CGRectMake(2, 0, 40, 40);
        
        self.headView = [[UIImageView alloc] initWithFrame:frame];
        
        self.headView.layer.masksToBounds = YES;
        
        self.headView.layer.cornerRadius = self.headView.frame.size.height/2;
        
        [self.contentView addSubview:self.headView];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor whiteColor];
        CALayer *imageLayer = [self.containerView layer];
        [imageLayer setMasksToBounds:YES];
        [imageLayer setCornerRadius:4];
        [self.contentView addSubview:self.containerView];
        
        self.triangleView = [[TriangleView alloc] init];
        self.triangleView.fillColor = [UIColor whiteColor];
        self.triangleView.backgroundColor = [UIColor clearColor];
        self.triangleView.right = NO;
        [self.contentView addSubview:self.triangleView];

        [self.contentView bringSubviewToFront:self.bubbleView];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.headView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(NAME_LABEL_HEIGHT);
        }];
        
        [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TRIANGLE_WIDTH, TRIANGLE_HEIGHT));
            make.top.equalTo(self.containerView.mas_top).with.offset(10);
            make.right.equalTo(self.containerView.mas_left);
        }];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.top.equalTo(self.contentView.mas_top);
        }];
        
        [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_top).with.offset(8);
            make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-8);
            make.left.equalTo(self.containerView.mas_left).offset(8);
            make.right.equalTo(self.containerView.mas_right).offset(-8);
        }];
        

    }
    _user = [[Appsetting sharedInstance] getUsetInfo];
    return self;
}


- (void)setSelectedToShowCopyMenu:(BOOL)isSelected{
    [super setSelectedToShowCopyMenu:isSelected];
    if (self.selectedToShowCopyMenu) {
        self.containerView.backgroundColor = RGBCOLOR(229, 229, 229);
        self.triangleView.fillColor = RGBCOLOR(229, 229, 229);
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.triangleView.fillColor = [UIColor whiteColor];
    }
}


- (void)setMsg:(IMessage*)message {
    [super setMsg:message];
    
    NSString *name = self.msg.senderInfo.name;
    if (name.length == 0) {
        name = self.msg.senderInfo.identifier;
    }
    
    self.nameLabel.text = [UIUtils getGPeopleName:[NSString stringWithFormat:@"%lld",self.msg.sender]];
    
    if ([UIUtils isBlankString:self.nameLabel.text]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",self.msg.sender],@"id", nil];
        
        [[NetworkRequest sharedInstance] GET:QuerySelfInfo dict:dict succeed:^(id data) {
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            if ([str isEqualToString:@"成功"]) {
                self.nameLabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"name"]];//self.conversation.name;
                NSString * pId = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"pictureId"]];
                
                [[Appsetting sharedInstance] sevePeopleId:[NSString stringWithFormat:@"%lld",self.msg.sender] withPeopleName:self.nameLabel.text withPeoplePictureId:pId];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
//    self.nameLabel.text = name;
    
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.hidden = !self.showName;
    
    UIImage *placehodler = [UIImage imageNamed:@"PersonalChat"];
    
    NSURL *url = [NSURL URLWithString:self.msg.senderInfo.avatarURL];
    

    NSString * pictId = [UIUtils getGPeoplePictureId:[NSString stringWithFormat:@"%lld",self.msg.sender]];
    
    if ([UIUtils isBlankString:pictId]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",self.msg.sender],@"id", nil];
        
        [[NetworkRequest sharedInstance] GET:QuerySelfInfo dict:dict succeed:^(id data) {
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            if ([str isEqualToString:@"成功"]) {
                
                NSString * picId = [[data objectForKey:@"body"] objectForKey:@"pictureId"];
                
                [[Appsetting sharedInstance] sevePeopleId:[NSString stringWithFormat:@"%lld",self.msg.sender] withPeopleName:[[data objectForKey:@"body"] objectForKey:@"name"] withPeoplePictureId:pictId];
                
                if(![UIUtils isBlankString:[NSString stringWithFormat:@"%@",picId]]){
                    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",_user.host,FileDownload,picId]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",_user.host,FileDownload,pictId]];
        
        //    url = [NSURL URLWithString:@"%@",[UIUtils getGPeoplePictureId:[NSString stringWithFormat:@"%lld",self.msg.sender]]];
        
        [self.headView sd_setImageWithURL: url placeholderImage:placehodler
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                }];
    }
    
    
    
    self.bubbleView.msg = message;
    
    [self setNeedsUpdateConstraints];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"senderInfo"]) {
        if (self.showName) {
            if (self.msg.senderInfo.name.length > 0) {
                self.nameLabel.text = self.msg.senderInfo.name;
            } else {
                self.nameLabel.text = self.msg.senderInfo.identifier;
            }
        }

        UIImage *placehodler = [UIImage imageNamed:@"PersonalChat"];
        NSURL *url = [NSURL URLWithString:self.msg.senderInfo.avatarURL];
        [self.headView sd_setImageWithURL: url placeholderImage:placehodler
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                }];

    }
}

- (CGSize)bubbleSize {
    return [self.bubbleView bubbleSize];
}


- (void)updateConstraints {
    CGSize size = [self bubbleSize];
    
    size.width += 16;
    size.height += 16;
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_right).with.offset(10);
        make.size.mas_equalTo(size);
        if (self.showName) {
            make.top.equalTo(self.contentView.mas_top).with.offset(NAME_LABEL_HEIGHT);
        } else {
            make.top.equalTo(self.contentView.mas_top);
        }
    }];
    
    [super updateConstraints];
}


@end

