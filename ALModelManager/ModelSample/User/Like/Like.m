//
//  Like.m
//  ALModelManager
//
//  Created by AidenLee on 2014. 2. 28..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "Like.h"

@implementation Like

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
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    NSLog(@"Undefined Key: %@  Function : %s  Source Line : %d" , key, __FUNCTION__, __LINE__);
    
}

@end
