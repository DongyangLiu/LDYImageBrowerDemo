//
//  SCImageBrowse.h
//  SocialCalendar
//
//  Created by yang on 15/10/30.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBrowseView.h"

@protocol SCImageBrowseDelegate <NSObject>
///滑动时下部视图回调
- (UIView *)browseFooterViewChangeIndex:(NSInteger)index;

@end
@interface SCImageBrowse : NSObject
@property (nonatomic, strong)   SCBrowseView            *browseView;
@property (nonatomic, strong)   UIView                  *browseFooterView;
@property (nonatomic, assign)   NSInteger               index;
@property (nonatomic, weak)     id <SCImageBrowseDelegate>delegate;


+ (SCImageBrowse *)defaulBrowse;
///显示导航栏
- (void)showNavigation;
///隐藏导航栏
- (void)hiddenNavigation;
///隐藏broseView
- (void)hiddenBroseView;
///刷新子视图
- (void)refreshBrowseFooterViewWithIndex:(NSInteger)index;
///保存图片到相册
- (void)saveImage:(UIImage *)image;

- (void)showBrowseViewWithMediasArray:(NSMutableArray *)mediasArray
                             fromView:(UIView *)fromView
                             fromRect:(CGRect)fromRect
                                index:(NSInteger)index
                            direction:(SCBrowseDirection)direction
                          browseStyle:(SCBrowseStyle)browseStyle;

@end
