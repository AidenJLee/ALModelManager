//
//  ALIntrospection.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 6..
//  Copyright (c) 2014년 Plan2white. All rights reserved.
//
// 출처 - JIDOL STAR : http://blog.jidolstar.com/854
// 참고 - https://developer.apple.com/library/mac/documentation/General/Conceptual/DevPedia-CocoaCore/KVO.html#//apple_ref/doc/uid/TP40008195-CH16-SW1


#import <objc/runtime.h>
#import "ALIntrospection.h"

@implementation ALIntrospection


//객체에서 주어진 이름을 가진 프로퍼티의 값을 셋팅한다.
+ (void)setPropertyValueOfObject:(id)object name:(NSString*)name value:(id)value {
    Ivar ivar = class_getInstanceVariable([object class], [[NSString stringWithFormat:@"_%@", name] UTF8String]);
    object_setIvar( object, ivar, value );;
}

//객체에서 주어진 이름을 가진 프로퍼티의 값을 가져온다.
+ (id)getPropertyValueOfObject:(id)object name:(NSString*)name {
    Ivar ivar = class_getInstanceVariable([object class], [[NSString stringWithFormat:@"_%@", name] UTF8String]);
    return object_getIvar( object, ivar );
}

//객체에서 주어진 이름의 프로퍼티를 가지고 있는가?
+ (BOOL)hasPropertyAtObject:(id)object name:(NSString*)name {
    return [self hasPropertyAtClass:[object class] name:name ];
}

//클래스에서 주어진 이름의 프로퍼티를 가지고 있는가?
+ (BOOL)hasPropertyAtClass:(Class)clazz name:(NSString*)name {
    objc_property_t p0 = class_getProperty(clazz, [name UTF8String]);
    return p0 ? YES : NO;
}

//주어지는 이름을 가진 객체의 프로퍼티를 찾아 그것의 클래스를 가져온다.
+ (Class)getPropertyClassOfObject:(id)object name:(NSString*)name {
    return [self getPropertyClassOfClass:[object class] name:name];
}

//주어지는 이름을 가진 클래스의 프로퍼티를 찾아 그것의 클래스를 가져온다.
+ (Class)getPropertyClassOfClass:(Class)clazz name:(NSString*)name {
    const char *nm = [name UTF8String];
    objc_property_t p0 = class_getProperty( clazz, nm );
    if( p0 == NULL ) {
        return NULL;
    }
    NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes( p0 )];
    NSArray *attrSplit = [attr componentsSeparatedByString:@"\""];
    //"T@"NSString",R,V_test"에서 NSString만 추출해야 한다.
    NSString *className = nil;
    if ([attrSplit count] >= 2) {
        className = [attrSplit objectAtIndex:1];
    }
    if( className == nil ) return NULL;
    return NSClassFromString( className );
}

//클래스의 프로퍼티 이름을 배열로 가져온다. superInquiry는 해당클래스의 부모클래스 프로퍼티도 탐색할 것인지 결정하는 플래그다.
+ (NSArray*)getPropertyNamesOfClass:(Class)clazz superInquiry:(BOOL)superInquiry{
    if( clazz == NULL || clazz == [NSObject class] ) {
        return nil;
    }
    NSMutableArray *r = [[NSMutableArray alloc] init];
    unsigned int count, i;
    objc_property_t *ps = class_copyPropertyList( clazz, &count );
    for( i = 0; i < count; i++ ) {
        objc_property_t p = ps[i];
        const char *pn = property_getName( p );
        if( pn ) {
            [r addObject:[NSString stringWithUTF8String:pn]];
        }
    }
    free( ps );
    if( superInquiry ) {
        NSArray *sr = [self getPropertyNamesOfClass:[clazz superclass] superInquiry:YES];
        if( sr != nil ) [r addObjectsFromArray:sr];
    }
    return [NSArray arrayWithArray:r];
}

@end
