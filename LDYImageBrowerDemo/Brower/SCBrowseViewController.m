//
//  SCBroseViewController.m
//  SocialCalendar
//
//  Created by yang on 15/10/31.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import "SCBrowseViewController.h"
#import "SCImageBrowse.h"
//#import "SCPreSubContentView.h"

#define DURATION 0.4

@interface SCBrowseViewController ()<SCBrowseViewDelegate>
{
    CGFloat _oldAlpha;
    UIStatusBarStyle _statusBarStyle;
}
@property (nonatomic, strong)   SCBrowseView                *browseView;
@property (nonatomic, assign)   BOOL                        isShowSubView;
@property (nonatomic, strong)   UIView                      *headerView;
@property (nonatomic, strong)   UILabel                     *headTitleLabel;
@property (nonatomic, strong)   UIButton                    *rightButton;
@property (nonatomic, assign)   BOOL                        firstAppear;
@end

@implementation SCBrowseViewController
- (instancetype)init
{
    self = [super init];
    if (self) {

        _mediasArray = [[NSMutableArray alloc]init];
        _isShowSubView = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _firstAppear = YES;
    if (!_browseView) {
        _browseView = [[SCBrowseView alloc]initWithFrame:self.view.bounds
                                             mediasArray:_mediasArray
                                                fromRect:_fromRect
                                                   index:_index
                                               direction:_direction
                                             browseStyle:_browseStyle];
        _browseView.delegate = self;
        [self.view addSubview:_browseView];
    }
    [[SCImageBrowse defaulBrowse] refreshBrowseFooterViewWithIndex:_index];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([self isMovingToParentViewController]){
        _oldAlpha = self.navigationController.navigationBar.alpha;
        _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createHeaderView];
    [self createFooterView];


    _firstAppear = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([self isMovingFromParentViewController]){
        self.navigationController.navigationBar.alpha = _oldAlpha;
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
    }
    else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.navigationController.navigationBar.alpha = 1;
    }
}
- (void)createHeaderView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _headerView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        [self.view addSubview:_headerView];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _headerView.frame.size.height - 0.5, _headerView.frame.size.width, 0.1)];
        lineLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [_headerView addSubview:lineLabel];
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 44)];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:backButton];
        
        _headTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerView.frame.size.width / 2.0 - 50, 20, 100, 44)];
        _headTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_index + 1,(long)_mediasArray.count];
        _headTitleLabel.textColor = [UIColor whiteColor];
        _headTitleLabel.font = [UIFont systemFontOfSize:14];
        _headTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_headTitleLabel];
        
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 20, 50, 44)];
//        [_rightButton setTitle:@"更多" forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"sc_navi_item_more_white"] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBUttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_rightButton];
    }
}
- (void)createFooterView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        [self.view addSubview:_footerView];
    }
    [self oneTapBrowseViewWithBrowseView:nil];
}
- (void)oneTapBrowseViewWithBrowseView:(SCBrowseView *)browseView
{
    _isShowSubView = !_isShowSubView;
    if (_isShowSubView) {
        [self showHeaderView];
        [self showFooterView];
    }else{
        [self hiddenHeaderView];
        [self hiddenFooterView];
    }
}
- (void)hiddenHeaderView
{
    [UIView animateWithDuration:DURATION animations:^{
        CGRect frame = _headerView.frame;
        frame.origin.y = -64;
        _headerView.frame = frame;
    }];
}
- (void)showHeaderView
{
    [UIView animateWithDuration:DURATION animations:^{
        CGRect frame = _headerView.frame;
        frame.origin.y = 0;
        _headerView.frame = frame;
    }];
}
- (void)showFooterView
{
    [UIView animateWithDuration:DURATION animations:^{
        CGRect frame = _footerView.frame;
        frame.origin.y = _browseView.frame.size.height - _footerView.frame.size.height;
        _footerView.frame = frame;
    }];
}
- (void)hiddenFooterView
{
    [UIView animateWithDuration:DURATION animations:^{
        CGRect frame = _footerView.frame;
        frame.origin.y = _browseView.frame.size.height;
        _footerView.frame = frame;
    }];
}
- (void)browseView:(SCBrowseView *)browseView ChangeIndex:(NSInteger)index
{
    _index = index;
    _headTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_index + 1,(long)_mediasArray.count];

}
- (void)browseView:(SCBrowseView *)browseView didscrollView:(UIScrollView *)scrollView
{
    if (_isShowSubView && _firstAppear == NO) {
        _isShowSubView = NO;
        [self hiddenHeaderView];
        [self hiddenFooterView];
    }
}
- (void)rightBUttonClicked:(UIButton *)button
{
    [_browseView createAcctionSheet];
}
- (void)back:(UIButton *)button
{
    [[SCImageBrowse defaulBrowse]showNavigation];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
