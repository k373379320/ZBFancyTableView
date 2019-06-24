//
//  MBTableCellFactory.m
//  ModelBasedTableView
//
//  Created by xzb on 16/2/24.
//  Copyright © 2016年 xzb. All rights reserved.
//

#import "ZBTableCellFactory.h"

@interface ZBTableCellFactory()

@property (nonatomic, weak) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *identifiesMap;

@end

@implementation ZBTableCellFactory

- (instancetype)initWithTableView:(UITableView *)tableview
{
    self = [super init];
    if (self) {
        _tableview = tableview;
        _identifiesMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerCell:(Class)cellClass
{
    [self registerCell:cellClass identifier:NSStringFromClass(cellClass)];
}

- (void)registerCell:(Class)cellClass identifier:(NSString *)identifier
{
    [_identifiesMap setObject:NSStringFromClass(cellClass) forKey:identifier];
    [_tableview registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass
{
    [self registerNib:nib cellClass:cellClass identifier:NSStringFromClass(cellClass)];
}

- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass identifier:(NSString *)identifier
{
    [_identifiesMap setObject:NSStringFromClass(cellClass) forKey:identifier];
    [_tableview registerNib:nib forCellReuseIdentifier:identifier];
}

- (UITableViewCell *)createCellWithIdentifier:(NSString *)identifier
{
    NSAssert([_identifiesMap[identifier] length] > 0, @"无法创建Cell，请先注册identifier为%@的Cell类", identifier);

    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

- (Class)cellClassForIdentifier:(NSString *)identifier
{
    NSString *className = _identifiesMap[identifier];
    NSAssert([className length] > 0, @"无法获取Class，请先注册identifier为%@的Cell类", identifier);
    return NSClassFromString(className);
}

@end
