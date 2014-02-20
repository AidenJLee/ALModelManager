//
//  NSObject+Properties.h
//  ALModelManager
//
//  Created by Aiden Lee on 2014. 2. 20..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Properties)


// Also, note that the runtime information doesn't include an atomicity hint, so we
// can't determine that information

+ (BOOL)hasProperties;
+ (BOOL)hasPropertyName:(NSString *)name;

+ (SEL)getterForPropertyName:(NSString *)name;
+ (SEL)setterForPropertyName:(NSString *)name;

+ (NSArray *)propertyNames;
+ (NSArray *)propertyNamesWithSuperInquiry:(BOOL)superInquiry;

// instance convenience accessors for above routines - '[[myObject class] sameMethod'는 타이핑 낭비
- (BOOL)hasProperties;
- (BOOL)hasPropertyName:(NSString *)name;

- (SEL)getterForPropertyName:(NSString *)name;
- (SEL)setterForPropertyName:(NSString *)name;

- (NSArray *)propertyNames;
- (NSArray *)propertyNamesWithSuperInquiry:(BOOL)superInquiry;

@end

// getter/setter functions: unlike those above, these will return NULL unless a getter/setter is EXPLICITLY defined
SEL selectorForPropertyGetter(objc_property_t property);
SEL selectorForPropertySetter(objc_property_t property);
