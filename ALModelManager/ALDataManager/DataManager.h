//
//  DataManager.h
//  DateQ
//
//  Created by HoJun Lee on 2014. 2. 1..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h" /** 모델 값은 프로젝트마다 다르기 때문에 모델에 대한것은 프로젝트에 맞게 변경 */


@interface DataManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *results;
@property (strong, nonatomic) User *user;

+ (DataManager *)sharedDataManager;
+ (void)releaseDataManager;

@end
