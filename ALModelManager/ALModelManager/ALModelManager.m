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

#import <objc/runtime.h>

#define OBSERVING_MANAGEMENT_KEY @"observingManagementKey"

@interface ALModelManager () {
    
    NSMutableDictionary *_observationManager;
    
}

@end


@implementation ALModelManager

#pragma mark -
#pragma mark Init
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
        // do something~  ex) Init...
        _observationManager = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark - Init&Dealloc
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
- (void)addTarget:(id)target observerForKeyPaths:(NSString *)keyPaths patchSeletor:(SEL)seletor
{
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    NSParameterAssert(seletor);
    
    NSMutableDictionary *responseDictionary = @{
                                                @"user.name": @[
                                                        @{
                                                            @"model": @"모델 명",
                                                            @"target": @"반환 대상",
                                                            @"seletor": @"콜백 대상"
                                                            }
                                                        ]
                                                };
    /*
     */
    
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
    
}

- (void)setDataObject:(id)object forPropertyKeyPath:(NSString *)keyPath;
{
    
}


#pragma mark -
#pragma mark - Private Method
- (BOOL)Contains:(NSString *)strSearchTerm on:(NSString *)strText
{
    return [strText rangeOfString:strSearchTerm options:NSCaseInsensitiveSearch].location == NSNotFound ? FALSE : TRUE;
}

/* Start : keyPath = @"user.*, chat._id, chat.male" */
//- (NSDictionary *)separateKeyPath:(NSString *)keyPath
//{
//    // 반환 객체
//    NSMutableDictionary *dicKeyPath = [NSMutableDictionary new];
//    
//    // 하나 이상의 KeyPath를 (,)기준으로 분리 = @[ user.*, chat._id, chat.male ]
//    NSArray *strKeyPaths = [keyPath componentsSeparatedByString:@","];
//    
//    for (NSString *strKeypath in strKeyPaths) {
//        
//        // 공백 및 개행 제거
//        NSString *strAbsoluteKey = [strKeypath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        
//        
//        // 공백 및 개행 제거 후 KeyPath 분리 = user.name -> @[ @"user" , @"name" ] - 처음 값은 모델 key값 이라고 정의
//        NSMutableArray *arrSeparatedKeyPath = [[strAbsoluteKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
//                                               componentsSeparatedByString:@"."].mutableCopy;
//        // model key = ex) user.name = @"User"
//        NSString *strModelKey = [[arrSeparatedKeyPath firstObject] capitalizedString];
//        [arrSeparatedKeyPath removeObjectAtIndex:0];    // Model key 지움
//        if (![dicKeyPath objectForKey:strModelKey]) {
//            [dicKeyPath setObject:[NSMutableArray array] forKey:strModelKey];
//        }
//        
//        Class modelClass = NSClassFromString(strModelKey);
//        NSParameterAssert(modelClass);  // Model이 있는지 검사
//        
//        for (NSString *strKey in arrSeparatedKeyPath) {
//            
//            if ([strKey isEqualToString:@"*"]) {
//                
//                NSArray *propertyNames = [ALIntrospection getPropertyNamesOfClass:modelClass superInquiry:NO];
//                for (NSString *propertyKey in propertyNames) {
//                    [dicKeyPath[strModelKey] addObject:propertyKey];
//                }
//                
//            } else {
//                [dicKeyPath[strModelKey] addObject:strKey];
//            }
//            
//        }
//        
//    }
//    
//    return dicKeyPath;
//}


/*
 // 응답값을 seletor로 반환 해주는 부분
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
 
 [_target performSelector:_patchSeletor withObject:newObject];
 
 #pragma clang diagnostic pop
 */

- (NSMutableArray *)allObserverObjects
{
	NSMutableArray *objects = objc_getAssociatedObject(self, OBSERVING_MANAGEMENT_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, OBSERVING_MANAGEMENT_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    return objects;
}

@end
