//
//  HomeTableViewCell.m
//  ZhihuDaily
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 1. All rights reserved.
//

#import "HomeTableViewCell.h"
@interface HomeTableViewCell()
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@end

@implementation HomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createbgView];
        
        //将iconImageView，titleLabel 添加到bgView
        self.titleLabel = [UILabel new];
        [self.bgView addSubview:self.titleLabel];
        
        self.iconImageView = [UIImageView new];
        [self.bgView addSubview:self.iconImageView];
        
        //通过SDAutoLayout设置iconImageView，titleLabel的约束
        self.iconImageView.sd_layout.topSpaceToView(self.bgView, 10).leftSpaceToView(self.bgView, 10).widthIs(70).heightIs(60);
        self.titleLabel.sd_layout.topEqualToView(self.iconImageView).leftSpaceToView(self.iconImageView,10).rightSpaceToView(self.bgView, 10).autoHeightRatio(0);
        //这里尝试相对iconImageView布局 autoHeightRatio参数的使用？
        
        //设置cell高度自适应，不确认ImageView和titleLabel哪个更高 用数组传入 
        //[self setupAutoHeightWithBottomViewsArray:@[self.iconImageView,self.titleLabel] bottomMargin:10];
        
        [self.bgView setupAutoHeightWithBottomViewsArray:@[self.iconImageView,self.titleLabel] bottomMargin:10];
        
        [self setupAutoHeightWithBottomViewsArray:@[self.bgView,] bottomMargin:5];
    }
    return self;
}

-(void)createbgView{
    //创建一个自定义View 用于阴影效果
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.bgView.layer.shadowOffset = CGSizeMake(1, 1);
    
    self.bgView.layer.shadowOpacity = 0.3;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.contentView addSubview:self.bgView];
    
    self.bgView.sd_layout.topSpaceToView(self.contentView, 5).leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10);
}

-(void)setModel:(StoriesModel *)model{
    _model =model;
    self.titleLabel.text = model.title;
    NSLog(@"%@",model.title);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.images.firstObject]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    self.backgroundColor =[UIColor whiteColor];
    if (selected) {
        self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }else{
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
}

@end
