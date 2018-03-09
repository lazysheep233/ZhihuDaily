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
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)NewsDetailModel *model;
@end

@implementation DetailViewController
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate =self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        
        [_webView.scrollView addObserver:self forKeyPath:@"webViewOffset" options:NSKeyValueObservingOptionNew context:nil];
        //[_webView.scrollView addObserver:self forKeyPath:@"webViewOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        _webView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
        
    }
    return _webView;
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [UIView new];
        _headView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:1];
        _headView.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 56);
        [_headView addSubview:self.backBtn];
        
        
        self.backBtn.sd_layout.topSpaceToView(_headView, 22).leftSpaceToView(_headView, 12).widthIs(25).heightIs(25);
        
    }
    
    return _headView;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(didBackButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [_backBtn setImage:[UIImage imageNamed:@"back-1"] forState:UIControlStateNormal];
        
    }
    
    return _backBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self getNewsDetailForId:self.stroiesModel.id];
    
    [self.view addSubview:self.headView];
    // Do any additional setup after loading the view.
}

-(void)didBackButton:(UIButton *)btn{
    //返回首页
    [self.navigationController popViewControllerAnimated:YES];
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
        //这里拼接的HTML文件中 CSS外部加载样式表为HTTP加载，需要设置允许HTTP链接
        self.model = model;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)setModel:(NewsDetailModel *)model{
    _model = model;
    [self.webView loadHTMLString:model.HTML baseURL:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"webViewOffset"]) {
        CGFloat yOffset = self.webView.scrollView.contentOffset.y;
        NSLog(@"yOffset:%f",yOffset);
        CGFloat alpha=1;
        int alphaStart=60;
        if (yOffset<alphaStart) {
            alpha=1;
        }else if (yOffset<165){
            alpha = (yOffset - alphaStart)/(165-alphaStart);
        }else{
            alpha =0;
        }
       
        _headView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:alpha];
        
    }
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
