//
//  User.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying, NSMutableCopying>

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSArray *education;
@property (strong, nonatomic) NSArray *work;
@property (strong, nonatomic) NSArray *likes;
@property (strong, nonatomic) NSString *likestate;
@property (strong, nonatomic) NSDictionary *profiles;
@property (strong, nonatomic) NSString *intro;
@property (strong, nonatomic) NSDictionary *loc;
@property (strong, nonatomic) NSArray *blacklists;
@property (strong, nonatomic) NSDate *activity;
@property (strong, nonatomic) NSDate *create_at;
@property (strong, nonatomic) NSDate *update_at;

- (id)initWithDictionary:(NSDictionary *)jsonDictionary;

@end
