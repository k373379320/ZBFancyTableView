//
//  ZBFancySection.m
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import "ZBFancySection.h"

@interface ZBFancySection ()
@property(nonatomic, strong, readwrite) NSMutableArray<__kindof ZBFancyRow *> *innerRows;
@end

@implementation ZBFancySection

- (instancetype)init {
    self = [super init];
    if (self) {
        _innerRows = [NSMutableArray array];
    }
    return self;
}

- (NSArray<__kindof ZBFancyRow *> *)rows {
    return [self.innerRows copy];
}

- (ZBFancyRow *)rowAtIdx:(NSInteger)idx {
    if (self.innerRows.count > idx) {
        return self.innerRows[idx];
    }
    return nil;
}

- (void)appendRows:(NSArray<__kindof ZBFancyRow *> *)rows {
    [self.innerRows addObjectsFromArray:rows];
}

- (void)insertRows:(NSArray<__kindof ZBFancyRow *> *)rows atIdx:(NSUInteger)idx {
    if (rows.count > 0) {
        NSInteger index = self.innerRows.count > idx ? idx : self.innerRows.count;
        [rows enumerateObjectsUsingBlock:^(__kindof ZBFancyRow *obj, NSUInteger i, BOOL *stop) {
            [self.innerRows insertObject:obj atIndex:(index + i)];
        }];
    }
}

- (void)deleteRowsForIdxs:(NSArray<NSNumber *> *)idxs {
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    [idxs enumerateObjectsUsingBlock:^(NSNumber *i, NSUInteger idx, BOOL *stop) {
        if (self.innerRows.count > i.unsignedIntegerValue) {
            [deleteIndexSet addIndex:i.unsignedIntegerValue];
        }
    }];
    [self.innerRows removeObjectsAtIndexes:deleteIndexSet];
}

- (void)moveRowFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx {
    if (self.innerRows.count > fromIdx && self.innerRows.count > toIdx && fromIdx != toIdx) {
        ZBFancyRow *rowData = self.innerRows[fromIdx];
        [self.innerRows removeObjectAtIndex:fromIdx];
        [self.innerRows insertObject:rowData atIndex:(fromIdx > toIdx ? toIdx : (toIdx - 1))];
    }
}

- (void)replaceSectionWithRows:(NSArray<__kindof ZBFancyRow *> *)rows {
    self.innerRows = [rows mutableCopy];
}

@end
