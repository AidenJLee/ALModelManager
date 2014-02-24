//
//  User.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark -
#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        self = [self init];
        [self setValuesForKeysWithDictionary:jsonDictionary];
    }
    return self;
}

#pragma mark -
#pragma mark - KVC Method Implement
// subclass implementation should provide correct key value mappings for custom keys
- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"%s Undefined Key: %@", __FUNCTION__, key);
    return nil;
}

// subclass implementation should set the correct key value mappings for custom keys
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Undefined Key: %@", key);
    if ([key isEqualToString:@"__v"]) {  // Sample
        
    } else {
        // 키 값 변경 시 충돌 문제가 발생 할 수 있어서 super 호출을 안함.
        // 문제는 super를 호출하지 않으면 상위 오브젝트로 전달 되어야 할 노티가 안갈수도 있음
        // 현재는 NSObject기 때문에 큰 문제는 없을것으로 예상 됨.
//        [super setValue:value forUndefinedKey:key];
    }
}

#pragma mark -
#pragma mark - NSCoder 
- (BOOL)allowsKeyedCoding
{
	return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	// do nothing.
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
    User *modelUser = [[User allocWithZone:zone] init];
    return modelUser;
}

- (id)copyWithZone:(NSZone *)zone
{
    // subclass implementation should do a deep mutable copy
    // this class doesn't have any ivars so this is ok
    User *modelUser = [[User allocWithZone:zone] init];
    return modelUser;
}

@end
