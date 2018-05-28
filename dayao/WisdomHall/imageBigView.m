//
//  imageBigView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/24.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "imageBigView.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"

@implementation imageBigView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10,40, APPLICATION_WIDTH-20, self.frame.size.height- 80)];
        self.backgroundColor = [UIColor whiteColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, self.frame.size.height)];
        
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
        // 缩放手势
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        
        [_backView addGestureRecognizer:pinchGestureRecognizer];
        
        // 移动手势
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        
        [_backView addGestureRecognizer:panGestureRecognizer];
        
    }
    return self;
}
// 处理缩放手势

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer

{
    
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        if (view.frame.size.width>APPLICATION_WIDTH/4*3) {
            view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            
            pinchGestureRecognizer.scale = 1;
        }else if (pinchGestureRecognizer.scale>1){
            view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            
            pinchGestureRecognizer.scale = 1;
        }
    }
}
// 处理拖拉手势

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer

{
    
    UIView *view = panGestureRecognizer.view;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        
    }
    
}
-(void)addImageView:(NSString *)str{
    
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSString * baseUrl = user.host;
    
    [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,str]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(self.frame.size.width-40, 0,40, 40);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView addSubview:_imageview];
    
    [self addSubview:btn];
}
-(void)addImageViewWithImage:(UIImage  *)image1{
    
    
    _imageview.image = image1;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(self.frame.size.width-40, 0,40, 40);
    
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [_backView addSubview:_imageview];
    
    [self addSubview:btn];
}

-(void)outView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(outViewDelegate)]) {
        [self.delegate outViewDelegate];
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
