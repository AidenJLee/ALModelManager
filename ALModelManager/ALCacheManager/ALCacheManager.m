//
//  ALCacheManager.m
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

#import "ALCacheManager.h"

@implementation ALCacheManager

#pragma mark -
#pragma mark Singleton Creation & Destruction Method

static ALCacheManager *__instance = nil;
+ (ALCacheManager *)sharedInstance
{
    if (!__instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __instance = [[ALCacheManager alloc] init];
        });
    }
    return __instance;
    
}

+ (void)releaseSharedInstance
{
//    @synchronized(self)
//    {
        __instance = nil;
//    }
    
}


#pragma mark -
#pragma mark Init

- (id)init
{
    
    self = [super init];
    if (self) {
        _strPrefix    = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];;
        _URLCachePath = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    }
    return self;
    
}


#pragma mark -
#pragma mark Cache Method Implement
/**
 *  Cache되어 있는 UIImage를 가져오는 메소드
 *  데이터가 없거나 잘못 되었다고 판단되면 삭제 후 nil반환
 *
 *  @param URL 서버의 이미지 URL 주소거나 로컬 URL 주소
 *
 *  @return A newly created UIImage instance or nil
 */
- (UIImage *)imageForURL:(NSURL *)URL
{
    
    if (!URL) {
        return nil;
    }
    
    NSURL *destinationPath = [self getDestinationURLPathWithURL:URL];
    
    NSError *error = nil;
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:destinationPath options:NSDataReadingUncached error:&error]];
    
    // 이미지가 정상적이지 않으면 삭제 한다.
    if (!image) {
        NSError *removeError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:destinationPath error:&removeError];
    }
    
    return image;
    
}

- (UIImage *)imageForURLString:(NSString *)URLString
{
    return [self imageForURL:[NSURL URLWithString:URLString]];
}


/**
 *  Cache되어 있는 NSData를 가져오는 메소드
 *  데이터가 없거나 잘못 되었다고 판단되면 삭제 후 nil반환
 *
 *  @param URL 서버의 데이터 URL 주소거나 로컬 데이터 URL 주소
 *
 *  @return A newly created NSData instance
 */
- (NSData *)dataForURL:(NSURL *)URL
{
    
    if (!URL) {
        return nil;
    }
    
    NSURL *destinationPath = [self getDestinationURLPathWithURL:URL];
    
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:destinationPath options:NSDataReadingUncached error:&error];
    
    // 데이터가 정상적이지 않으면 삭제 한다.
    if (!data) {
        [[NSFileManager defaultManager] removeItemAtURL:destinationPath error:NULL];
    }
    
    return data;
    
}

- (NSData *)dataForURLString:(NSString *)URLString
{
    return [self dataForURL:[NSURL URLWithString:URLString]];
}


/**
 *  Cache되어 있는 Data를 지우는 메소드
 *
 *  @param URL 서버의 데이터 URL 주소거나 로컬 데이터 URL 주소
 *
 *  @return 메소드 실행 결과가 boolean형태로 반환된다.
 */
- (BOOL)removeDataForURL:(NSURL *)URL
{
    NSURL *destinationPath = [self getDestinationURLPathWithURL:URL];
    return [[NSFileManager defaultManager] removeItemAtURL:destinationPath error:NULL];
    
}

- (BOOL)removeDataForURLString:(NSString *)URLString
{
    return [self removeDataForURL:[NSURL URLWithString:URLString]];
}


/**
 *  Data를 저장하는 메소드
 *  'URL값은 고유하다'라는 전제하에
 *  서버에서 다운받는 URL주소를 기반으로 폴더를 생성하고 데이터를 저장한다.
 *
 *  @param data 저장 하려는 데이터
 *  @param URL  서버의 데이터 URL 주소거나 로컬 데이터 URL 주소
 *
 *  @return 실행 결과가 boolean형태로 반환된다.
 */
- (BOOL)saveData:(NSData *)data withURL:(NSURL *)URL
{
    
    NSURL *destinationPath = [self getDestinationURLPathWithURL:URL];
    
    // Directory 생성하기
    NSError *createError = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtURL:[destinationPath URLByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&createError]) {
        return NO;
    }
    
    NSError *error = nil;
    return [data writeToURL:destinationPath options:NSDataWritingFileProtectionComplete error:&error];
    
}

- (BOOL)saveData:(NSData *)data withURLString:(NSString *)URLString
{
    return [self saveData:data withURL:[NSURL URLWithString:URLString]];
}


/**
 *  파일 경로를 가져오는 메소드
 *
 *  @param URL 파일 경로의 Path
 *
 *  @return URL형태의 최종 경로
 */
- (NSURL *)getDestinationURLPathWithURL:(NSURL *)URL
{
    return [self.URLCachePath URLByAppendingPathComponent:[self.strPrefix stringByAppendingString:[URL path]]].absoluteURL;
}

/**
 *  파일 경로를 가져오는 메소드
 *
 *  @param URL 파일 경로의 Path
 *
 *  @return String형태의 최종 경로
 */
- (NSString *)getDestinationStringWithURL:(NSURL *)URL
{
    return [self.URLCachePath URLByAppendingPathComponent:[self.strPrefix stringByAppendingString:[URL path]]].absoluteString;
}



/**
 *  Cache용량이 일정 수준을 넘는지 체크 후 지우는 메소드
 *
 *  @param limit 데이터 삭제 기준 용량
 */
- (void)cleanStorageForLimit:(long long int)limit
{
    
    NSURL *cacheURLPath = [self.URLCachePath URLByAppendingPathComponent:self.strPrefix];
    
    // 로컬에 저장 된 파일 사이즈가 Limit을 넘으면 삭제한다
    long long int cachefileSizes = [self cacheSizeForURL:cacheURLPath];
    
    if (cachefileSizes > limit) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] removeItemAtURL:cacheURLPath error:&error]) {
            NSLog(@"Remove Error : %@", [error description]);
        }
    }
    
}

#pragma mark -
#pragma mark - Private Method

// 로컬 파일 사이즈 체크
- (unsigned long long int)cacheSizeForURL:(NSURL *)URLPath {
    
    NSArray *arrCacheFileList = [[NSFileManager defaultManager] subpathsAtPath:[URLPath path]];
    NSEnumerator *cacheEnumerator = [arrCacheFileList objectEnumerator];
    NSString *strCacheFilePath = nil;
    
    unsigned long long int datasSize = 0;
    NSError *error = nil;
    
    while (strCacheFilePath = [cacheEnumerator nextObject]) {
        NSDictionary *dicCacheFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[[URLPath path] stringByAppendingPathComponent:strCacheFilePath] error:&error];
        datasSize += [dicCacheFileAttributes fileSize];
    }
    NSLog(@"Local storage File Size = %lld", datasSize);
    return datasSize;
    
}

@end

/*
 
 URL 주소 예제
 NSLog(@" %@", [[NSURL URLWithString:@"foo" relativeToURL:baseURL] absoluteString]);                  // http://example.com/v1/foo
 NSLog(@" %@", [[NSURL URLWithString:@"foo?bar=baz" relativeToURL:baseURL] absoluteString]);          // http://example.com/v1/foo?bar=baz
 NSLog(@" %@", [[NSURL URLWithString:@"/foo" relativeToURL:baseURL] absoluteString]);                 // http://example.com/foo
 NSLog(@" %@", [[NSURL URLWithString:@"foo/" relativeToURL:baseURL] absoluteString]);                 // http://example.com/v1/foo
 NSLog(@" %@", [[NSURL URLWithString:@"foo/foo?bar=baz" relativeToURL:baseURL] absoluteString]);      // http://example.com/v1/foo/foo?bar=baz
 NSLog(@" %@", [[NSURL URLWithString:@"/foo/" relativeToURL:baseURL] absoluteString]);                // http://example.com/foo/
 NSLog(@" %@", [[NSURL URLWithString:@"/foo/foo?bar=baz" relativeToURL:baseURL] absoluteString]);     // http://example.com/foo/foo?bar=baz
 NSLog(@" %@", [[NSURL URLWithString:@"http://example2.com/" relativeToURL:baseURL] absoluteString]); // http://example2.com/
 
 */

