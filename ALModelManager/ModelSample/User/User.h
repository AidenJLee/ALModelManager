//
//  User.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "JSONModel.h"

@class Like;
@interface User : JSONModel

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSMutableArray *dogs;
@property (strong, nonatomic) Like *like;

@end
