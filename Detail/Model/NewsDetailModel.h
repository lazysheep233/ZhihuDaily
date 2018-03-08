//
//  NewsDetailModel.h
//  ZhihuDaily
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SectionModel;

@interface NewsDetailModel : NSObject
@property (nonatomic,copy)NSString *HTML;
@property (nonatomic,copy)NSString *body;
@property (nonatomic,copy)NSString *image_source;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *share_url;
@property (nonatomic,copy)NSString *ga_prefix;

@property (nonatomic,strong)NSArray *js;
@property (nonatomic,strong)NSArray *css;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)long long id;

@property (nonatomic,assign)SectionModel *section;

//在特殊情况下，知乎日报可能将某个主题日报的站外文章推送至知乎日报首页
@property (nonatomic,assign)NSInteger theme_id;
@property (nonatomic,copy)NSString *editor_name;
@property (nonatomic,copy)NSString *theme_name;
@end
