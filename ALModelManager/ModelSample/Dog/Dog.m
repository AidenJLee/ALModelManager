//
//  Dog.m
//  ALModelManager
//
//  Created by Aiden Lee on 2014. 2. 26..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "Dog.h"

@implementation Dog

#pragma mark -
#pragma mark - Initialize
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark - Keyed Archiving
- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    NSArray *propertyNames = @[ @"name", @"gender", @"birthday" ];
    
    for (NSString *pName in propertyNames) {
        [encoder encodeObject:[self valueForKey:pName] forKey:pName];
    }
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if ((self = [super init])) {
        
        NSArray *propertyNames = @[ @"name", @"gender", @"birthday" ];
        
        for (NSString *pName in propertyNames) {
            if ([decoder containsValueForKey:@"name"]) {
                [self setValue:[decoder decodeObjectForKey:pName] forKey:pName];
            }
        }
        
    }
    return self;
    
}


- (id)copyWithZone:(NSZone *)zone
{
    
    NSArray *propertyNames = @[ @"name", @"gender", @"birthday" ];

    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    for (NSString *pName in propertyNames) {
        [theCopy setValue:[[self valueForKey:pName] copy] forKey:pName];
    }
    
    return theCopy;
    
}

@end
