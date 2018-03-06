//
//  HomeViewController.m
//  ZhihuDaily
// 
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 1. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "LatestModel.h"
#import "StoriesModel.h"

#define CELLID @"HomeCell"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;
@end

@implementation HomeViewController

#pragma mark -懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //取消cell的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:CELLID];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    
    [self getLatest];
}

#pragma mark - 获取新闻数据
-(void)getLatest{
    [[AFHTTPSessionManager manager] GET:@"https://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [LatestModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"stories":@"StoriesModel"
                    //stories 数组中的对象 对应于StoriesModel模型
                     };
        }];
        LatestModel *model = [LatestModel mj_objectWithKeyValues:responseObject];
        self.datas=model.stories.mutableCopy;
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - UITableView Delegate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.datas[indexPath.row] keyPath:@"model" cellClass:[HomeTableViewCell class] contentViewWidth:self.view.frame.size.width];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CELLID];
    cell.model = self.datas[indexPath.row];
    return cell;
}

-(void)setDatas:(NSMutableArray *)datas{
    _datas=datas;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
