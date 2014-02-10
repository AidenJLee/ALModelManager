//
//  ModelManager.m
//  DateQ
//
//  Created by HoJun Lee on 2014. 2. 6..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//

#import "ModelManager.h"
#import "DataManager.h"
#import "ALIntrospection.h"
#import "THObserver.h"

@interface ModelManager () {
    
    id _target;         // 콜백대상
    SEL _patchSeletor;  // 변경시 콜백
    NSString *_keyPath;
    
}

@property (strong, nonatomic) id observingObject;

@end


@implementation ModelManager

#pragma mark -
#pragma mark Init
- (id)initWithTarget:(id)target observingKeyPath:(NSString *)keyPath patchSeletor:(SEL)seletor
{
    
    self = [super init];
    if (self) {
        
        NSParameterAssert(target);
        NSParameterAssert(keyPath);
        NSParameterAssert(seletor);
        
        _target         = target;
        _keyPath        = keyPath;
        _patchSeletor   = seletor;
        
        [self addObservingForKeyPath:_keyPath];
        
    }
    return self;
    
}

- (void)dealloc
{
    
}

- (void)addObservingForKeyPath:(NSString *)keyPath
{
    
    NSArray *keyPaths = [keyPath componentsSeparatedByString:@"."];
    id object = [ALIntrospection getPropertyValueOfObject:[DataManager sharedDataManager] name:[keyPaths firstObject]];
    
    for (NSString *obKey in keyPaths) {
        [THObserver observerForObject:object
                              keyPath:obKey
                                block:^{
                                    NSLog(@"%@ changed, is now %@", obKey, [ALIntrospection getPropertyValueOfObject:object name:obKey]);
                                }];
    }
    
}

- (void)removeObserverForKeyPath:(NSString *)keyPath
{
    
}

- (NSDictionary *)separateKeyPath:(NSString *)keyPath
{
    // @"user.*, chat._id, chat.male"
    NSMutableDictionary *dicKeyPath = [NSMutableDictionary new];        // 반환 객체
    
    NSArray *strKeyPaths = [keyPath componentsSeparatedByString:@","];  // 하나 이상의 KeyPath를 (,)기준으로 분리
    
    for (NSString *strAbsoluteKey in strKeyPaths) {     // ex) @[ user.*, chat._id, chat.male ]
        
        // 공백 및 개행 제거 후 KeyPath 분리 : 처음 값음 모델 key 값 - ex) user.name -> @[ @"user" , @"name" ]
        NSMutableArray *arrSeparatedKeyPath = [[strAbsoluteKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                               componentsSeparatedByString:@"."].mutableCopy;
        // model key - ex) user.name = @"User"
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

#pragma mark -
#pragma mark - Overriding KVO Method
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
//    if (context != &myContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    } else {
    
        id newObject = [change objectForKey:NSKeyValueChangeNewKey];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_target performSelector:_patchSeletor withObject:newObject];
        
#pragma clang diagnostic pop
        
//    }
    
}

#pragma mark -
#pragma mark - URI & DATA Control Method
//- (NSString *)URIStringWithURLKey:(NSString *)key
//{
//    NSString *URIString  = [[NSUserDefaults standardUserDefaults] objectForKey:STANDARDINFORMATION][@"URLParamate"][key];
//    return [URIString stringByReplacingOccurrencesOfString:@":id" withString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFORMATION][@"_id"]];
//}


//#pragma mark -
//#pragma mark - HTTP Method
//
//- (void)getURIType:(URIType)type withParameta:(NSDictionary *)param
//{
//    NSString *URLString = [self URIStringWithURIType:type];
//    [[AFAPIClient sharedClient] GET:URLString
//                         parameters:param
//                            success:^(NSURLSessionDataTask *task, id responseObject) {
//                                
//                                [self dataControlForResponseObject:responseObject withType:type];
//                                
//                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                
//                            }];
//}
//
//- (void)postURIType:(URIType)type withParameta:(NSDictionary *)param
//{
//    NSString *URLString = [self URIStringWithURIType:type];
//    [[AFAPIClient sharedClient] POST:URLString
//                          parameters:param
//           constructingBodyWithBlock:nil
//                             success:^(NSURLSessionDataTask *task, id responseObject) {
//                                 
//                                 [self dataControlForResponseObject:responseObject withType:type];
//                                 
//                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                 
//                             }];
//}
//
//- (void)putURIType:(URIType)type withParameta:(NSDictionary *)param
//{
//    NSString *URLString = [self URIStringWithURIType:type];
//    [[AFAPIClient sharedClient] PUT:URLString
//                         parameters:param
//                            success:^(NSURLSessionDataTask *task, id responseObject) {
//                                
//                                [self dataControlForResponseObject:responseObject withType:type];
//                                
//                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                
//                            }];
//}
//
//- (void)delURIType:(URIType)type withParameta:(NSDictionary *)param
//{
//    NSString *URLString = [self URIStringWithURIType:type];
//    [[AFAPIClient sharedClient] DELETE:URLString
//                            parameters:param
//                               success:^(NSURLSessionDataTask *task, id responseObject) {
//                                   
//                                   [self dataControlForResponseObject:responseObject withType:type];
//                                   
//                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                   
//                               }];
//}
//
//#pragma mark -
//#pragma mark - URI & DATA Control Method
//- (NSString *)URIStringWithURIType:(URIType)type
//{
//    NSString *URIString = @"";
//    
//    switch (type) {
//        case URITypeFeeds:
//            if (self.defaultUserInfo[@"_id"]) {
//                URIString = self.standardinformation[@"extend"][@"feeds"];
//                URIString = [URIString stringByReplacingOccurrencesOfString:@":id" withString:self.defaultUserInfo[@"_id"]];
//            } else {
//                URIString = self.standardinformation[@"basic"][@"users"];
//            }
//            
//            break;
//            
//        case URITypeUsers:
//            URIString = self.standardinformation[@"basic"][@"users"];
//            break;
//            
//        case URITypeMeets:
//            URIString = self.standardinformation[@"basic"][@"meets"];
//            break;
//            
//        case URITypeChats:
//            URIString = self.standardinformation[@"basic"][@"chats"];
//            break;
//            
//        case URITypePushs:
//            URIString = self.standardinformation[@"basic"][@"pushs"];
//            break;
//            
//        default:
//            break;
//    }
//    return URIString;
//}
//
//
//- (void)dataControlForResponseObject:(id)responseObject withType:(URIType)type
//{
//    if (type == URITypeFeeds) {
//        
//        self.arrFeeds = responseObject[@"result"];
//        
//    } else if (type == URITypeUsers) {
//        
//        self.arrUsers = responseObject[@"result"];
//        
//    } else if (type == URITypeMeets) {
//        
//        self.arrMeets = responseObject;
//        
//    } else if (type == URITypeChats) {
//        
//    } else if (type == URITypePushs) {
//        
//    } else if (type == URITypeUsers) {
//        
//    } else if (type == URITypeUsers) {
//        
//    } else if (type == URITypeUsers) {
//        
//    }
//}

@end
