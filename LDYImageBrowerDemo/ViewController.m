//
//  ViewController.m
//  LDYImageBrowerDemo
//
//  Created by yang on 2017/7/7.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import "ViewController.h"
#import "SCImageBrowse.h"

@interface ViewController ()

@property (nonatomic, assign) SCBrowseStyle showStyle;
@property (nonatomic, strong) NSMutableArray    *imageAry;
@property (nonatomic, strong) NSMutableArray    *btnAry;

@end

@implementation ViewController

- (void)viewDidLoad {
    _btnAry = [NSMutableArray array];
    _imageAry = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [_imageAry addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]]];
    }
    [super viewDidLoad];
    [self createStyleButton];
    [self createImageView];
    
}
- (void)createStyleButton
{
    CGFloat cW = 50.0;
    CGFloat cH = 30.0;
    CGFloat cY = 70.0f;
    CGFloat cX = 10.0f;
    for (int i = 0; i < 2; i++) {
        cX = 10.0f + i * (cW + 5.0f);
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cX, cY, cW, cH)];
        [button setTitle:[NSString stringWithFormat:@"style%d",i + 1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_btnAry addObject:button];
    }
    [self buttonClicked:_btnAry[0]];
}
- (void)buttonClicked:(UIButton *)button
{
    for (UIButton *btn in _btnAry) {
        if (button == btn) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    _showStyle = button.tag - 1000;
}
- (void)createImageView
{
    NSInteger column = 3;
    CGFloat cW = CGRectGetWidth(self.view.frame) / column;
    CGFloat cH = cW;
    CGFloat cY = 100.0f;
    CGFloat cX = 0.0f;
    
    for (int i = 0; i < _imageAry.count; i++) {
        cY = i / column * cH + 110.0f;
        cX = i % column * cW;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cX, cY, cW, cH)];
        imageView.image = _imageAry[i];
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:tap];
    }
}
- (void)imageViewTap:(UITapGestureRecognizer *)tap
{
    UIImageView *tapView = (UIImageView *)tap.view;
    [[SCImageBrowse defaulBrowse] showBrowseViewWithMediasArray:_imageAry
                                                       fromView:tapView
                                                       fromRect:CGRectZero
                                                          index:tapView.tag
                                                      direction:SCBrowseDirectionHorizontal
                                                    browseStyle:_showStyle];
}
@end
