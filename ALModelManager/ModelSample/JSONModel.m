//
//  JSONModel.m
//  ALModelManager
//
//  Created by Aiden Lee on 2014. 2. 26..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel

#pragma mark -
#pragma mark - Initialize
- (id)initWithDictionary:(NSMutableDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        self = [self init];
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
}

#pragma mark -
#pragma mark - KVC Method Implement
// subclass implementation should provide correct key value mappings for custom keys
- (id)valueForUndefinedKey:(NSString *)key
{
    NSLog(@"%s | Undefined Key: %@", __FUNCTION__, key);
    return nil;
}

// subclass implementation should set the correct key value mappings for custom keys
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Undefined Key: %@  Function : %s  Source Line : %d" , key, __FUNCTION__, __LINE__);
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
    JSONModel *model = [[JSONModel allocWithZone:zone] init];
    return model;
}

- (id)copyWithZone:(NSZone *)zone
{
    JSONModel *model = [[JSONModel allocWithZone:zone] init];
    return model;
}

@end
