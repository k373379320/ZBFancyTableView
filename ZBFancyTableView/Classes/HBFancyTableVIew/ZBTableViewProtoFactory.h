//
//  ZBTableViewConfig.h
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBFancyDataSource.h"

@interface ZBTableViewCellConfig : NSObject

@property (nonatomic, copy) ZBTableViewCellConfig *(^type)(NSInteger);

@property (nonatomic, copy) ZBTableViewCellConfig *(^identifier)(NSString *protoName);

@property (nonatomic, copy) ZBTableViewCellConfig *(^cls)(NSString *clsName);

@property (nonatomic, copy) ZBTableViewCellConfig *(^nibName)(NSString *nibName);

@property (nonatomic, copy) ZBTableViewCellConfig *(^nib)(UINib *nib);

@end

@interface ZBTableViewProtoFactory : NSObject

@property (nonatomic, copy) ZBTableViewCellConfig *(^headerFooterView)(NSString *protoType);

@property (nonatomic, copy) ZBTableViewCellConfig *(^cell)(NSString *protoType);

- (NSArray *)install;

@end
