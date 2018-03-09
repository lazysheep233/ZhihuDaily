//
//  HomeViewController.m
//  ZhihuDaily
// 
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 1. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"

#import "HomeTableViewCell.h"
#import "LatestModel.h"
#import "StoriesModel.h"
#import "PicturesView.h"

#define CELLID @"HomeCell"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)PicturesView *picturesView;
@property (nonatomic,strong)LatestModel *latestModel;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *leftBtn;
@end

@implementation HomeViewController

#pragma mark -懒加载
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        label.attributedText = [[NSAttributedString alloc] initWithString:@"今日要闻" attributes:@{
                                                                                               NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                               }
        ];
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
        _titleLabel = label;
    }
    return _titleLabel;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]init];
        [_leftBtn addTarget:self action:@selector(didLeftMenuButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_leftBtn setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        
    }
   
    return _leftBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //取消cell的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:CELLID];
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _tableView.tableHeaderView=view;
        
    }
    return _tableView;
}
-(PicturesView *)picturesView{
    if (!_picturesView) {
        _picturesView=[[PicturesView alloc]init];
        _picturesView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 220);
        
    }
    return _picturesView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:0];
        _headView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 56);
        [_headView addSubview:self.leftBtn];
        [_headView addSubview:self.titleLabel];
        
        self.leftBtn.sd_layout.topSpaceToView(_headView, 20).leftSpaceToView(_headView, 12).widthIs(30).heightIs(30);
        self.titleLabel.sd_layout.centerXEqualToView(_headView).topSpaceToView(_headView, 20).widthIs(150).heightIs(30);
    }
    
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    //这里headView添加在最前面会被覆盖
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.picturesView];
    [self.view addSubview:self.headView];
   
    //self.picturesView.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(220);
    
    [self getLatest];
}

#pragma mark - 获取新闻数据
-(void)getLatest{
    [[AFHTTPSessionManager manager] GET:@"https://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        [LatestModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"stories":@"StoriesModel",
                    //stories 数组中的对象 对应于StoriesModel模型
                     @"top_stories":@"PicturesModel"
                     };
        }];
        LatestModel *model = [LatestModel mj_objectWithKeyValues:responseObject];
        self.datas=model.stories.mutableCopy;
        self.latestModel=model;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的点击事件
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.stroiesModel = self.datas[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    //NSLog(@"%ld",(long)indexPath.row);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yOffset = self.tableView.contentOffset.y;
        if (yOffset<0) {
            self.picturesView.height = 220 - yOffset;
            CGRect frame = self.picturesView.frame;
            frame.origin.y=0;
            self.picturesView.frame = frame;
        }else{
            CGRect frame = self.picturesView.frame;
            frame.origin.y = 0-yOffset;
            self.picturesView.frame = frame;

        }
        CGFloat alpha=0;
        int alphaStart=60;
        if (yOffset<alphaStart) {
            alpha=0;
        }else if (yOffset<165){
            alpha = (yOffset - alphaStart)/(165-alphaStart);
        }else{
            alpha =1;
        }
        //NSLog(@"yOffset:%f",yOffset);
        _headView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:alpha];

    }
}

-(void)setDatas:(NSMutableArray *)datas{
    _datas=datas;
    [self.tableView reloadData];
}

-(void)setLatestModel:(LatestModel *)latestModel{
    _latestModel=latestModel;
    self.picturesView.images = latestModel.top_stories;
}

-(void)didLeftMenuButton:(UIButton *)btn{
    //左侧菜单栏按钮点击事件
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
