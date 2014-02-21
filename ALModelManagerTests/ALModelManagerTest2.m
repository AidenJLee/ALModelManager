//
//  ALModelManagerTest2.m
//  ALModelManager
//
//  Created by Aiden Lee on 2014. 2. 21..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ALModelManager.h"

@interface ALModelManagerTest2 : XCTestCase

@end

@implementation ALModelManagerTest2

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    [[ALModelManager sharedInstance] didActiveManager];
    [[ALModelManager sharedInstance] addTarget:self observerForKeyPaths:@"users, users" block:^(NSString *observedKey, id changeObject) {
        NSLog(@"observedKey : %@ " , observedKey);
        NSLog(@"change object : %@ " , changeObject);
    }];
    
    NSDictionary *userDic = @{
                              @"_id": @"13579",
                              @"facebook": @"534985034579",
                              @"email": @"entist@me.com",
                              @"username": @"aidenjlee"
                              };
    
    [[ALModelManager sharedInstance] setDataObject:userDic forPropertyKey:@"users"];
    
    XCTAssertNil(nil, @"test complete");
}

@end
