//
//  PicturesImageView.m
//  ZhihuDaily
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 1. All rights reserved.
//

#import "PicturesImageView.h"
@interface PicturesImageView()
@property (nonatomic,strong)UILabel *titleLabel;
@end
@implementation PicturesImageView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.titleLabel =[UILabel new];
        [self addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        self.titleLabel.sd_layout.centerXEqualToView(self).rightSpaceToView(self, 25).leftSpaceToView(self, 25).bottomSpaceToView(self, 35).autoHeightRatio(0);
    }
    return self;
}
-(void)setModel:(PicturesModel *)model{
    _model = model;
    [self sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
