//
//  DataManager.m
//  DateQ
//
//  Created by HoJun Lee on 2014. 2. 1..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//

#import "DataManager.h"
#import "ALIntrospection.h"


@implementation DataManager

static DataManager *_dataManager = nil;
+ (instancetype)sharedDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataManager = [[DataManager alloc] initInstance];
    });
    return _dataManager;
}

+ (void)releaseDataManager
{
    _dataManager = nil;
}

- (id)init
{
    NSAssert(NO, @"Can`t create instance of Singleton");
    return nil;
}

- (id)initInstance
{
    self = [super init];
    if (self) {
        _results = [[NSMutableDictionary alloc] initWithCapacity:8];
    }
    return self;
}

#pragma mark -
#pragma mark - Setter Getter
//- (void)setModelObject:(id)object
//{
//    NSString *objectKey = [ALIntrospection classNameFromObject:object];
//    [self.managedDatas setObject:object forKey:objectKey];
//}
//
//- (id)getModelObject:(id)object
//{
//    NSString *objectKey = [ALIntrospection classNameFromObject:object];
//    return [self.managedDatas objectForKey:objectKey];
//}

@end
