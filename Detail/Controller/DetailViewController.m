//
//  DetailViewController.m
//  ZhihuDaily
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 1. All rights reserved.
//

#import "DetailViewController.h"
#import "NewsDetailModel.h"
#import "SectionModel.h"

@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NewsDetailModel *model;
@end

@implementation DetailViewController
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate =self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        
        _webView.frame = CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-20);
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self getNewsDetailForId:self.stroiesModel.id];
    // Do any additional setup after loading the view.
}

-(void)getNewsDetailForId:(NSInteger)ID{
    //NSLog(@"%  ld",(long)ID);
    [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/%ld",ID]  parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        
        [NewsDetailModel mj_setupObjectClassInArray:^NSDictionary *{
           return @{
              @"section":@"SectionModel"
              };
        }];
        NewsDetailModel *model = [NewsDetailModel mj_objectWithKeyValues:responseObject];
        model.HTML = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",model.css[0],model.body];
        //这里拼接的HTML文件中的CSS样式表为HTTP加载，需要设置允许HTTP链接
        self.model = model;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)setModel:(NewsDetailModel *)model{
    _model = model;
    [self.webView loadHTMLString:model.HTML baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
