//
//  StoriesModel.h
//  ZhihuDaily
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoriesModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *ga_prefix;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)long long id;
@end
