//
//  UITableView+ZBFancyTableView.h
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBTableViewProtoFactory.h"
#import "ZBTableViewMaker.h"
#import "ZBFancyDataSource.h"
#import "ZBFancyTableData.h"

@interface UITableView(ZBFancyDataSource)

@property (nonatomic, strong, readonly) ZBFancyDataSource *zb_dataSource;
@property (nonatomic, strong, readonly) ZBFancyTableData *zb_tableData;

@end

@interface UITableView (ZBFancyTableView)

- (void)zb_configTableView:(void(^)(ZBTableViewProtoFactory *config))block;

- (void)zb_setup:(void(^)(ZBTableViewMaker *maker))block;

- (void)zb_replaceSection:(NSString *)tag block:(void(^)(ZBTableViewMaker *maker))block;

- (void)zb_appendSection:(NSString *)tag block:(void(^)(ZBTableViewMaker *maker))block;

- (void)zb_appendRowsForSection:(NSString *)tag block:(void(^)(ZBTableViewMaker *maker))block;

@end
