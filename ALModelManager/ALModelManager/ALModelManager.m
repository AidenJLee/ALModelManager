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
    NSArray *inventory = @[ @"iPhone5", @"iPhone5", @"iPhone5", @"iPadMini", @"macBookPro", @"macBookPro" ];
    
    [inventory valueForKeyPath:@"@unionOfObjects.name"]; // "iPhone 5", "iPhone 5", "iPhone 5", "iPad Mini", "MacBook Pro", "MacBook Pro"
    [inventory valueForKeyPath:@"@distinctUnionOfObjects.name"]; // "iPhone 5", "iPad Mini", "MacBook Pro"
    
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
 *
 *  @param target   콜백 대상
 *  @param keyPaths 감시 대상
 *  @param block    콜백 반환
 *
 *  @return Observer를 적용한 KeyPath 목록
 */
- (NSArray *)addKVOTarget:(id)target keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock
{
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    
    // 중복 및 개행 제거
    NSString *strTrimKeyPaths = [keyPaths stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // [ @" ", @"\n" ];
    
    // 하나 이상의 KeyPath를 분리
    NSMutableArray *arrKeyPaths = [self createKeyPathArrayForKeyPathString:strTrimKeyPaths];
    
    for (NSString *keypath in arrKeyPaths) {
        
        NSArray *arrTargets = [_observationManager objectForKey:keypath];
        if (!arrTargets) {
            
            // KVO 등록
            [target observe:self keyPath:keypath block:^(NSString *observeKeypath, id observed, NSDictionary *change) {
                responseBlock(observeKeypath, observed, [change valueForKey:NSKeyValueChangeNewKey]);
            }];
            
            // 관리 오브젝트 등록
            NSMutableArray *arrTargets = @[target].mutableCopy;
            [_observationManager setObject:arrTargets forKey:keypath];
            
        } else if (![arrTargets containsObject:target]) {
            
            // KVO 등록
            [target observe:self keyPath:keypath block:^(NSString *observeKeypath, id observed, NSDictionary *change) {
                responseBlock(observeKeypath, observed, [change valueForKey:NSKeyValueChangeNewKey]);
            }];
            
            // 관리 오브젝트 등록
            [_observationManager[keypath] addObject:target];
            
        } else {
            
            // 이미 등록 되어 있는것으로 판단하여 반환 배열에서 Object를 제거
            [arrKeyPaths removeObject:keypath];
            
        }
        
    }

    return arrKeyPaths;
    
}

- (void)removeAllObserverForTarget:(id)target
{
    
}

- (BOOL)removeAllObserverForTarget:(id)target keyPaths:(NSString *)keyPaths
{
    return NO;
}

//- (BOOL)setDataObject:(id)object forPropertyKey:(NSString *)key;
//{
//    
//    // Collection과 Custom Model의 분리가 쉽지 않아서 일단은 뎁스는 1뎁스만 지원
//    // ALModelManager가 key에 해당하는 Property를 가지고 있는지 체크
//    if ([_propertyNames containsObject:key]) {
//        
//        NSArray *arrKeyPaths = [key componentsSeparatedByString:@"."];
//        
//        if ([arrKeyPaths count] > 1) {
//            NSString *strFirstKey = [arrKeyPaths firstObject];
//            id propertyValue = [ALIntrospection getPropertyValueOfObject:self name:strFirstKey];
//            [propertyValue setValue:object forKey:key];
//        } else {
//            [self setValue:object forKey:key];
//        }
//        
//    } else {
//        return NO;
//    }
//    return YES;
//    
//}


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
