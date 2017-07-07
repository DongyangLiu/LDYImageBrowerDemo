//
//  NSMutableArray+LDYCategory.h
//  LDYImageBrowerDemo
//
//  Created by yang on 2017/7/7.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LDYCategory)
///截取从index开始的count个元素的非空数组
- (NSMutableArray *)subarrayFromIndex:(NSUInteger)index count:(NSUInteger)count;
@end
