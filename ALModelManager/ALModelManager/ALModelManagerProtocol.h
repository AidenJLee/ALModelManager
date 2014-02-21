//
//  ALModelManagerProtocol.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const MODEL_KEY          = @"modelKey";
NSString * const RESPONSE_TARGET    = @"responseTarget";
NSString * const CALLBACK_SELECTOR  = @"callbackSeletor";

@protocol ALModelManagerProtocol <NSObject>

@required

- (void)didActiveManager;
- (void)didTerminateManager;

@end
