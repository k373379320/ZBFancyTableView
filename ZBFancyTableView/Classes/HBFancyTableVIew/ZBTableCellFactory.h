//
//  MBTableCellFactory.h
//  ModelBasedTableView
//
//  Created by xzb on 16/2/24.
//  Copyright © 2016年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBTableCellFactory : NSObject

/**
 * 初始化
 */
- (instancetype)initWithTableView:(UITableView *)tableview;

/**
 * 在TableView中注册Cell Class，Class Name作为reuse identifier
 */
- (void)registerCell:(Class)cellClass;

/**
 * 在TableView中注册Cell Class，指定自定义reuse identifier
 */
- (void)registerCell:(Class)cellClass identifier:(NSString *)identifier;

/**
 * 在TableView中注册Nib，Class Name作为reuse identifier
 */
- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass;

/**
 * 在TableView中注册Nib，指定自定义reuse identifier
 */
- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass identifier:(NSString *)identifier;

/**
 * 根据identifier创建Cell实例
 */
- (UITableViewCell *)createCellWithIdentifier:(NSString *)identifier;

/**
 * 根据identifier获取Cell Class
 */
- (Class)cellClassForIdentifier:(NSString *)identifier;

@end
