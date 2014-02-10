//
//  ModelManagerProtocol.h
//  DateQ
//
//  Created by HoJun Lee on 2014. 2. 6..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelManagerProtocol <NSObject>

@required
- (id)initWithTarget:(id)target observingKeyPath:(NSString *)keyPath patchSeletor:(SEL)seletor;

@end
