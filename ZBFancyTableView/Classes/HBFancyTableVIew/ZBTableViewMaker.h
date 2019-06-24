//
//  ZBTableViewMaker.h
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBFancySection.h"
#import "ZBFancyRow.h"

extern NSString * const AutumnCellProtoConst;

@interface ZBTableViewSectionMaker : NSObject

@property (nonatomic, strong) ZBFancySection *section;

@end

@interface ZBTableViewRowMaker : NSObject

@property (nonatomic, strong) ZBFancyRow *row;

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^height)(CGFloat height);

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^model)(id model);

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^tag)(NSString *tag);

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^configureSEL)(SEL selector);

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^heightSEL)(SEL selector);

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^constructBlock)(UITableViewCell *(^)(id));

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^selectBlock)(void(^)(id));

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^configureBlock)(void(^)(id));

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^extraDictBlock)(NSDictionary *extraDict);

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^bundle)(NSBundle *bundle);

/**
 example:
 
 ZBFancySection *section = [self.tableView.ZB_tableData sectionAtIdx:indexPath.section];
 [section deleteRowsForIdxs:@[@(indexPath.row)]];
 [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 */
@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^deleteHandle)(void(^)(NSIndexPath *indexPath, id rawModel));

@property (nonatomic, copy, readonly) ZBTableViewRowMaker *(^deleteTitle)(NSString *deleteTitle);

@end

@interface ZBTableViewMaker : NSObject

@property (nonatomic, copy) ZBTableViewSectionMaker *(^section)(NSString *key);

@property (nonatomic, copy) ZBTableViewRowMaker *(^sectionHeader)(NSString *proto);

@property (nonatomic, copy) ZBTableViewRowMaker *(^sectionFooter)(NSString *proto);

@property (nonatomic, copy) ZBTableViewRowMaker *(^row)(NSString *proto);

- (NSArray *)install;

@end
