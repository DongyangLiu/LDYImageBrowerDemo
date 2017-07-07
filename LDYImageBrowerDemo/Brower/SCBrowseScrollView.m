//
//  SCBrowseScrollView.m
//  SocialCalendar
//
//  Created by yang on 15/10/30.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import "SCBrowseScrollView.h"

#define duration 0.4

@interface SCBrowseScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign)   CGRect          fromRect;
@property (nonatomic, strong)   UIImage         *image;
@property (nonatomic, strong)   UIImageView     *imageView;
@property (nonatomic, assign)   CGSize          mainSize;
@property (nonatomic, assign)   CGFloat         scale;
@property (nonatomic, assign)   SCBrowseStyle   browseStyle;
@property (nonatomic, assign)   BOOL            isShowSubView;
@property (nonatomic, strong)   UIView          *headerView;
@property (nonatomic, strong)   UIView          *footerView;

@end

@implementation SCBrowseScrollView

- (instancetype)initWithFrame:(CGRect)frame
                  browseStyle:(SCBrowseStyle)browseStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        _mainSize = [[[UIApplication sharedApplication] delegate] window].bounds.size;
        _scale = 2;
        self.maximumZoomScale = _scale;
        self.minimumZoomScale = 1.0;
        self.delegate = self;
        _browseStyle = browseStyle;
        _isShowSubView = YES;
    }
    return self;
}
- (void)setImageViewWith:(UIImage *)image
                fromRect:(CGRect)fromRect
                 animate:(BOOL)animate
{
    _fromRect = fromRect;
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:fromRect];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.image = [UIImage imageNamed:@"10.jpg"];
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
        oneTap.numberOfTapsRequired = 1;
        oneTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:oneTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTap];
        [oneTap requireGestureRecognizerToFail:doubleTap];
        
        if (_browseStyle == SCBrowseStyleDefault) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
            [_imageView addGestureRecognizer:longPress];
            [oneTap requireGestureRecognizerToFail:longPress];
            [doubleTap requireGestureRecognizerToFail:longPress];
        }
    }
    [self recoverNormalScale];
    
    _imageView.image = image;
    [self enterFullScreen:animate];
}
#pragma mark - tap
- (void)oneTap:(UITapGestureRecognizer *)tap
{
    if (_browseStyle == SCBrowseStyleDefault) {
        if (self.zoomScale != 1.0) {
            [self doubleTap:tap];
        }
        [self quitFullScreen:YES];
    }
    if (_browseStyle == SCBrowseStyleSubView) {
        if ([_browseDelegate respondsToSelector:@selector(oneTapTouchBrowseScrollView)]) {
            [_browseDelegate oneTapTouchBrowseScrollView];
        }
    }
}
- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    UIImage *dealImage = _imageView.image;
    if (dealImage != nil) {//图片加载成功
        //判定触摸点是否在图片内部
        CGPoint point = _imageView.center;
        if (tap) {
            point = [tap locationInView:_imageView];//获取触摸点相对于image的坐标
        }
        CGFloat tempX = _imageView.frame.size.width;
        CGFloat tempY = _imageView.frame.size.height;
        
        CGFloat pointX = point.x * self.zoomScale;
        CGFloat pointY = point.y * self.zoomScale;
        
        if (pointX > 0.0 && pointY > 0.0 && pointX < tempX && pointY < tempY) {
            if (self.zoomScale >= _scale) {//当前图片已经最大化
                [self zoomToRect:[self getRectWithScale:1 andCenter:point] animated:YES];
            } else {//当前图片未最大化
                [self zoomToRect:[self getRectWithScale:_scale andCenter:point] animated:YES];
            }
        }
    }
}
- (void)longPressTap:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if ([_browseDelegate respondsToSelector:@selector(longPressTouchBrowseScrollView)]) {
            [_browseDelegate longPressTouchBrowseScrollView];
        }
    }
}
#pragma mark - enter or quit FullScreen
- (void)enterFullScreen:(BOOL)animated
{
    CGFloat factor = 1;
    if (_imageView.image != nil) {
        factor = _imageView.image.size.width / _imageView.image.size.height;
    }
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    if (factor > _mainSize.width / _mainSize.height ) {
        width = _mainSize.width;
        height = _mainSize.width / factor;
        x = 0.0;
        y = _mainSize.height / 2.0 - height / 2.0;
    }else{
        height = _mainSize.width / factor;
        width = _mainSize.width;
        x = _mainSize.width / 2.0 - width / 2.0;
        y = 0.0;
    }
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            _imageView.frame = CGRectMake(x, y, width, height);
        }];
    }else{
        _imageView.frame = CGRectMake(x, y, width, height);
    }
    self.contentSize = CGSizeMake(MAX(self.frame.size.width, _imageView.frame.size.width), MAX(self.frame.size.height, _imageView.frame.size.height));
    
}
- (void)quitFullScreen:(BOOL)animated
{
    if (animated) {
        [SCImageBrowse defaulBrowse].browseView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:duration animations:^{
            _imageView.frame = _fromRect;
        } completion:^(BOOL finished) {
            [[SCImageBrowse defaulBrowse] hiddenBroseView];
        }];
    }else{
        _imageView.frame = _fromRect;
        [[SCImageBrowse defaulBrowse] hiddenBroseView];
    }
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1.0) {
        CGFloat tempX = 0.0;
        CGFloat tempY = 0.0;
        CGFloat tempW = _imageView.bounds.size.width * scrollView.zoomScale;
        CGFloat tempH = _imageView.bounds.size.height * scrollView.zoomScale;
        
        if (tempW <= _mainSize.width) {
            tempX = _mainSize.width / 2.0 - tempW / 2.0;
        }
        if (tempH <= _mainSize.height) {
            tempY = _mainSize.height / 2.0 - tempH / 2.0;
        }
        _imageView.frame = CGRectMake(tempX, tempY, tempW, tempH);
    }else{
        CGFloat tempX = 0.0;
        CGFloat tempY = 0.0;
        CGFloat tempW = _imageView.bounds.size.width * scrollView.zoomScale;
        CGFloat tempH = _imageView.bounds.size.height * scrollView.zoomScale;
        
        if (tempW <= _mainSize.width){
            tempX = _mainSize.width/2 - tempW/2.0;
        }
        
        if (tempH <= _mainSize.height){
            tempY = _mainSize.height/2 - tempH/2.0;
        }

        _imageView.frame = CGRectMake(tempX, tempY, tempW, tempH);
    }
    
}
- (CGRect)getRectWithScale:(CGFloat)scale andCenter:(CGPoint)center
{
    CGRect rect;
    rect.size.width = self.frame.size.width / scale;
    rect.size.height = self.frame.size.height / scale;
    rect.origin.x = center.x - rect.size.width / 2.0;
    rect.origin.y = center.y - rect.size.height / 2.0;
    return rect;
}
- (void)recoverNormalScale
{
    if (self.zoomScale == 1.0) {
        return;
    }
    UIImage *dealImage = _imageView.image;
    if (dealImage != nil) {//图片加载成功
        //判定触摸点是否在图片内部
        CGPoint point = CGPointMake(_imageView.bounds.size.width / 2.0, _imageView.bounds.size.height / 2.0);
        CGFloat tempX = _imageView.frame.size.width;
        CGFloat tempY = _imageView.frame.size.height;
        
        CGFloat pointX = point.x * self.zoomScale;
        CGFloat pointY = point.y * self.zoomScale;
        
        if (pointX > 0.0 && pointY > 0.0 && pointX < tempX && pointY < tempY) {
            [self zoomToRect:[self getRectWithScale:1.0 andCenter:point] animated:YES];
        }
    }
}
@end
