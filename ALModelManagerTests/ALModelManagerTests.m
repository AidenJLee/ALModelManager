//
//  ALModelManagerTests.m
//  ALModelManagerTests
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ALIntrospection.h"
#import "ALModelManager.h"
#import "ALObservation.h"

#import "User.h"

#import <objc/runtime.h>

@interface ALModelManagerTests : XCTestCase

@end

@implementation ALModelManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    
    
    NSMutableDictionary *info = @{
                                  @"user" : @{
                                          @"id"         : @"don`t tell mama",
                                          @"username"   : @"aiden",
                                          @"gender"     : @"male",
                                          @"like"       : @{
                                                  @"movie"    : @"ins....",
                                                  @"sports"   : @"야구",
                                                  @"something": @"Nice ambience, great food. The teriyaki is a must try!",
                                                  },
                                          @"dogs"       : @[@{
                                                                @"name"    : @"puppt",
                                                                @"gender"  : @"female",
                                                                @"birthday": @"2012.01.01",
                                                                },
                                                            @{
                                                                @"name"    : @"bowwow",
                                                                @"gender"  : @"male",
                                                                @"birthday": @"2014.02.01",
                                                                }
                                                      ]
                                       }
                                  }.mutableCopy;
    
    User *user = [[User alloc] initWithDictionary:info[@"user"]];
    
    NSLog(@"id : %@ " , user.userId);
    NSLog(@"sports : %@ " , [user valueForKeyPath:@"like.sports"]);
    XCTAssertNil(nil, @"test complete");
    
    ALModelManager *manager = [ALModelManager sharedInstance];
    
    [manager setUser:user];
    [self observe:manager keyPath:@"user.username" block:^(NSString *observationKey, id observed, NSDictionary *change) {
        NSLog(@"change : %@ " , [change valueForKey:NSKeyValueChangeNewKey]);
    }];
    
    manager.user.username = @"aidenjlee";
    
    [manager setValueForKeyPath:@"like.sports" andValue:@"축구" andTargetObject:user];
    NSLog(@"sports : %@ " , [user valueForKeyPath:@"like.sports"]);
    
    
}
- (void)testMethod
{
    
}

@end

/*
 @property (strong, nonatomic) NSString *username;
 @property (strong, nonatomic) NSString *gender;
 @property (strong, nonatomic) NSMutableArray *dogs;
 @property (strong, nonatomic) Like *like;
 @property (strong, nonatomic) NSString *movie;
 @property (strong, nonatomic) NSString *sports;
 @property (strong, nonatomic) NSString *something;
*/