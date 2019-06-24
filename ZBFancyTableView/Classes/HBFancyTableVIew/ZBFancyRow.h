//
//  ZBFancyRow.h
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBFancyRow : NSObject

@property (nonatomic, copy) NSString *protoType;

@property (nonatomic, strong) id rawModel;

@property(nonatomic, strong) NSDictionary *extraDict;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) SEL configSel;

@property (nonatomic, assign) SEL heightSel;

@property (nonatomic, copy) void (^selectHandler)(id);

@property (nonatomic, copy) UITableViewCell * (^constructBlock)(id);

@property (nonatomic, copy) void (^configureBlock)(id);

@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic, copy) void (^deleteHandler)(NSIndexPath *indexPath, id rawModel);

@property (nonatomic, copy) NSString *deleteTitle;

@end
