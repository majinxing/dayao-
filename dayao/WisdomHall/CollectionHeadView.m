//
//  CollectionHeadView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CollectionHeadView.h"
#import "DYHeader.h"

@interface CollectionHeadView()<UIScrollViewDelegate>
@property (nonatomic,strong)NSTimer * rotateTimer;
@property (nonatomic,strong)UIPageControl * myPageControl;
@end
@implementation CollectionHeadView
- (instancetype) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addScrollView];
        [self getData];
    }
    return self;
}
-(void)getData{
    [[NetworkRequest sharedInstance] GET:QueryAdvertising dict:nil succeed:^(id data) {
//        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        
    }];
}
-(void)addScrollView{
    UIScrollView * s = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    s.backgroundColor = [UIColor greenColor];
    s.contentSize = CGSizeMake(APPLICATION_WIDTH*3, APPLICATION_HEIGHT/4);
    s.scrollEnabled = YES;//是否可以滚动
    s.pagingEnabled = YES;//是否整页滚动
    s.showsVerticalScrollIndicator = NO;//水平方向的滚动条
    s.showsHorizontalScrollIndicator = NO;
    s.bounces = NO;
    [self addSubview:s];
    for (int i = 0; i<3; i++) {
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH*i, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
        if (i==0) {
            v.backgroundColor = [UIColor redColor];
            UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
            i.image = [UIImage imageNamed:@"abc_adv_3"];
            [v addSubview:i];
        }else if (i==1){
            v.backgroundColor = [UIColor greenColor];
            UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
            i.image = [UIImage imageNamed:@"abc_adv_3"];
            [v addSubview:i];
        }else if(i==2){
            v.backgroundColor = [UIColor blueColor];
            UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
            i.image = [UIImage imageNamed:@"abc_adv_3"];
            [v addSubview:i];
        }
        [s addSubview:v];
    }
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH*3, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    v.backgroundColor = [UIColor redColor];
    s.tag = 1000;
    UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    i.image = [UIImage imageNamed:@"abc_adv_3"];
    [v addSubview:i];

    [s addSubview:v];
    
    _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT/4-20, CGRectGetWidth(self.frame), 20)];
    _myPageControl.numberOfPages = 3;
    _myPageControl.currentPage = 0;
    [self addSubview:_myPageControl];
    
    //启动定时器
    _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    
    s.delegate = self;
}
-(void)changeView{
    //得到scrollView
    UIScrollView *scrollView = [self viewWithTag:1000];
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += CGRectGetWidth(self.frame);
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > CGRectGetWidth(self.frame)*3) {
        scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.frame)*3) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.frame);
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.frame)*3) {
        self.myPageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
}

#pragma mark UIScrollerView
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过1.5秒在开启定时器
    //[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
//    NSLog(@"开启定时器");
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
    
    //拖拽的时候改变白点的位置
    float offset_X = scrollView.contentOffset.x;
    
    if (offset_X == CGRectGetWidth(self.frame)*3) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.frame);
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
