//
//  PicturesModel.h
//  ZhihuDaily
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicturesModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *ga_prefix;
@property (nonatomic,assign)long long id;
@property (nonatomic,assign)NSInteger type;
@end
