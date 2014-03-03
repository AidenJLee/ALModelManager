//
//  ALModelManagerProtocol.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ALResponseBlock)(NSString *observedKey, id observed, id changedObject);

@protocol ALModelManagerProtocol <NSObject>

@required
- (void)addKVOForOwner:(id)owner keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock;
- (void)addKVOForObject:(id)object owner:(id)owner keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock;
- (BOOL)removeAllObserverForTarget:(id)target keyPaths:(NSString *)keyPaths;
- (void)removeAllObserverForTarget:(id)target;
- (BOOL)setValueForKeyPath:(NSString*)keyPath andValue:(id)Value andTargetObject:(id)object;
@end
