//
//  SCBrowseScrollView.h
//  SocialCalendar
//
//  Created by yang on 15/10/30.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCImageBrowse.h"

@protocol SCBrowseScrollViewDelegate <NSObject>
///点击回调函数
- (void)oneTapTouchBrowseScrollView;
///longPress回调
- (void)longPressTouchBrowseScrollView;

@end

@interface SCBrowseScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame browseStyle:(SCBrowseStyle)browseStyle;

@property (nonatomic, weak) id<SCBrowseScrollViewDelegate> browseDelegate;

- (void)setImageViewWith:(UIImage *)image
                fromRect:(CGRect)fromRect
                 animate:(BOOL)animate;

@end
