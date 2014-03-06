//
//  ALModelManager.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "ALObservation.h"
#import "ALModelManagerProtocol.h"

@interface ALModelManager : NSObject <ALModelManagerProtocol>

+ (ALModelManager *)sharedInstance;
+ (void)releaseInstance;

- (void)didActiveManager;
- (void)didTerminateManager;


@end
