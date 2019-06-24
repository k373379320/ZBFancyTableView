//
//  ZBFancySection.h
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBFancyRow;

@interface ZBFancySection : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) ZBFancyRow *headerView;

@property (nonatomic, strong) ZBFancyRow *footerView;

- (NSArray<__kindof ZBFancyRow *> *)rows;

- (ZBFancyRow *)rowAtIdx:(NSInteger)idx;

- (void)appendRows:(NSArray<__kindof ZBFancyRow *> *)rows;

- (void)insertRows:(NSArray<__kindof ZBFancyRow *> *)rows atIdx:(NSUInteger)idx;

- (void)deleteRowsForIdxs:(NSArray<NSNumber *> *)idxs;

- (void)moveRowFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx;

- (void)replaceSectionWithRows:(NSArray<__kindof ZBFancyRow *> *)rows;

@end
