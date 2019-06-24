//
//  UITableView+ZBFancyTableView.m
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import "UITableView+ZBFancyTableView.h"
#import <objc/runtime.h>
#import "ZBFancyTableData.h"

static char kFancyDataSourceKey;

@implementation UITableView(ZBFancyDataSource)

- (ZBFancyDataSource *)zb_dataSource
{
    ZBFancyDataSource *ds = objc_getAssociatedObject(self, &kFancyDataSourceKey);
    if (!ds) {
        ds = [[ZBFancyDataSource alloc] initWithTableView:self];
        objc_setAssociatedObject(self, &kFancyDataSourceKey, ds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (!self.dataSource) {
            self.dataSource = ds;
            self.delegate = ds;
        }
    }
    return ds;
}

- (ZBFancyTableData *)zb_tableData {
    return self.zb_dataSource.fancyTableData;
}

@end

@implementation UITableView (ZBFancyTableView)

- (void)zb_configTableView:(void (^)(ZBTableViewProtoFactory *))block
{
    ZBTableViewProtoFactory *config = [[ZBTableViewProtoFactory alloc] init];
    block(config);
    
    NSArray *configs = [config install];
    [configs enumerateObjectsUsingBlock:^(NSDictionary *config, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger type = (config[@"type"] ? [config[@"type"] integerValue] : 1);
        if (type == 0) {
            if (config[@"nibName"]) {
                UINib *nib = [UINib nibWithNibName:config[@"nibName"] bundle:nil];
                [self.zb_dataSource registerNib:nib
                          headerFooterViewClass:NSClassFromString(config[@"class"])
                                     identifier:config[@"proto"]];
            } else {
                [self.zb_dataSource registerHeaderFooterView:NSClassFromString(config[@"class"])
                                                  identifier:config[@"proto"]];
            }
        } else {
            if (config[@"nibName"]) {
                UINib *nib = [UINib nibWithNibName:config[@"nibName"] bundle:nil];
                [self.zb_dataSource registerNib:nib
                                      cellClass:NSClassFromString(config[@"class"])
                                     identifier:config[@"proto"]];
            } else if(config[@"nib"]) {
                [self.zb_dataSource registerNib:config[@"nib"]
                                      cellClass:NSClassFromString(config[@"class"])
                                     identifier:config[@"proto"]];
            } else {
                [self.zb_dataSource registerCell:NSClassFromString(config[@"class"])
                                      identifier:config[@"proto"]];
            }
        }
    }];
}

- (void)zb_setup:(void (^)(ZBTableViewMaker *))block
{
    ZBTableViewMaker *maker = [[ZBTableViewMaker alloc] init];
    block(maker);
    
    NSArray *sections = [maker install];
    
    [self.zb_dataSource updateAll:sections];
    
    [self reloadData];
}

- (void)zb_replaceSection:(NSString *)tag block:(void (^)(ZBTableViewMaker *))block
{
    ZBFancySection *section = [self.zb_tableData sectionForKey:tag];
    if (section) {
        ZBTableViewMaker *maker = [[ZBTableViewMaker alloc] init];
        if (block) {
            block(maker);
        }
        NSArray *sections = [maker install];
        if ([sections count] > 0) {
            ZBFancySection *newSection = sections[0];
            [self.zb_tableData replaceSection:section newSection:newSection];
        }
    }
}

- (void)zb_appendSection:(NSString *)tag block:(void (^)(ZBTableViewMaker *))block
{
    ZBFancySection *section = [self.zb_tableData sectionForKey:tag];
    if (section) {
        ZBTableViewMaker *maker = [[ZBTableViewMaker alloc] init];
        maker.section(tag);
        if (block) {
            block(maker);
        }
        NSArray *sections = [maker install];
        if ([sections count] > 0) {
            ZBFancySection *sectionDataToAppend = sections[0];
            [section appendRows:sectionDataToAppend.rows];
        }
    }
}

- (void)zb_appendRowsForSection:(NSString *)tag block:(void(^)(ZBTableViewMaker *maker))block {
    ZBFancySection *section = [self.zb_tableData sectionForKey:tag];
    if (section) {
        ZBTableViewMaker *maker = [[ZBTableViewMaker alloc] init];
        maker.section(tag);
        if (block) {
            block(maker);
        }
        NSArray *sections = [maker install];
        if ([sections count] > 0) {
            ZBFancySection *sectionDataToAppend = sections[0];
            [section appendRows:sectionDataToAppend.rows];
        }
    }
}

@end
