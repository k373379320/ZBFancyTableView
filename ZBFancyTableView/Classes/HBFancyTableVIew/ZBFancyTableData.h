//
// Created by dl on 2016/12/20.
//

#import <UIKit/UIKit.h>

@class ZBFancyRow;
@class ZBFancySection;


@interface ZBFancyTableData : NSObject

- (NSArray<NSString *> *)allSectionsKeys;

// section
- (NSArray<ZBFancySection *> *)sections;

- (ZBFancySection *)sectionAtIdx:(NSInteger)idx;

- (ZBFancySection *)sectionForKey:(NSString *)key;

- (void)resetWithSections:(NSArray<ZBFancySection *> *)sections;

- (void)replaceSection:(ZBFancySection *)section newSection:(ZBFancySection *)newSection;

- (void)appendSections:(NSArray<ZBFancySection *> *)sections;

- (void)insertSections:(NSArray<ZBFancySection *> *)sections atIdx:(NSUInteger)idx;

- (void)deleteSectionsForIdxs:(NSArray<NSNumber *> *)idxs;

- (void)deleteSectionsForKeys:(NSArray<NSString *> *)keys;

- (void)moveSectionFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx;

- (NSUInteger)sectionIdxForKey:(NSString *)key;

// row
- (ZBFancyRow *)rowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<ZBFancyRow *> *)rawsForSectionIdx:(NSUInteger)sectionIdx;

- (NSString *)protoTypeAtIndexPath:(NSIndexPath *)indexPath;

- (id)rawModelAtIndexPath:(NSIndexPath *)indexPath;

@end
