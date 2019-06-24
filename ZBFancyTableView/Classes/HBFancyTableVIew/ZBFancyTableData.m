//
// Created by dl on 2016/12/20.
//

#import "ZBFancyTableData.h"
#import "ZBFancyRow.h"
#import "ZBFancySection.h"
#import "BlocksKit.h"

@interface ZBFancyTableData ()
@property(nonatomic, strong) NSMutableArray<__kindof ZBFancySection *> *innerSections;
@end

@implementation ZBFancyTableData

- (instancetype)init {
    self = [super init];
    if (self) {
        _innerSections = [@[] mutableCopy];
    }
    return self;
}

- (NSArray<NSString *> *)allSectionsKeys {
    return [self.innerSections bk_map:^id(ZBFancySection *section) {
        return section.key;
    }];
}

- (NSArray<ZBFancySection *> *)sections {
    return [self.innerSections copy];
}

- (ZBFancySection *)sectionAtIdx:(NSInteger)idx {
    if (self.innerSections.count > idx) {
        return self.innerSections[idx];
    }
    return nil;
}

- (ZBFancySection *)sectionForKey:(NSString *)key {
    NSUInteger index = [[self allSectionsKeys] indexOfObject:key];
    if (index != NSNotFound && self.innerSections.count > index) {
        return self.innerSections[index];
    }
    return nil;
}

- (void)resetWithSections:(NSArray<ZBFancySection *> *)sections {
    self.innerSections = [sections mutableCopy];
}

- (void)replaceSection:(ZBFancySection *)section newSection:(ZBFancySection *)newSection {
    NSUInteger index = [[self allSectionsKeys] indexOfObject:section.key];
    if (index != NSNotFound) {
        [self.innerSections replaceObjectAtIndex:index withObject:newSection];
    }
}

- (void)appendSections:(NSArray<ZBFancySection *> *)sections {
    [self.innerSections addObjectsFromArray:sections];
}

- (void)insertSections:(NSArray<ZBFancySection *> *)sections atIdx:(NSUInteger)idx {
    if (sections.count > 0) {
        NSInteger index = self.innerSections.count > idx ? idx : self.innerSections.count;
        [sections enumerateObjectsUsingBlock:^(__kindof ZBFancySection *obj, NSUInteger i, BOOL *stop) {
            [self.innerSections insertObject:obj atIndex:(index + i)];
        }];
    }
}

- (void)deleteSectionsForIdxs:(NSArray<NSNumber *> *)idxs {
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    [idxs enumerateObjectsUsingBlock:^(NSNumber *i, NSUInteger idx, BOOL *stop) {
        if (self.innerSections.count > i.unsignedIntegerValue) {
            [deleteIndexSet addIndex:i.unsignedIntegerValue];
        }
    }];
    [self.innerSections removeObjectsAtIndexes:deleteIndexSet];
}

- (void)deleteSectionsForKeys:(NSArray<NSString *> *)keys {
    NSMutableIndexSet *deleteIndexSet = [[NSMutableIndexSet alloc] init];
    NSArray *allSectionsKeys = [self allSectionsKeys];
    [keys enumerateObjectsUsingBlock:^(NSString *identifier, NSUInteger idx, BOOL *stop) {
        if ([allSectionsKeys containsObject:identifier]) {
            [deleteIndexSet addIndex:[allSectionsKeys indexOfObject:identifier]];
        }
    }];
    [self.innerSections removeObjectsAtIndexes:deleteIndexSet];
}

- (void)moveSectionFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx {
    if (self.innerSections.count > fromIdx && self.innerSections.count > toIdx && fromIdx != toIdx) {
        ZBFancySection *sectionData = self.innerSections[fromIdx];
        [self.innerSections removeObjectAtIndex:fromIdx];
        [self.innerSections insertObject:sectionData atIndex:(fromIdx > toIdx ? toIdx : (toIdx - 1))];
    }
}

- (NSUInteger)sectionIdxForKey:(NSString *)key {
    return [[self allSectionsKeys] indexOfObject:key];
}

- (ZBFancyRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    ZBFancySection *section = [self sectionAtIdx:indexPath.section];
    return [section rowAtIdx:indexPath.row];
}

- (NSArray<ZBFancyRow *> *)rawsForSectionIdx:(NSUInteger)sectionIdx {
    if (self.innerSections.count > sectionIdx) {
        ZBFancySection *sectionData = self.innerSections[sectionIdx];
        return sectionData.rows;
    }
    return nil;
}

- (NSString *)protoTypeAtIndexPath:(NSIndexPath *)indexPath {
    ZBFancyRow *row = [self rowAtIndexPath:indexPath];
    return row.protoType;
}

- (id)rawModelAtIndexPath:(NSIndexPath *)indexPath {
    ZBFancyRow *row = [self rowAtIndexPath:indexPath];
    return row.rawModel;
}

@end
