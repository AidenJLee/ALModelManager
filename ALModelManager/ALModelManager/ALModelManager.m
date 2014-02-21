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
//    for (NSDictionary *dicObserverInfo in _observationManager) {
//        [dicObserverInfo[@"someKey"] removeAllObservations];
//    }
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
 *  감시 할 대상에 대한 정보를 keypath를 통해 받아서 대상에 변경이 일어나면 block 코드를 호출 한다
 *
 *  @param target   콜백 대상
 *  @param keyPaths 감시 대상
 *  @param block    콜백 반환
 *
 *  @return Observer를 적용한 KeyPath 목록
 */
// @"users, users.*, hotels, hotels.brand"
- (NSArray *)addTarget:(id)target observerForKeyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock
{
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    
    NSString *strTrimKeyPaths = [keyPaths stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // [ @" ", @"\n" ];
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리
    NSMutableArray *arrKeyPaths = [self createKeyPathArrayForKeyPathString:strTrimKeyPaths];     /* arrKeyPaths = @[ @"users", @"users.*", @"hotels", @"hotel.brand" ] */
    
    // KVO 등록
    for (NSString *keypath in arrKeyPaths) {
        
        NSArray *arrTargets = _observationManager[keypath];
        if (!arrTargets) {
            
            // KVO 등록
            [self observe:self keyPath:@"users" block:^(id observed, NSDictionary *change) {
                responseBlock(@"users", [change valueForKey:NSKeyValueChangeNewKey]);
            }];
            [self.users addObserverForKeyPath:@"users" owner:target block:^(id observed, NSDictionary *change) {
                responseBlock(@"users", [change valueForKey:NSKeyValueChangeNewKey]);
            }];
            
            // 관리 오브젝트 등록
            [_observationManager setObject:@[target].mutableCopy forKey:keypath];
            
        } else if (![arrTargets containsObject:target]) {
            
            // KVO 등록
            [self.users addObserverForKeyPath:@"users" owner:target block:^(id observed, NSDictionary *change) {
                responseBlock(@"users", [change valueForKey:NSKeyValueChangeNewKey]);
            }];
            
            // 관리 오브젝트 등록
            [_observationManager[keypath] addObject:target];
            
        } else {
            
            [arrKeyPaths removeObject:keypath];
            
        }
        
    }

    return arrKeyPaths;
    
}

- (void)removeForTarget:(id)target
{
    
}

- (void)removeForTarget:(id)target observerForKeyPaths:(NSString *)keyPaths
{
    
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
- (NSMutableArray *)createKeyPathArrayForKeyPathString:(NSString *)keyPaths;
{
    
    // 반환 객체
    NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리
    NSArray *arrKeyPaths = [keyPaths componentsSeparatedByString:@","];
    
    for (NSString *strKeyPath in arrKeyPaths) {
        
        if ([self ContainString:strKeyPath onText:@"*"]) {
            
            NSArray *strPropertyNames = [ALIntrospection getPropertyNamesOfClass:[self class] superInquiry:NO];
            
            for (NSString *strPropertyKey in strPropertyNames) {
                
                NSString *absoluteKeyPath = [strKeyPath stringByReplacingOccurrencesOfString:@"*" withString:strPropertyKey];
                if ([arrResponse containsObject:absoluteKeyPath]) {
                    [arrResponse addObject:absoluteKeyPath];
                }
                
            }
            
        } else {
            
            [arrResponse addObject:strKeyPath];
            
        }
        
    }
    
    return arrResponse;
    
}

- (BOOL)addKVOForKeyPath:(NSString *)keypath observationInfo:(NSDictionary *)info
{
    
    id observingObject = _observationManager[keypath];
    // property를 가지고 있는지 체크
    if (observingObject && ![observingObject containsObject:info]) {
        
        NSDictionary *testDic = @{ @"a": @"b" };
        for (NSString *key in testDic) {
            
        }
        
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

/*
 // 하나 이상의 KeyPath를 (,)기준으로 분리

for (NSString *strKeypath in arrKeyPaths) {
    
    // 공백 및 개행 제거
    NSString *strAbsoluteKey = [strKeypath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  // [ @" ", @"\n" ]
    
    [arrResponse addObject:@{ strKeypath: target }];
    // 다수의 KeyPath 지원을 위해 .을 기준으로 분리 ( *로 모두 선택 지원용 )
    NSMutableArray *arrSeparatedKeyPath = [strAbsoluteKey componentsSeparatedByString:@"."].mutableCopy;
    
    // 일단 보류 ( 정확한 데이터 타입 체크를 위해 복잡성이 증가함 )
     // 처음값이 모델 또는 컬렉션 명이라고 판단
     //        NSString *strModelName = [[arrSeparatedKeyPath firstObject] capitalizedString]; // 일단 보류
     
     // 모델이 있는지 체크
     Class modelClass = NSClassFromString(strModelName);
     id model = [modelClass alloc];
     
     // Model key 지움
     [arrSeparatedKeyPath removeObjectAtIndex:0];
    
    if ([self Contains:strAbsoluteKey on:@"*"]) {
        
        for (NSString *strKey in arrSeparatedKeyPath) {
            if ([strKey isEqualToString:@"*"]) {
                
                NSArray *propertyNames = [ALIntrospection getPropertyNamesOfClass:modelClass superInquiry:NO];
                for (NSString *propertyKey in propertyNames) {
                    
                    NSLog(@"%@", [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey]);
                    NSDictionary *observeDic = @{
                                                 @"modelkey": strModelName,
                                                 @"keypath": [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey],
                                                 @"target": target,
                                                 @"selector": NSStringFromSelector(seletor)
                                                 };
                    
                    // KVO 적용 및 객체 관리
                    //                        [self addKVOForDictionary:observeDic];
                    NSLog(@"%@", observeDic);
                    
                }
                
            }
        }
        
    } else {
        
        NSDictionary *observeDic = @{
                                     @"modelkey": strModelName,
                                     @"keypath": strAbsoluteKey,
                                     @"target": target,
                                     @"selector": NSStringFromSelector(seletor)
                                     };
        
        // KVO 적용 및 객체 관리
        //            [self addKVOForDictionary:observeDic];
        NSLog(@"%@", observeDic);
        
    }
    
}
 */

@end
