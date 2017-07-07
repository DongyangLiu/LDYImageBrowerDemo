//
//  SCBrowseView.h
//  SocialCalendar
//
//  Created by yang on 15/10/31.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCBrowseDirection) {
    ///横向滑动
    SCBrowseDirectionHorizontal,
    ///纵向滑动
    SCBrowseDirectionVertical
};
typedef NS_ENUM(NSInteger,SCBrowseStyle) {
    ///默认样式
    SCBrowseStyleDefault,
    ///附带子视图（导航栏和底部视图）
    SCBrowseStyleSubView
};

@class SCBrowseView;
@protocol SCBrowseViewDelegate <NSObject>
///单击图片回调函数
- (void)oneTapBrowseViewWithBrowseView:(SCBrowseView *)browseView;
- (void)browseView:(SCBrowseView *)browseView ChangeIndex:(NSInteger)index;
- (void)browseView:(SCBrowseView *)browseView didscrollView:(UIScrollView *)scrollView;
@end

@interface SCBrowseView : UIView
@property (nonatomic, strong)   NSMutableArray          *mediasArray;
@property (nonatomic, assign)   NSInteger               index;
@property (nonatomic, weak)     id<SCBrowseViewDelegate>delegate;
@property (nonatomic, assign)   BOOL                    showSubView;


- (instancetype)initWithFrame:(CGRect)frame
                  mediasArray:(NSMutableArray *)mediasArray
                     fromRect:(CGRect)fromRect
                        index:(NSInteger)index
                    direction:(SCBrowseDirection)direction
                  browseStyle:(SCBrowseStyle)browseStyle;
- (void)createAcctionSheet;
@end
