//
//  SCBroseViewController.h
//  SocialCalendar
//
//  Created by yang on 15/10/31.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBrowseView.h"

@interface SCBrowseViewController : UIViewController
@property (nonatomic, strong)   NSMutableArray          *mediasArray;
@property (nonatomic, assign)   CGRect                  fromRect;
@property (nonatomic, assign)   NSInteger               index;
@property (nonatomic, assign)   SCBrowseDirection       direction;
@property (nonatomic, assign)   NSInteger               showImageCount;
@property (nonatomic, assign)   SCBrowseStyle           browseStyle;
@property (nonatomic, strong)   UIView                  *footerView;
@end
