//
//  ALModelManager.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 10..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALObservation.h"
#import "ALModelManagerProtocol.h"

#import "User.h"

@interface ALModelManager : NSObject <ALModelManagerProtocol>

// 이곳에 Data Model들을 Property로 등록한다.
// 외부에 singleton이면서 DataManager 역활을 하는 Object를 두었는데 싱글톤 남발인듯 하여 이곳으로 변경했다.
// 데이터 변경은 위험 하지만 Direct Property Access로 결정 - 이 부분은 문서 및 리뷰로 해결
@property (strong, nonatomic) NSMutableArray *dataModels; //data models sample

+ (ALModelManager *)sharedInstance;
+ (void)releaseInstance;

@end
