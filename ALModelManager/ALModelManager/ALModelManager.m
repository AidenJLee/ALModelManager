//
//  ALModelManager.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "ALModelManager.h"
#import "ALObservation.h"
#import "ALIntrospection.h"

@interface ALModelManager () {
    
    id  _target;            // 콜백대상
    SEL _patchSeletor;      // 변경시 콜백
    NSString *_keyPaths;    // Observer keyPath
    
}

@end

// @{ observingKey : target } 으로 KVO 오브젝트 관리 하면서 remove 하기

@implementation ALModelManager

#pragma mark -
#pragma mark Init
- (id)initWithTarget:(id)target patchSeletor:(SEL)seletor;
{
    
    self = [super init];
    if (self) {
        
        NSParameterAssert(target);
        NSParameterAssert(seletor);
        
        _target         = target;
        _patchSeletor   = seletor;
        
    }
    return self;
    
}

- (void)dealloc
{
    
}

- (void)addObserverForKeyPaths:(NSString *)keyPaths
{
    NSParameterAssert(keyPaths);
    //    NSDictionary *dicKeyPath = [self separateKeyPath:keyPaths];
    
    //    NSArray *arrKeyPath = [keyPaths componentsSeparatedByString:@"."];
    //    NSString *modelName = [arrKeyPath firstObject];
    //
    //    id object = [ALIntrospection getPropertyValueOfObject:[DataManager sharedDataManager] name:modelMain];
    //
    //    for (NSString *obKey in keyPaths) {
    ////        [THObserver observerForObject:object
    ////                              keyPath:obKey
    ////                                block:^{
    ////                                    NSLog(@"%@ changed, is now %@", obKey, [ALIntrospection getPropertyValueOfObject:object name:obKey]);
    ////                                }];
    //    }
    
}

- (void)removeObserverForKeyPaths:(NSString *)keyPaths
{
    //    [model k:@"board.list" v:@[@{@"num":1,@"title":"제목1"}, @{@"num":1,@"title":"제목1"}]];
    //    [model k:@"system.uuid" v:@"uuid...."];
    //    NSMutableArray * arr = [model g:@"board.list"];
    //    [arr addObject:@{@"num":1,@"title":"제목1"}];
    //    [arr replaceObjectAtIndex:1 withObject:@{@"num":1,@"title":"제목1"}];
}

#pragma mark -
#pragma mark - Private Method
/* Start : keyPath = @"user.*, chat._id, chat.male" */
- (NSDictionary *)separateKeyPath:(NSString *)keyPath
{
    // 반환 객체
    NSMutableDictionary *dicKeyPath = [NSMutableDictionary new];
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리 = @[ user.*, chat._id, chat.male ]
    NSArray *strKeyPaths = [keyPath componentsSeparatedByString:@","];
    
    for (NSString *strAbsoluteKey in strKeyPaths) {
        
        // 공백 및 개행 제거 후 KeyPath 분리 = user.name -> @[ @"user" , @"name" ] - 처음 값은 모델 key값 이라고 정의
        NSMutableArray *arrSeparatedKeyPath = [[strAbsoluteKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                               componentsSeparatedByString:@"."].mutableCopy;
        // model key = ex) user.name = @"User"
        NSString *strModelKey = [[arrSeparatedKeyPath firstObject] capitalizedString];
        [arrSeparatedKeyPath removeObjectAtIndex:0];    // Model key 지움
        if (![dicKeyPath objectForKey:strModelKey]) {
            [dicKeyPath setObject:[NSMutableArray array] forKey:strModelKey];
        }
        
        Class modelClass = NSClassFromString(strModelKey);
        NSParameterAssert(modelClass);  // Model이 있는지 검사
        
        for (NSString *strKey in arrSeparatedKeyPath) {
            
            if ([strKey isEqualToString:@"*"]) {
                
                NSArray *propertyNames = [ALIntrospection getPropertyNamesOfClass:modelClass superInquiry:NO];
                for (NSString *propertyKey in propertyNames) {
                    [dicKeyPath[strModelKey] addObject:propertyKey];
                }
                
            } else {
                [dicKeyPath[strModelKey] addObject:strKey];
            }
            
        }
        
    }
    
    return dicKeyPath;
}

/*
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
 
 [_target performSelector:_patchSeletor withObject:newObject];
 
 #pragma clang diagnostic pop
 */

@end
