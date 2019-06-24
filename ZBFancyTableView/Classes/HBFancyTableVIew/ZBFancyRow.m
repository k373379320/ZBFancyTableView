//
//  ZBFancyRow.m
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import "ZBFancyRow.h"

@implementation ZBFancyRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        _height = CGFLOAT_MIN;
        _heightSel = NSSelectorFromString(@"cellHeight:");
        _configSel = NSSelectorFromString(@"loadData:");
    }
    
    return self;
}

@end
