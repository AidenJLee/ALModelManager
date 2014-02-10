//
//  ModelManager.h
//  DateQ
//
//  Created by HoJun Lee on 2014. 2. 6..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelManagerProtocol.h"

@interface ModelManager : NSObject <ModelManagerProtocol>

// 일단 삭제. 생성 시 옵저빙 거는게 아니면 옵저빙 지우고 다시 거는게 애메함
//- (void)observingKeyPath:(NSString *)keyPath;

@end
