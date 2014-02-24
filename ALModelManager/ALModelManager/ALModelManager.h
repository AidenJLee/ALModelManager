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

@interface ALModelManager : NSObject <ALModelManagerProtocol>

// 이곳에 Data Model들을 Property로 등록한다.
// 외부에 singleton이면서 DataManager 역활을 하는 Object를 두었는데 싱글톤 남발인듯 하여 이곳으로 변경했다.
// 이곳에는 다른 Property는 등록하지 않는걸 추천한다. 필요한 변수가 있다면 내부 변수로 사용하는게 좋다.

// 데이터 변경은 직접 엑세스 하는걸로 변경.
// 입력 부분을 Wrapping 하여 사용자 오류를 최소화 하려고 했으나 노력에 비해 효율성이 적어서 관련 부분 삭제
@property (strong, nonatomic) NSDictionary *users;  // This is a Sample Model!


+ (ALModelManager *)sharedInstance;
+ (void)releaseInstance;

@end
