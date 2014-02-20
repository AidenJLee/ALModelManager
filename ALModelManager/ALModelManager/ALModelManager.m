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

#define OBSERVING_MANAGEMENT_KEY @"observationsManagementKey"

@interface ALModelManager ()

// KVO 오브젝트를 관리 하기 위한 Dictionary
@property (strong, nonatomic) NSMutableArray *observerObjects;

@end


@implementation ALModelManager

#pragma mark -
#pragma mark Init
static ALModelManager *_modelManager = nil;
+ (ALModelManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _modelManager = [[ALModelManager alloc] initInstance];
    });
    return _modelManager;
}

+ (void)releaseInstance
{
    _modelManager = nil;
}

- (id)init
{
    NSAssert(NO, @"Can`t create instance With Init Method");
    return nil;
}

- (id)initInstance
{
    self = [super init];
    if (self) {
        _observerObjects = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)dealloc
{
    
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
- (void)addTarget:(id)target observerForKeyPaths:(NSString *)keyPaths patchSeletor:(SEL)seletor;
{
    
    NSParameterAssert(target);
    NSParameterAssert(keyPaths);
    NSParameterAssert(seletor);
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리
    /* keyPath = @[ user.*, chat._id, chat.male ] */
    NSArray *strKeyPaths = [keyPaths componentsSeparatedByString:@","];
    
    for (NSString *strKeypath in strKeyPaths) {
        
        // 공백 및 개행 제거
        NSString *strAbsoluteKey = [strKeypath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // KeyPath를 .으로 분리
        NSMutableArray *arrSeparatedKeyPath = [strAbsoluteKey componentsSeparatedByString:@"."].mutableCopy;
        
        // 처음값이 모델 또는 컬렉션 명이라고 판단
        NSString *strModelKey = [[arrSeparatedKeyPath firstObject] capitalizedString];
        
        // 모델이 있는지 체크
        Class modelClass = NSClassFromString(strModelKey);
        
        // Model key 지움
        [arrSeparatedKeyPath removeObjectAtIndex:0];
        
        if ([self Contains:strAbsoluteKey on:@"*"]) {
            
            for (NSString *strKey in arrSeparatedKeyPath) {
                if ([strKey isEqualToString:@"*"]) {
                    
                    NSArray *propertyNames = [ALIntrospection getPropertyNamesOfClass:modelClass superInquiry:YES];
                    for (NSString *propertyKey in propertyNames) {
                        
                        NSLog(@"%@", [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey]);
                        NSDictionary *observeDic = @{
                                                     @"modelkey": strModelKey,
                                                     @"keypath": [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey],
                                                     @"target": target,
                                                     @"selector": NSStringFromSelector(seletor)
                                                     };
                        
                        // KVO 적용 및 객체 관리
                        [self addKVOForDictionary:observeDic];
                        NSLog(@"%@", observeDic);
                        
                    }
                    
                }
            }
            
        } else {
            
            NSDictionary *observeDic = @{
                                         @"modelkey": strModelKey,
                                         @"keypath": strAbsoluteKey,
                                         @"target": target,
                                         @"selector": NSStringFromSelector(seletor)
                                         };
            
            // KVO 적용 및 객체 관리
            [self addKVOForDictionary:observeDic];
            NSLog(@"%@", observeDic);
            
        }
        
    }
    
}

/**

 *
 *  @param keyPaths 감시하고자 하는 Object의 Property값들의 String
 *                  ex) @"NSDictionary.users, User.user.email"
 */
- (void)addKVOForDictionary:(NSDictionary *)info
{
    NSParameterAssert(info);
    
    if (![self.observerObjects containsObject:info]) {
        
        
        
        [self.observerObjects addObject:info];
    }
    
}

- (void)removeKVOForDictionary:(NSDictionary *)info
{
    //    [model k:@"board.list" v:@[@{@"num":1,@"title":"제목1"}, @{@"num":1,@"title":"제목1"}]];
    //    [model k:@"system.uuid" v:@"uuid...."];
    //    NSMutableArray * arr = [model g:@"board.list"];
    //    [arr addObject:@{@"num":1,@"title":"제목1"}];
    //    [arr replaceObjectAtIndex:1 withObject:@{@"num":1,@"title":"제목1"}];
}

#pragma mark -
#pragma mark - Private Method
- (BOOL)Contains:(NSString *)strSearchTerm on:(NSString *)strText
{
    return [strText rangeOfString:strSearchTerm options:NSCaseInsensitiveSearch].location == NSNotFound? FALSE : TRUE;
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

- (void)addObserverObject:(id)anObject forKey:(NSString *)key
{
    NSParameterAssert(key);
}

/*
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
 
 [_target performSelector:_patchSeletor withObject:newObject];
 
 #pragma clang diagnostic pop
 */
#pragma mark -
#pragma mark - Private Method
- (NSMutableArray *)allObjectObservers
{
	NSMutableArray *objects = objc_getAssociatedObject(self, OBSERVING_MANAGEMENT_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, OBSERVING_MANAGEMENT_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    return objects;
}

@end
