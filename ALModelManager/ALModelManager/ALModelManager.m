//
//  ALModelManager.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "ALModelManager.h"
#import "ALIntrospection.h"

#import <objc/runtime.h>

#define OBSERVING_TARGET_KEY @"responseTarget"
#define OBSERVING_CALLBACK_KEY @"callbackSeletor"


@interface ALModelManager () {
    
    NSMutableDictionary *_observationManager;   // 옵저빙 객체 관리용
    NSArray *_propertyNames;                    // App에서 사용 할 Data객체들의 Property 이름 배열
    NSArray *_collectionNames;                  // App에서 사용 할 Data객체들이 Collection 인지 판별하기 위한 Collection 이름 배열
    
}

@end


@implementation ALModelManager

#pragma mark -
#pragma mark SIngleton Create & Release
static ALModelManager *_modelManager = nil;
+ (ALModelManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _modelManager = [[ALModelManager alloc] initModelManager];
    });
    return _modelManager;
}

+ (void)releaseInstance
{
    _modelManager = nil;
}

- (id)initModelManager
{
    self = [super init];
    if (self) {
        // do something~  ex) Init
    }
    return self;
}

- (void)didActiveManager
{
    _observationManager = [[NSMutableDictionary alloc] initWithCapacity:10];
    _propertyNames      = [ALIntrospection getPropertyNamesOfClass:[self class] superInquiry:NO];
    _collectionNames    = @[ @"NSArray", @"NSMutableArray", @"NSDictionary", @"NSMutableDictionary", @"NSSet", @"NSMutableSet", @"NSHashTable", @"NSMapTable" ];
}

- (void)didTerminateManager
{
    for (NSDictionary *dicObserverInfo in _observationManager) {
        [dicObserverInfo[@"someKey"] removeAllObservations];
    }
}

#pragma mark -
#pragma mark - Init & Dealloc
- (id)init
{
    NSAssert(NO, @"Can`t create instance With Init Method");
    return nil;
}

- (void)dealloc
{
    _observationManager = nil;
    _propertyNames      = nil;
    _collectionNames    = nil;
}


/**
 *  어떤 대상을 감시할지 keyPath를 통해 받고
 *  그 결과를 콜백 대상과 seletor에게 반환한다.
 *  물론 이것을 위해 모든 정보를 collection에 담아서 관리한다.
 *
 *  keypath case
 * 1. collection : collectionName.propertyName
 * ex) NSDictionary.users.name, NSDictionary.users.id, NSDictionary.users.email, NSDictionary.users.*
 * 2. model : modelName.propertyName
 * ex) User.user.name, User.user.id, User.user.email, User.user.*
 *
 *  @param target   콜백 대상
 *  @param keyPaths 감시할 대상들 다수의 keyPath를 지원 - ex) @"user.*, chat._id, chat.male"
 *  @param seletor  변경시 콜백
 */
- (BOOL)addTarget:(id)target observerForKeyPaths:(NSString *)keyPaths block:(ObservationObjectBlock)block
{
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    
    NSMutableDictionary *responseDictionary = @{
                                                @"user.name": @[ self ]
                                                };
    
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리
    NSArray *arrKeyPaths = [keyPaths componentsSeparatedByString:@","];     /* keyPath = @[ user.*, chat._id, chat.male ] */
    
    for (NSString *strKeypath in arrKeyPaths) {
        
        // 공백 및 개행 제거
        NSString *strAbsoluteKey = [strKeypath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  // [ @" ", @"\n" ]
        
        // 다수의 KeyPath 지원을 위해 .을 기준으로 분리 ( *로 모두 선택 지원용 )
        NSMutableArray *arrSeparatedKeyPath = [strAbsoluteKey componentsSeparatedByString:@"."].mutableCopy;
        
        /* 일단 보류 ( 정확한 데이터 타입 체크를 위해 복잡성이 증가함 )
        // 처음값이 모델 또는 컬렉션 명이라고 판단
//        NSString *strModelName = [[arrSeparatedKeyPath firstObject] capitalizedString]; // 일단 보류
        
        // 모델이 있는지 체크
        Class modelClass = NSClassFromString(strModelName);
        id model = [modelClass alloc];
        
        // Model key 지움
        [arrSeparatedKeyPath removeObjectAtIndex:0];
        */
        
//        if ([self Contains:strAbsoluteKey on:@"*"]) {
//            
//            for (NSString *strKey in arrSeparatedKeyPath) {
//                if ([strKey isEqualToString:@"*"]) {
//                    
//                    NSArray *propertyNames = [ALIntrospection getPropertyNamesOfClass:modelClass superInquiry:NO];
//                    for (NSString *propertyKey in propertyNames) {
//                        
//                        NSLog(@"%@", [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey]);
//                        NSDictionary *observeDic = @{
//                                                     @"modelkey": strModelName,
//                                                     @"keypath": [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey],
//                                                     @"target": target,
//                                                     @"selector": NSStringFromSelector(seletor)
//                                                     };
//                        
//                        // KVO 적용 및 객체 관리
////                        [self addKVOForDictionary:observeDic];
//                        NSLog(@"%@", observeDic);
//                        
//                    }
//                    
//                }
//            }
//            
//        } else {
//            
//            NSDictionary *observeDic = @{
//                                         @"modelkey": strModelName,
//                                         @"keypath": strAbsoluteKey,
//                                         @"target": target,
//                                         @"selector": NSStringFromSelector(seletor)
//                                         };
//            
//            // KVO 적용 및 객체 관리
////            [self addKVOForDictionary:observeDic];
//            NSLog(@"%@", observeDic);
//            
//        }
        
    }
    return YES;
    
}

- (BOOL)removeTarget:(id)target observerForKeyPaths:(NSString *)keyPaths
{
    return YES;
}

- (BOOL)setDataObject:(id)object forPropertyKey:(NSString *)key;
{
    
    // ALModelManager가 key에 해당하는 Property를 가지고 있는지 체크
    if (![_propertyNames containsObject:key]) {
        [self setValue:object forKey:key];
    } else {
        return NO;
    }
    return YES;
    
}


#pragma mark -
#pragma mark - Private Method
- (BOOL)addKVOForKeyPath:(NSString *)keypath observationInfo:(NSDictionary *)info
{
    
    id observingObject = _observationManager[keypath];
    // property를 가지고 있는지 체크
    if (observingObject && ![observingObject containsObject:info]) {
        
        NSDictionary *testDic = @{ @"a": @"b" };
        for (NSString *key in testDic) {
            
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        NSDictionary *dicResponse = [_observationManager valueForKey:keypath];
        
        id target   = [dicResponse objectForKey:MODEL_KEY];
        NSString *strSeletor  = [dicResponse objectForKey:RESPONSE_TARGET];
        
        [target performSelector:NSSelectorFromString(strSeletor) withObject:[info objectForKey:@"test"]];   // Object 가져 올 키 변경 해야 함
        
#pragma clang diagnostic pop
        
        // 관리 오브젝트 등록
        [_observationManager setObject:info forKey:keypath];
    } else {
        return NO;
    }
    return YES;
    
}

- (BOOL)ContainString:(NSString *)strSearch onText:(NSString *)strText
{
    return [strText rangeOfString:strSearch options:NSCaseInsensitiveSearch].location == NSNotFound ? FALSE : TRUE;
}

@end
