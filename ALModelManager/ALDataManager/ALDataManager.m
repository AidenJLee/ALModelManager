//
//  ALDataManager.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "ALDataManager.h"

@implementation ALDataManager

static ALDataManager *_dataManager = nil;
+ (ALDataManager *)sharedALDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataManager = [[ALDataManager alloc] initInstance];
    });
    return _dataManager;
}

+ (void)releaseALDataManager
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
