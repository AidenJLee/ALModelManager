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
- (void)observe:(id)object keyPath:(NSString *)keyPath block:(ALResponseBlock)block;
- (void)addCustomKVOForOwner:(id)owner object:(id)object keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock;
- (void)addCollectionKVOForOwner:(id)owner object:(id)object keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock;

- (void)removeAllObservers;
- (BOOL)removeAllObserverForOwner:(id)owner;
- (BOOL)removeAllObserverForOwner:(id)owner keyPaths:(NSString *)keyPaths;

@end
