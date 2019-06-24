//
//  ZBFancyDataSource.m
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import "ZBFancyDataSource.h"
#import "ZBFancySection.h"
#import "ZBFancyRow.h"
#import "ZBFancyTableData.h"
#import "ZBTableViewMaker.h"


static NSString * const ZBFancyProtoTypeIdentifierKey = @"identifier";
static NSString * const ZBFancyProtoTypeClassKey = @"class";
static NSString * const ZBFancyProtoTypeNibKey = @"nib";

@interface ZBFancyDataSource()
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *protoTypes;
@property(nonatomic, strong, readwrite) ZBFancyTableData *fancyTableData;
@end

@implementation ZBFancyDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        _tableView = tableView;
        _protoTypes = [NSMutableDictionary dictionary];
        _fancyTableData = [[ZBFancyTableData alloc] init];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fancyTableData.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fancyTableData sectionAtIdx:section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    
    if (row) {
        if (self.cellForRowHandler) {
            self.cellForRowHandler(tableView, indexPath);
        }
        
        if (row.constructBlock) {
            return row.constructBlock(row.rawModel);
        }

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row.protoType
                                                                forIndexPath:indexPath];
        if (row.configSel) {
            id model = row.rawModel;
            
            NSMethodSignature *ms = [[cell class] instanceMethodSignatureForSelector:row.configSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:ms];
            invocation.target = cell;
            invocation.selector = row.configSel;
            [invocation setArgument:&model atIndex:2];
            [invocation invoke];
        }
        
        if (row.configureBlock) {
            row.configureBlock(row.rawModel);
        }
        
        return cell;
    } else {
        NSLog(@"indexpath : %zd, %zd is empty", indexPath.section, indexPath.row);
        return [[UITableViewCell alloc] init];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    if (row.selectHandler) {
        row.selectHandler(row.rawModel);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    
    if (row.height != CGFLOAT_MIN) {
        return row.height;
    }  else if(row.heightSel) {
        Class cls = (_protoTypes[row.protoType] ? _protoTypes[row.protoType][ZBFancyProtoTypeClassKey] : nil);
        if (cls) {
            id model = row.rawModel;
            
            NSMethodSignature *ms = [cls methodSignatureForSelector:row.heightSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:ms];
            invocation.target = cls;
            invocation.selector = row.heightSel;
            [invocation setArgument:&model atIndex:2];
            [invocation invoke];
            
            CGFloat height;
            [invocation getReturnValue:&height];
            
            return height;
        }
    }
    
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZBFancySection *sec = [self.fancyTableData sectionAtIdx:section];
    ZBFancyRow *header = sec.headerView;
    if (header) {
        if (header.constructBlock) {
            return header.constructBlock(header.rawModel);
        }
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:header.protoType];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ZBFancySection *sec = [self.fancyTableData sectionAtIdx:section];
    ZBFancyRow *header = sec.headerView;
    if (header) {
        return header.height;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ZBFancySection *sec = [self.fancyTableData sectionAtIdx:section];
    ZBFancyRow *footer = sec.footerView;
    if (footer) {
        return footer.height;
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZBFancySection *sec = [self.fancyTableData sectionAtIdx:section];
    ZBFancyRow *footer = sec.footerView;
    if (footer) {
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:footer.protoType];
    } else {
        return nil;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    return row.deleteHandler ? YES : NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    return row.deleteHandler ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    if (row.deleteHandler) {
        row.deleteHandler(indexPath,row.rawModel);
    };
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ZBFancySection *section = [self.fancyTableData sectionAtIdx:indexPath.section];
    ZBFancyRow *row = [section rowAtIdx:indexPath.row];
    if (row.deleteTitle.length > 0) return row.deleteTitle;
    return @"删除";
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end

@implementation ZBFancyDataSource(ProtoType)

- (void)registerHeaderFooterView:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ZBFancyProtoTypeClassKey : viewClass};
    [self.tableView registerClass:viewClass forHeaderFooterViewReuseIdentifier:identifier];
}

- (void)registerCell:(Class)cellClass identifier:(NSString *)identifier
{
    NSAssert(identifier && [identifier length] > 0, @"identifer must not be empty");
    NSAssert(!(self.protoTypes[identifier]), @"%@ was already registerred", identifier);
    NSAssert(cellClass != nil, @"cellClass must not be nil");
    
    _protoTypes[identifier] = @{ZBFancyProtoTypeClassKey : cellClass};
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib cellClass:(Class)cellClass identifier:(NSString *)identifier
{
    NSAssert(identifier && [identifier length] > 0, @"identifer must not be empty");
    NSAssert(!(self.protoTypes[identifier]), @"%@ was already registerred", identifier);
    NSAssert(cellClass != nil, @"cellClass must not be nil");
    NSAssert(nib, @"nib must not be nill");
    
    _protoTypes[identifier] = @{ZBFancyProtoTypeClassKey : cellClass,
                                ZBFancyProtoTypeNibKey : nib};
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib headerFooterViewClass:(Class)viewClass identifier:(NSString *)identifier
{
    _protoTypes[identifier] = @{ZBFancyProtoTypeClassKey : viewClass,
                                ZBFancyProtoTypeNibKey : nib};
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
}

@end

@implementation ZBFancyDataSource(Cell)

- (void)updateAll:(NSArray<__kindof ZBFancySection *> *)sections
{
    [self.fancyTableData resetWithSections:sections];
}

@end
