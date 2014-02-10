//
//  ALIntrospection.h
//  DateQ
//
//  Created by HoJun Lee on 2014. 2. 6..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALIntrospection : NSObject

/**
 *  객체에서 주어진 이름을 가진 프로퍼티의 값을 셋팅한다.
 *
 *  @param object 대상 객체
 *  @param name   추가되는 Key
 *  @param value  추가되는 Value
 */
+ (void)setPropertyValueOfObject:(id)object name:(NSString*)name value:(id)value;


/**
 *  객체에서 주어진 이름을 가진 프로퍼티의 값을 가져온다.
 *
 *  @param object 대상 객체
 *  @param name   찾고자 하는 값의 key
 *
 *  @return 찾은 Value
 */
+ (id)getPropertyValueOfObject:(id)object name:(NSString*)name;


/**
 *  객체가 특정 이름의 프로퍼티를 가지고 있는지 체크
 *
 *  @param object 대상 객체
 *  @param name   체크하려는 프로퍼티 이름
 *
 *  @return 프로퍼티가 있는지 여부
 */
+ (BOOL)hasPropertyAtObject:(id)object name:(NSString*)name;


/**
 *  클래스에서 주어진 이름의 프로퍼티를 가지고 있는지 체크
 *
 *  @param clazz 대상 클래스
 *  @param name  체크하려는 프로퍼티 이름
 *
 *  @return 프로퍼티가 있는지 여부
 */
+ (BOOL)hasPropertyAtClass:(Class)clazz name:(NSString*)name;


/**
 *  객체에 주어진 이름의 프로퍼티를 찾아서 그것의 클래스를 가져온다.
 *
 *  @param object 대상 객체
 *  @param name   찾을 프로퍼티 이름
 *
 *  @return 프로퍼티의 클래스
 */
+ (Class)getPropertyClassOfObject:(id)object name:(NSString*)name;


/**
 *  클래스에 주어진 이름의 프로퍼티를 찾아서 그것의 클래스를 가져온다.
 *
 *  @param clazz 대상 클래스
 *  @param name  찾을 프로퍼티 이름
 *
 *  @return 프로퍼티의 클래스
 */
+ (Class)getPropertyClassOfClass:(Class)clazz name:(NSString*)name;


/**
 *  클래스의 프로퍼티 이름을 배열로 가져온다.
 *
 *  @param clazz        대상 클래스
 *  @param superInquiry 해당 클래스의 부모클래스 프로퍼티로 탐색 할것인지 결정하는 플래그
 *
 *  @return 프로퍼티 이름들을 가진 배열
 */
+ (NSArray*)getPropertyNamesOfClass:(Class)clazz superInquiry:(BOOL)superInquiry;

@end
