//
//  ZBFancyDataSource.h
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBFancyTableData;
@class ZBFancySection;

@interface ZBFancyDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) ZBFancyTableData *fancyTableData;

@property (nonatomic, weak) id<UIScrollViewDelegate> scrollDelegate;

@property (nonatomic, copy) void (^cellForRowHandler)(UITableView *tableView, NSIndexPath *indexPath);

- (instancetype)initWithTableView:(UITableView *)tableView;

@end


@interface ZBFancyDataSource(ProtoType)

- (void)registerCell:(Class)cellClass identifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass identifier:(NSString *)identifier;

- (void)registerHeaderFooterView:(Class)viewClass identifier:(NSString *)identifier;

- (void)registerNib:(UINib *)nib headerFooterViewClass:(Class)viewClass identifier:(NSString *)identifier;

@end

@interface ZBFancyDataSource(Cell)

- (void)updateAll:(NSArray<__kindof ZBFancySection *> *)sections;

@end
