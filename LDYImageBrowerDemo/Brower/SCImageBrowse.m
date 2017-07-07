//
//  SCImageBrowse.m
//  SocialCalendar
//
//  Created by yang on 15/10/30.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import "SCImageBrowse.h"
#import "SCBrowseScrollView.h"
#import "SCBrowseViewController.h"
#import "SCBrowseView.h"
#import "AppDelegate.h"

@interface SCImageBrowse()<UIScrollViewDelegate>

@property (nonatomic, strong)   NSMutableArray          *mediasArray;
@property (nonatomic, assign)   CGRect                  fromRect;
@property (nonatomic, assign)   SCBrowseDirection       direction;
@property (nonatomic, assign)   NSInteger               showImageCount;
@end

@implementation SCImageBrowse

- (id)init
{
    self = [super init];
    if (self) {
        _mediasArray = [[NSMutableArray alloc]init];
    }
    return self;
}

+ (SCImageBrowse *)defaulBrowse
{
    @synchronized(self) {
        static SCImageBrowse *defaulBrowseInstance = nil;
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            defaulBrowseInstance = [[self alloc] init];
        });
        return defaulBrowseInstance;
    }
}
///显示browseView
- (void)showBrowseViewWithMediasArray:(NSMutableArray *)mediasArray
                             fromView:(UIView *)fromView
                             fromRect:(CGRect)fromRect
                                index:(NSInteger)index
                            direction:(SCBrowseDirection)direction
                          browseStyle:(SCBrowseStyle)browseStyle
{
    if (mediasArray.count) {
        _mediasArray = mediasArray;
    }else{
        [_mediasArray removeAllObjects];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (fromView) {
        _fromRect = [fromView convertRect:fromView.bounds toView:window];
    }else{
        _fromRect = fromRect;
    }
    if (browseStyle == SCBrowseStyleDefault) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        if (!_browseView) {
            _browseView = [[SCBrowseView alloc]initWithFrame:window.bounds
                                                 mediasArray:_mediasArray
                                                    fromRect:_fromRect
                                                       index:index
                                                   direction:direction
                                                 browseStyle:browseStyle];
            [window addSubview:_browseView];
        }

    }
    if (browseStyle == SCBrowseStyleSubView) {
        [self hiddenNavigation];
        SCBrowseViewController *browseVC = [[SCBrowseViewController alloc]init];
        browseVC.mediasArray = _mediasArray;
        browseVC.fromRect = fromRect;
        browseVC.index = index;
        browseVC.direction = direction;
        browseVC.browseStyle = browseStyle;
        
        [[(AppDelegate *)[[UIApplication sharedApplication]delegate] rootNavigationController] pushViewController:browseVC animated:YES];
    }
}
- (void)showNavigation
{
    [(AppDelegate *)[[UIApplication sharedApplication]delegate] rootNavigationController].navigationBarHidden = NO;
}
- (void)hiddenNavigation
{
    [(AppDelegate *)[[UIApplication sharedApplication]delegate] rootNavigationController].navigationBarHidden = YES;
}
///隐藏broseView
- (void)hiddenBroseView
{
    if (_browseView) {
        [_browseView removeFromSuperview];
        _browseView = nil;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)refreshBrowseFooterViewWithIndex:(NSInteger)index
{
    self.index = index;
    if ([_delegate respondsToSelector:@selector(browseFooterViewChangeIndex:)]) {
        _browseFooterView = [_delegate browseFooterViewChangeIndex:index];
    }
}
- (void)saveImage:(UIImage *)image
{
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
/*存储结果提示*/
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        NSLog(@"已存储到相册");
    } else {
        NSLog(@"存储失败");
    }
}

@end
