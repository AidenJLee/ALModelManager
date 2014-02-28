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
#warning 옵저버 모두 지우는 로직 추가해야 함
    //    for (NSDictionary *dicObserverInfo in _observationManager) {
    //        [dicObserverInfo[@"someKey"] removeAllObservations];
    //    }
}

- (id)initModelManager
{
    self = [super init];
    if (self) {
        // do something~
        _observationManager = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
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
}

/**
 *  감시 할 대상에 대한 정보를 keypath를 통해 받아서 대상에 변경이 일어나면 block 코드를 호출 한다
 *  !주의 : 2 Depth 까지의 KeyPath만 지원 - @"key1.key2"
 *
 *  @param target   콜백 대상
 *  @param keyPaths 감시 대상
 *  @param block    콜백 반환
 *
 *  @return Observer를 적용한 KeyPath 목록
 */
- (NSArray *)addKVOTarget:(id)target keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock
{
    NSLog(keyPaths);
//            // KVO 등록
//            [target observe:self keyPath:keypath block:^(NSString *observationKey, id observed, id changeObject) {
//                responseBlock(observationKey, observed, changeObject);
//            }];
        
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
//            // 관리 오브젝트 등록
//            NSMutableArray *arrTargets = @[target].mutableCopy;
//            [_observationManager setObject:arrTargets forKey:keypath];
            
//        } else if (![arrTargets containsObject:target]) {
//            
//            // KVO 등록
//            [target observe:self keyPath:keypath block:^(NSString *observeKeypath, id observed, NSDictionary *change) {
//                responseBlock(observeKeypath, observed, [change valueForKey:NSKeyValueChangeNewKey]);
//            }];
//            
//            // 관리 오브젝트 등록
//            [_observationManager[keypath] addObject:target];
//
//        } else {
//            
//            // 이미 등록 되어 있는것으로 판단하여 반환 배열에서 Object를 제거
//            [arrKeyPaths removeObject:keypath];
//            
//        }
//        
//    }
//
//    return arrKeyPaths;
//
    return nil;
}

- (void)removeAllObserverForTarget:(id)target
{
    
}
- (BOOL)searchKeyPath: (NSArray *)keyPath
{
    BOOL isHaveStar = NO;
    
    for (NSString *str in keyPath)
    {
        if ([str isEqualToString:@"*"])
        {
            isHaveStar = YES;
        }
    }
    
    return isHaveStar;
}

- (BOOL)removeAllObserverForTarget:(id)target keyPaths:(NSString *)keyPaths
{
    return NO;
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
        
        // KeyPath 내부에 *가 포함되어 있다면 모든 프로퍼티 이름을 가져와 KeyPath 생성
        if ([self ContainString:strKeyPath onText:@"*"]) {
            
            // Property 이름을 목록으로 가져오기
            NSArray *arrPropertyNames = [ALIntrospection getPropertyNamesOfClass:[self class] superInquiry:NO];
            
            for (NSString *strPropertyKey in arrPropertyNames) {
                
                NSString *absoluteKeyPath = [strKeyPath stringByReplacingOccurrencesOfString:@"*" withString:strPropertyKey];
                if (![arrResponse containsObject:absoluteKeyPath]) {
                    [arrResponse addObject:absoluteKeyPath];
                }
                
            }
            
        } else {
            [arrResponse addObject:strKeyPath];
        }
        
    }
    
    return arrResponse;
    
}

- (BOOL)ContainString:(NSString *)strSearch onText:(NSString *)strText
{
    return [strText rangeOfString:strSearch options:NSCaseInsensitiveSearch].location == NSNotFound ? FALSE : TRUE;
}

@end
