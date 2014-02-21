//
//  NSObject+Observation.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "NSObject+Observation.h"
#import <objc/runtime.h>

#define OBJ_OBSERVING_KEY @"observationsKey"

@implementation NSObject (Observation)

#pragma mark -
#pragma mark - Public Method Implement
- (ALObservationObject *)observe:(id)object
                         keyPath:(NSString *)keyPath
                           block:(ObservationObjectBlock)block
{
    return [self observe:object
                 keyPath:keyPath
                 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                   block:block];
}

- (ALObservationObject *)observe:(id)object
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                          block:(ObservationObjectBlock)block
{
    
    for(ALObservationObject *binding in [NSArray arrayWithArray:[self allObservations]]) {
        if(![binding.source isEqual:object] && ![binding.keyPath isEqualToString:keyPath]) {
            
            ALObservationObject *createBinding = [[ALObservationObject alloc] init];
            
            createBinding.owner = self;
            createBinding.source = object;
            createBinding.keyPath = keyPath;
            createBinding.block = block;
            
            [[self allObservations] addObject:createBinding];
            [object addObserver:createBinding forKeyPath:keyPath options:options context:(__bridge void *)createBinding];
            
            return createBinding;
            
        }
    }
    
    return nil;
}

- (void)removeAllObservations
{
    for(ALObservationObject *binding in [NSArray arrayWithArray:[self allObservations]]) {
        [binding invalidate];
        [[self allObservations] removeObject:binding];
    }
}

- (void)removeAllObservationsForObject:(id)object
{
    for(ALObservationObject *binding in [NSArray arrayWithArray:[self allObservations]]) {
        if([binding.source isEqual:object]) {
            [binding invalidate];
            [[self allObservations] removeObject:binding];
        }
    }
}

- (void)removeObservationsForObject:(id)object keyPath:(NSString*)keyPath
{
    for(ALObservationObject *binding in [NSArray arrayWithArray:[self allObservations]]) {
        if([binding.source isEqual:object] && [binding.keyPath isEqualToString:keyPath]) {
            [binding invalidate];
            [[self allObservations] removeObject:binding];
        }
    }
}

#pragma mark -
#pragma mark - Private Method
- (NSMutableArray *)allObservations
{
	NSMutableArray *objects = objc_getAssociatedObject(self, OBJ_OBSERVING_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, OBJ_OBSERVING_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    
    return objects;
}

@end
