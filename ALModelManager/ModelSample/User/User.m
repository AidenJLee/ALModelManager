//
//  User.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "User.h"
#import "Dog.h"

@implementation User

#pragma mark -
#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self) {
        _dogs = [[NSMutableArray alloc] init];
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
// 사용자 지정 키에 대한 올바른 키와 값의 매핑을 설정해야 하기때문에 서브 클래스 구현 함
// ex) Objective-c 예약어와 키가 겹쳐서 충돌이 난다면 여기서 변경
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    NSLog(@"Undefined Key: %@", key);
    if([key isEqualToString:@"id"]) { // 충돌 Sample
        self.userId = value;
    } else if ([key isEqualToString:@"__v"]) {
        
    } else {
        [super setValue:value forUndefinedKey:key];
    }
    
}

// 내부에 Collection을 가지고 있다면 그 키를 가로채어 Model을 생성 후 넣어준다
- (void)setValue:(id)value forKey:(NSString *)key
{
    
    // 하위 Depth 맵핑 - Dog
    if([key isEqualToString:@"dogs"]) {
        for(NSMutableDictionary *dogDict in value)
        {
            Dog *thisDog = [[Dog alloc] initWithDictionary:dogDict];
            [self.dogs addObject:thisDog];
        }
    } else {
        [super setValue:value forKey:key];
    }
    
}

@end
