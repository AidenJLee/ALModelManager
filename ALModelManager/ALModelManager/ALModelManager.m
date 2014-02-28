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
 *  감시 할 대상에 대한 정보를 keypath를 통해 받아서 대상에 변경이 일어나면 block 코드를 호출 한다.
 *  ! 주의 : '*'로 모든 프로퍼티를 가져 올 수 있으나 '*'은 가장 마지막에만 있어야 한다.
 *
 *  @param target   콜백 대상
 *  @param keyPaths 감시 대상
 *  @param block    콜백 반환
 *
 *  @return Observer를 적용한 KeyPath 목록
 */
- (void)addKVOTarget:(id)target keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock
{
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    
    // 중복 및 개행 제거 - [ @" ", @"\n" ];
    NSString *strTrimKeyPaths = [keyPaths stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리
    NSArray *arrKeyPaths = [strTrimKeyPaths componentsSeparatedByString:@","];
    
    // 하나 이상의 KeyPath를 분리
    NSMutableArray *arrAbsoluteKeyPaths = [self createKeyPathArrayForKeyPathString:arrKeyPaths];
    
    for (NSString *keypath in arrAbsoluteKeyPaths) {
        
        NSMutableArray *arrTargets = [_observationManager objectForKey:keypath];
        if (!arrTargets) {
            arrTargets = [[NSMutableArray alloc] initWithObjects:target, nil];
            // 관리 오브젝트 등록
            [_observationManager setObject:arrTargets forKey:keypath];
            // KVO 등록
            [target observe:self keyPath:keypath block:^(NSString *observationKey, id observed, NSDictionary *change) {
                responseBlock(observationKey, observed, [change valueForKey:NSKeyValueChangeNewKey]);
            }];
        } else if (![arrTargets containsObject:target]) {
            [arrTargets addObject:target];
            // 관리 오브젝트 등록
            [_observationManager setObject:arrTargets forKey:keypath];
            // KVO 등록
            [target observe:self keyPath:keypath block:^(NSString *observationKey, id observed, NSDictionary *change) {
                responseBlock(observationKey, observed, [change valueForKey:NSKeyValueChangeNewKey]);
            }];
        } else {
            // 이미 등록 되어 있는것으로 판단
        }
        
    }
    
}

- (void)removeAllObserverForTarget:(id)target
{
    
}

- (BOOL)removeAllObserverForTarget:(id)target keyPaths:(NSString *)keyPaths
{
    return NO;
}


#pragma mark -
#pragma mark - Private Method
- (NSMutableArray *)createKeyPathArrayForKeyPathString:(NSArray *)arrKeyPaths;
{
    
    // 반환 객체
    NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
    
    for (NSString *strKeyPath in arrKeyPaths) {
        
        // KeyPath 내부에 *가 포함되어 있다면 모든 프로퍼티 이름을 가져와 KeyPath 생성
        if ([self ContainString:strKeyPath onText:@"*"]) {
            
            NSString *propertyKeyPath = [strKeyPath stringByReplacingOccurrencesOfString:@".*" withString:@""];
            
            // Property 이름을 목록으로 가져오기
            NSArray *arrPropertyNames = [ALIntrospection getPropertyNamesOfClass:[[self valueForKeyPath:propertyKeyPath] class] superInquiry:NO];
            
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
- (BOOL)setValueForKeyPath:(NSString*)keyPath andValue:(id)Value andTargetObject:(id)object
{
    [object setValue:Value forKeyPath:keyPath];
    
    return YES;
}

- (BOOL)ContainString:(NSString *)strSearch onText:(NSString *)strText
{
    return [strText rangeOfString:strSearch options:NSCaseInsensitiveSearch].location == NSNotFound ? FALSE : TRUE;
}

@end
