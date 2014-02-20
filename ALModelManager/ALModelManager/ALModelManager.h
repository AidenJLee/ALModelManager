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

+ (ALModelManager *)sharedInstance;
+ (void)releaseInstance;

- (void)addTarget:(id)target observerForKeyPaths:(NSString *)keyPaths patchSeletor:(SEL)seletor;
- (void)addKVOForDictionary:(NSDictionary *)info;
- (void)removeKVOForDictionary:(NSDictionary *)info;

@end
