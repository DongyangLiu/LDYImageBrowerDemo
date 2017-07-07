//
//  NSMutableArray+LDYCategory.m
//  LDYImageBrowerDemo
//
//  Created by yang on 2017/7/7.
//  Copyright © 2017年 Lianxi.com. All rights reserved.
//

#import "NSMutableArray+LDYCategory.h"

@implementation NSMutableArray (LDYCategory)

/*截取从index开始的count个元素的非空数组*/
- (NSMutableArray *)subarrayFromIndex:(NSUInteger)index count:(NSUInteger)count
{
    if (index < self.count) {
        NSUInteger length = MIN(self.count - index, count);
        return (length == self.count) ? self : [NSMutableArray arrayWithArray:[self subarrayWithRange:NSMakeRange(index, length)]];
    }
    return [NSMutableArray array];
}
@end
