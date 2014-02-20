//
//  ALDataManager.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

@interface ALDataManager : NSObject

// Property값은 런타임에 추가 한다.
@property (strong, nonatomic) NSMutableArray *observerObjects;
@property (strong, nonatomic) NSMutableArray *observerObject;

+ (ALDataManager *)sharedInstance;
+ (void)releaseInstance;

@end
