//
//  NSObject+Properties.m
//  ALModelManager
//
//  Created by Aiden Lee on 2014. 2. 20..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "NSObject+Properties.h"

@implementation NSObject (Properties)

+ (BOOL)hasProperties
{
    
	unsigned int count = 0;
	objc_property_t *properties = class_copyPropertyList(self, &count);
    free(properties);
    properties = NULL;
	return count != 0;
    
}

+ (BOOL)hasPropertyName:(NSString *)name
{
    
    if (class_getProperty(self, [name UTF8String]) != NULL) {
        return YES;
    }
    // 사용자가 실수로 name의 시작문자를 대문자로 넣었을 경우
    NSString *strPropertyStyleName = [[[name substringToIndex:1] lowercaseString] stringByAppendingString:[name substringFromIndex:1]];
	return class_getProperty(self, [strPropertyStyleName UTF8String]) != NULL;
    
}

+ (SEL)getterForPropertyName:(NSString *)getterName
{
    
	objc_property_t property = class_getProperty(self, [getterName UTF8String]);
	SEL result = [self selectorForPropertyGetter:property];
    
	if (!property || !result) {
        return NULL;
    }
    
	if ([self instancesRespondToSelector:NSSelectorFromString(getterName)] == NO) {
        [NSException raise:NSInternalInconsistencyException
					format:@"target : %@, \n property : '%@' \n result : does not respond to the default getter", self, getterName];
    }
    
	return NSSelectorFromString(getterName);
    
}

+ (SEL)setterForPropertyName:(NSString *)setterName
{
    
	objc_property_t property = class_getProperty(self, [setterName UTF8String]);
	SEL result = [self selectorForPropertyGetter:property];
    
	if (!property || !result) {
        return NULL;
    }
    
    NSString *capitalizedStringName = [[[setterName substringToIndex:1] uppercaseString] stringByAppendingString:[setterName substringFromIndex:1]];
    
	// build a setter name
	NSMutableString *absoluteSetterName = @"set".mutableCopy;
    [absoluteSetterName appendString:capitalizedStringName];
    
	if ([self instancesRespondToSelector:NSSelectorFromString(absoluteSetterName)] == NO) {
        [NSException raise:NSInternalInconsistencyException
					format:@"target : %@, \n property : '%@' \n result : does not respond to the default getter", self, absoluteSetterName];
    }
		
    
	return NSSelectorFromString(absoluteSetterName);
    
}

+ (NSArray *)propertyNames
{
	return [[self class] propertyNamesWithSuperInquiry:NO];
}

+ (NSArray *)propertyNamesWithSuperInquiry:(BOOL)superInquiry
{
    
    unsigned int i, count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    if (!count) {
        free(properties);
        properties = NULL;
		return nil;
	}
    
    // 반환 컨테이너
    NSMutableArray *propertyList = [[NSMutableArray alloc] init];
    
    for(i = 0; i < count; i++) {
        objc_property_t pObject = properties[i];
        const char *propertyName = property_getName(pObject);
        if(propertyName) {
            [propertyList addObject:@(propertyName)];
        }
    }
    free(properties);
    properties = NULL;
    
    // 상위 클래스 프로퍼티 검색
    if(superInquiry) {
        NSArray *arrPropertyNames = [[self superclass] propertyNamesWithSuperInquiry:YES];
        if(!arrPropertyNames) {
            [propertyList addObjectsFromArray:arrPropertyNames];
        }
    }
    return [NSArray arrayWithArray:propertyList];
    
}


#pragma mark -
#pragma mark - Instance Method
- (BOOL)hasProperties
{
    return [[self class] hasProperties];
}

- (BOOL)hasPropertyName:(NSString *)name
{
    return [[self class] hasPropertyName:name];
}

- (SEL)getterForPropertyName:(NSString *)name
{
    return [[self class]getterForPropertyName:name];
}

- (SEL)setterForPropertyName:(NSString *)name
{
    return [[self class] setterForPropertyName:name];
}

- (NSArray *)propertyNames
{
	return [[self class] propertyNames];
}

- (NSArray *)propertyNamesWithSuperInquiry:(BOOL)superInquiry
{
    return [[self class] propertyNamesWithSuperInquiry:superInquiry];
}

#pragma mark -
#pragma mark - Private Method
- (SEL)selectorForPropertyGetter:(objc_property_t)property
{
    const char * attrs = property_getAttributes(property);
	const char * p = strstr(attrs, ",G");
    
    if (!attrs || !p) {
        return NULL;
    }
	
	p += 2;
	const char * e = strchr(p, ',');
	if ( e == NULL ) {
        return (sel_getUid(p));
    } else if (e == p) {
        return NULL;
    }
    
	int len = (int)(e - p);
	char * selPtr = malloc( len + 1 );
	memcpy(selPtr, p, len);
	selPtr[len] = '\0';
	SEL result = sel_getUid(selPtr);
	free(selPtr);
	selPtr = NULL;
	return result;
}

@end


//#pragma mark -
//
//SEL selectorForPropertyGetter(objc_property_t property)
//{
//    
//	const char * attrs = property_getAttributes(property);
//	const char * p = strstr(attrs, ",G");
//    
//    if (!attrs || !p) {
//        return NULL;
//    }
//	
//	p += 2;
//	const char * e = strchr(p, ',');
//	if ( e == NULL ) {
//        return (sel_getUid(p));
//    } else if (e == p) {
//        return NULL;
//    }
//    
//	int len = (int)(e - p);
//	char * selPtr = malloc( len + 1 );
//	memcpy(selPtr, p, len);
//	selPtr[len] = '\0';
//	SEL result = sel_getUid(selPtr);
//	free(selPtr);
//	selPtr = NULL;
//	return result;
//    
//}
//
//SEL property_getSetter( objc_property_t property )
//{
//    
//    const char * attrs = property_getAttributes(property);
//	const char * p = strstr(attrs, ",S");
//    
//	if (!attrs || !p) {
//        return NULL;
//    }
//	
//	p += 2;
//	const char * e = strchr(p, ',');
//	if ( e == NULL ) {
//        return (sel_getUid(p));
//    } else if (e == p) {
//        return NULL;
//    }
//	
//	int len = (int)(e - p);
//	char * selPtr = malloc(len + 1);
//	memcpy(selPtr, p, len);
//	selPtr[len] = '\0';
//	SEL result = sel_getUid(selPtr);
//	free(selPtr);
//	selPtr = NULL;
//	return result;
//    
//}

