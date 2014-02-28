//
//  Like.h
//  ALModelManager
//
//  Created by AidenLee on 2014. 2. 28..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "JSONModel.h"

@interface Like : JSONModel

@property (strong, nonatomic) NSString *movie;
@property (strong, nonatomic) NSString *sports;
@property (strong, nonatomic) NSString *something;

@end
