//
//  ALObservation.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 12..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//
// 출처 - https://github.com/rayh/kvo-block-binding

#import <Foundation/Foundation.h>

#import "NSObject+Observation.h"
/*
 [self observe:model keyPath:@"somePropertyKey" block:^(id observed, NSDictionary *change) {
    NSLog(@"observed : %@ " , observed);
    NSLog(@"new Object: %@ " , [change objectForKey:NSKeyValueChangeNewKey]);
 }];
 */

#import "NSObject+ObjectObserver.h"
/*
 [self.model addObserverForKeyPath:@"somePropertyKey" owner:self block:^(id observed, NSDictionary *change) {
    NSLog(@"observed : %@ " , observed);
    NSLog(@"new Object: %@ " , [change objectForKey:NSKeyValueChangeNewKey]);
 }];
 */

#import "NSObject+ObjectBinding.h"
/*
 [self.Button bindSourceKeyPath:@"seleted" to:imageView targetKeyPath:@"image" reverseMapping:YES];
 
 // add one way blocks to observe the stepper values
 [self observe:Button keyPath:@"seleted" block:^(id observed, NSDictionary *change) {
    //do something
 }];
 [self observe:imageView keyPath:@"image" block:^(id observed, NSDictionary *change) {
    //do something
 }];
 */
