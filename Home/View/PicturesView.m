//
//  PicturesView.m
//  ZhihuDaily
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 1. All rights reserved.
//

#import "PicturesView.h"
#import "PicturesModel.h"
#import "PicturesImageView.h"
@interface PicturesView()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pagecontrol;
@property (nonatomic,strong)NSMutableArray *imageViews;
@property (nonatomic,strong)NSTimer *timer;
@end
@implementation PicturesView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        [self addSubview:scrollView];
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView =scrollView;
        
        UIPageControl *page = [[UIPageControl alloc]init];
        self.pagecontrol = page;
        [self addSubview:page];
        
        scrollView.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        page.sd_layout.centerXEqualToView(self).widthIs(60).heightIs(15).bottomSpaceToView(self, 10);
        
    }
    return self;
}
-(void)setImages:(NSArray *)images{
    _images=images;
    
    self.pagecontrol.numberOfPages = images.count;
    
    for (PicturesModel *model in images) {
        PicturesImageView *imageView = [[PicturesImageView alloc]init];
        imageView.model = model;
        
        [self.scrollView addSubview:imageView];
        
        if (self.imageViews.count==0) {
            imageView.sd_layout.topSpaceToView(self.scrollView, 0).leftSpaceToView(self.scrollView, 0).bottomSpaceToView(self.scrollView, 0).widthRatioToView(self.scrollView,1);
        }else{
            imageView.sd_layout.topSpaceToView(self.scrollView, 0).leftSpaceToView([self.imageViews lastObject], 0).bottomSpaceToView(self.scrollView, 0).widthRatioToView(self.scrollView,1);
        }
        [self.imageViews addObject:imageView];
        self.scrollView.contentSize = CGSizeMake(self.images.count*self.width, self.height);
    }
    [self addTimer];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = scrollView.contentOffset.x;
    //NSLog(@"%f",xOffset);
    int currentPage = (int)(xOffset/self.width+0.5);
    self.pagecontrol.currentPage = currentPage;
    //NSLog(@"currentpage:%d",currentPage);
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //当用户滚动时关闭计时器轮播
    [self removeTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //用户滚动结束时调用 重新开启计时轮播
    [self addTimer];
}
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    NSLog(@"");
}
-(void)removeTimer{
    [self.timer invalidate];
}
-(void)nextImage{
    NSInteger page = (self.pagecontrol.currentPage + 1) % self.pagecontrol.numberOfPages;
    //NSLog(@"currentpage:%ld",(long)page);
    CGFloat xOffset = page * self.width;
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:YES];
}
-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
        
    }
    return _imageViews;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
