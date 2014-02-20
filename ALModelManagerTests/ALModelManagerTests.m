//
//  ALModelManagerTests.m
//  ALModelManagerTests
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ALIntrospection.h"
#import "ALDataManager.h"

#import "User.h"

#import <objc/runtime.h>

@interface ALModelManagerTests : XCTestCase

@end

@implementation ALModelManagerTests

- (void)setUp
{
    [super setUp];
    User *user = [[User alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    objc_setAssociatedObject([ALDataManager sharedInstance], @"models", @{@"hi": @"i`m model"}, OBJC_ASSOCIATION_RETAIN);
    NSLog(@"%@", objc_getAssociatedObject([ALDataManager sharedInstance], @"models"));
    
    [ALIntrospection setPropertyValueOfObject:[ALDataManager sharedInstance] name:@"model" value:@{ @"dynamic": @"oh ye~" }];
    
    NSLog(@" %@", [ALIntrospection getPropertyNamesOfClass:[[ALDataManager sharedInstance] class] superInquiry:NO]);
    if ([ALIntrospection hasPropertyAtObject:[ALDataManager sharedInstance] name:@"observerObjects"]) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }
    
    [self separateKeyPath:@"User.user.id, NSDictionary.motels.name, User.some.property,  User.user.*"];
    XCTAssertNil(nil, @"test complete");
    
}

/* Start : keyPath = @"user.*, chat._id, chat.male" */
- (NSDictionary *)separateKeyPath:(NSString *)keyPath
{
    // 반환 객체
    NSMutableDictionary *dicKeyPath = [NSMutableDictionary new];
    
    // 하나 이상의 KeyPath를 (,)기준으로 분리
    /* keyPath = @[ user.*, chat._id, chat.male ] */
    NSArray *strKeyPaths = [keyPath componentsSeparatedByString:@","];
    
    for (NSString *strKeypath in strKeyPaths) {
        
        // 공백 및 개행 제거
        NSString *strAbsoluteKey = [strKeypath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // KeyPath를 .으로 분리
        NSMutableArray *arrSeparatedKeyPath = [strAbsoluteKey componentsSeparatedByString:@"."].mutableCopy;
        // 처음값이 모델 또는 컬렉션 명이라고 판단
        NSString *strModelKey = [[arrSeparatedKeyPath firstObject] capitalizedString];
        // 모델이 있는지 체크
        Class modelClass = NSClassFromString(strModelKey);
        
        for (NSString *strKey in arrSeparatedKeyPath) {
            if ([strKey isEqualToString:@"*"]) {
                
                NSArray *propertyNames = [ALIntrospection getPropertyNamesOfClass:modelClass superInquiry:NO];
                for (NSString *propertyKey in propertyNames) {
                    NSLog(@"%@", [strAbsoluteKey stringByReplacingOccurrencesOfString:@"*" withString:propertyKey]);
                }
                
            }
        }
        NSLog(@"%@", strAbsoluteKey);
        
    }
    
    return dicKeyPath;
}

@end
