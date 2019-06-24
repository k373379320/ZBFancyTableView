//
//  ZBTableViewMaker.m
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import "ZBTableViewMaker.h"
#import "NSArray+BlocksKit.h"
#import "ZBFancySection.h"
#import "ZBFancyRow.h"

@implementation ZBTableViewSectionMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _section = [[ZBFancySection alloc] init];
    }
    return self;
}

@end


@implementation ZBTableViewRowMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.row = [[ZBFancyRow alloc] init];
    }
    
    return self;
}

- (ZBTableViewRowMaker *(^)(CGFloat))height
{
    return ^id(CGFloat h){
        self.row.height = h;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(id))model
{
    return ^id(id m){
        self.row.rawModel = m;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(NSString *))tag
{
    return ^id(NSString *t){
        self.row.tag = t;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(SEL))configureSEL
{
    return ^id(SEL s){
        self.row.configSel = s;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(SEL))heightSEL
{
    return ^id(SEL s){
        self.row.heightSel = s;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(UITableViewCell * (^)(id)))constructBlock
{
    return ^id( UITableViewCell * (^block)(id) ){
        self.row.constructBlock = block;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(void (^)(id)))selectBlock
{
    return ^id( void (^selectHandler)(id) ){
        self.row.selectHandler = selectHandler;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(NSDictionary *))extraDictBlock {
    return ^ZBTableViewRowMaker *(NSDictionary *extraDict) {
        self.row.extraDict = [extraDict copy];
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(NSBundle *))bundle {
    return ^ZBTableViewRowMaker *(NSBundle *bundle) {
        self.row.bundle = bundle;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(void(^)(NSIndexPath *indexPath, id rawModel)))deleteHandle
{
    return ^id((void(^deleteHandle)(NSIndexPath *indexPath, id rawModel))){
        self.row.deleteHandler = deleteHandle;
        return self;
    };
}

- (ZBTableViewRowMaker *(^)(NSString *))deleteTitle
{
    return ^id(NSString *deleteTitle){
        self.row.deleteTitle = deleteTitle;
        return self;
    };
}
@end

@interface ZBTableViewMaker()

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) ZBTableViewSectionMaker *currentSectionMaker;

@end

@implementation ZBTableViewMaker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (ZBTableViewSectionMaker *(^)(NSString *key))section
{
    return ^id(NSString *key){
        ZBTableViewSectionMaker *sectionMaker = [[ZBTableViewSectionMaker alloc] init];
        [self->_sections addObject:sectionMaker];
        self->_currentSectionMaker = sectionMaker;
        sectionMaker.section.key = key;
        return sectionMaker;
    };
}

- (ZBTableViewRowMaker *(^)(NSString *))sectionHeader
{
    return ^id(NSString *proto){
        ZBTableViewRowMaker *rowMaker = [[ZBTableViewRowMaker alloc] init];
        rowMaker.row.protoType = proto;
        self->_currentSectionMaker.section.headerView = rowMaker.row;
        return rowMaker;
    };
}

- (ZBTableViewRowMaker *(^)(NSString *))sectionFooter
{
    return ^id(NSString *proto){
        ZBTableViewRowMaker *rowMaker = [[ZBTableViewRowMaker alloc] init];
        rowMaker.row.protoType = proto;
        self->_currentSectionMaker.section.footerView = rowMaker.row;
        return rowMaker;
    };
}

- (ZBTableViewRowMaker *(^)(NSString *))row
{
    return ^id(NSString *proto){
        ZBTableViewRowMaker *rowMaker = [[ZBTableViewRowMaker alloc] init];
        rowMaker.row.protoType = proto;
        [self->_currentSectionMaker.section appendRows:@[rowMaker.row]];
        return rowMaker;
    };
}

- (NSArray *)install
{
    return [_sections bk_map:^id(ZBTableViewSectionMaker *sectionMaker) {
        return sectionMaker.section;
    }];
}

@end

