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
- (NSArray *)addKVOTarget:(id)target keyPaths:(NSString *)keyPaths block:(ALResponseBlock)responseBlock;
- (BOOL)removeAllObserverForTarget:(id)target keyPaths:(NSString *)keyPaths;
- (void)removeAllObserverForTarget:(id)target;

@end
