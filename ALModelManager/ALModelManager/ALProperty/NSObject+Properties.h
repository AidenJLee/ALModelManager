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

/**
 *  객체가 Property들을 가지고 있는지 체크하는 메소드
 *
 *  @return Property를 가지고 있는지 여부
 */
+ (BOOL)hasProperties;

/**
 *  객체가 Property를 가지고 있는지 체크하는 메소드
 *
 *  @param name 체크 하고자 하는 Property 이름
 *
 *  @return 주어진 이름에 해당하는 Property를 가지고 있는지 여부
 */
+ (BOOL)hasPropertyName:(NSString *)name;


/**
 *  특정 Property가 가지고 있는 getterSelector를 반환하는 메소드
 *  getter를 직접 만들지 않았다면 Xcode가 자동으로 생성해주는 getter가 반환한다.
 *
 *  @param name 셀렉터를 찾을 Property 이름
 *
 *  @return 해당 Property의 getterSelector를 반환
 */
+ (SEL)getterForPropertyName:(NSString *)name;

/**
 *  특정 Property가 가지고 있는 setterSelector를 반환하는 메소드
 *  setter를 직접 만들지 않았다면 Xcode가 자동으로 생성해주는 setter가 반환한다.
 *
 *  @param name 셀렉터를 찾을 Property 이름
 *
 *  @return 해당 Property의 setterSelector를 반환
 */
+ (SEL)setterForPropertyName:(NSString *)name;


/**
 *  객체의 Property들의 이름들을 배열로 반환하는 메소드
 *
 *  @return Property 이름이 담긴 배열
 */
+ (NSArray *)propertyNames;

/**
 *  객체의 Property들의 이름들을 배열로 반환하는 메소드
 *
 *  @param superInquiry super가 가지고 있는 Property도 검색 할지 여부
 *
 *  @return Property 이름이 담긴 배열
 */
+ (NSArray *)propertyNamesWithSuperInquiry:(BOOL)superInquiry;


#pragma mark -
#pragma mark - Instance Method Imple
// instance에서 바로 접근 할 수 있다록 만든 메소드 - [[myObject class] sameMethod'는 타이핑 낭비
// Class Method와 같은 기능이기 때문에... 아래 클릭
// http://mirror.enha.kr/wiki/%EB%8D%94%20%EC%9D%B4%EC%83%81%EC%9D%98%20%EC%9E%90%EC%84%B8%ED%95%9C%20%EC%84%A4%EB%AA%85%EC%9D%80%20%EC%83%9D%EB%9E%B5%ED%95%9C%EB%8B%A4
- (BOOL)hasProperties;
- (BOOL)hasPropertyName:(NSString *)name;

- (SEL)getterForPropertyName:(NSString *)name;
- (SEL)setterForPropertyName:(NSString *)name;

- (NSArray *)propertyNames;
- (NSArray *)propertyNamesWithSuperInquiry:(BOOL)superInquiry;

@end

// getter/setter를 위한 메소드
// 위와는 다르게 NULL을 명시적으로 사용한다. 이유는 Core를 활용하여 C와 관련 된 메소드를 사용하였기 때문에!
SEL selectorForPropertyGetter(objc_property_t property);
SEL selectorForPropertySetter(objc_property_t property);
