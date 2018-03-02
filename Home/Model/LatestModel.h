//
//  LatestModel.h
//  ZhihuDaily
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StoriesModel;
@interface LatestModel : NSObject
@property (nonatomic,copy)NSString *date;
@property (nonatomic,strong)NSArray<StoriesModel *> *stories;
@property(nonatomic,strong)NSArray *top_stories;

@end
