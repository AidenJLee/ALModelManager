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
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    
    if ((self = [super init])) {
        
        if ([decoder containsValueForKey:@"name"]) {
            self.name = [decoder decodeObjectForKey:@"gender"];
        }
        if ([decoder containsValueForKey:@"gender"]) {
            self.gender = [decoder decodeObjectForKey:@"gender"];
        }
        if ([decoder containsValueForKey:@"birthday"]) {
            self.birthday = [decoder decodeObjectForKey:@"birthday"];
        }
        
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setName:[self.name copy]];
    [theCopy setGender:[self.gender copy]];
    [theCopy setBirthday:[self.birthday copy]];
    
    return theCopy;
    
}

@end
