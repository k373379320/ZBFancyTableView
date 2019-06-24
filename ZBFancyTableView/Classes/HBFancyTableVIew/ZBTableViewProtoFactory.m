//
//  ZBTableViewConfig.m
//  ZBFancyTableViewDemo
//
//  Created by xzb on 16/4/3.
//  Copyright (c) 2016年 xzb. All rights reserved.
//

#import "ZBTableViewProtoFactory.h"
#import "NSArray+BlocksKit.h"

@interface ZBTableViewCellConfig()

@property (nonatomic, strong) NSMutableDictionary *configs;

@end

@implementation ZBTableViewCellConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _configs = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (ZBTableViewCellConfig *(^)(NSInteger))type
{
    return ^id(NSInteger type){
        self.configs[@"type"] = @(type);
        return self;
    };
}

-(ZBTableViewCellConfig *(^)(NSString *))identifier
{
    return ^id(NSString *protoName){
        self.configs[@"proto"] = protoName;
        return self;
    };
}

- (ZBTableViewCellConfig *(^)(NSString *))cls
{
    return ^id(NSString *clsName) {
        self.configs[@"class"] = clsName;
        return self;
    };
}

- (ZBTableViewCellConfig *(^)(UINib *))nib
{
    return ^id(UINib *nib){
        self.configs[@"nib"] = nib;
        return self;
    };
}

- (ZBTableViewCellConfig *(^)(NSString *))nibName
{
    return ^id(NSString *nib){
        self.configs[@"nibName"] = nib;
        return self;
    };
}

@end


@interface ZBTableViewProtoFactory()

@property (nonatomic, strong) NSMutableArray *cellConfigs;

@end

@implementation ZBTableViewProtoFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellConfigs = [NSMutableArray array];
    }
    return self;
}

- (ZBTableViewCellConfig *(^)(NSString *))headerFooterView
{
    return ^id(NSString *protoType){
        ZBTableViewCellConfig *protoConfig = [[ZBTableViewCellConfig alloc] init];
        protoConfig.type(0);
        protoConfig.identifier(protoType);
        [self.cellConfigs addObject:protoConfig];
        return protoConfig;
    };
}

- (ZBTableViewCellConfig *(^)(NSString *))cell
{
    return ^id(NSString *protoType){
        ZBTableViewCellConfig *protoConfig = [[ZBTableViewCellConfig alloc] init];
        protoConfig.type(1);
        protoConfig.identifier(protoType);
        [self.cellConfigs addObject:protoConfig];
        return protoConfig;
    };
}

- (NSArray *)install
{
    return [self.cellConfigs bk_map:^(ZBTableViewCellConfig *proto) {
        return proto.configs;
    }];
}

@end
