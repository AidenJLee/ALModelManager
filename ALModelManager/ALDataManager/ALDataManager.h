//
//  ALDataManager.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

/** 모델 값은 프로젝트마다 다르기 때문에 모델에 대한것은 프로젝트에 맞게 변경 */
#import "User.h"

@interface ALDataManager : NSObject

@property (strong, nonatomic) User *user;

+ (ALDataManager *)sharedALDataManager;
+ (void)releaseALDataManager;

@end
