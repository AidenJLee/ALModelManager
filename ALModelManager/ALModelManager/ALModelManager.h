//
//  ALModelManager.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALModelManagerProtocol.h"

@interface ALModelManager : NSObject <ALModelManagerProtocol>

@property (strong, nonatomic) NSMutableDictionary *observerKeys;

- (void)addObserverForKeyPaths:(NSString *)keyPaths;
- (void)removeObserverForKeyPaths:(NSString *)keyPaths;

@end
