//
//  ALCacheManager.h
//  ALModelManager
//
//  Created by HoJun Lee on 2014. 2. 11..
//  Copyright (c) 2014년 HoJun Lee. All rights reserved.
//

@import UIKit;

@interface ALCacheManager : NSObject

@property (strong, nonatomic) NSString *strPrefix;
@property (strong, nonatomic) NSURL *URLCachePath;

+ (ALCacheManager *)sharedInstance;
+ (void)releaseSharedInstance;

/**
 *  Cache되어 있는 UIImage를 가져오는 메소드
 *  데이터가 없거나 잘못 되었다고 판단되면 삭제 후 nil반환
 *
 *  @param URL 서버의 이미지 URL 주소거나 로컬 URL 주소
 *
 *  @return A newly created UIImage instance or nil
 */
- (UIImage *)imageForURL:(NSURL *)URL;
- (UIImage *)imageForURLString:(NSString *)URLString;

/**
 *  Cache되어 있는 NSData를 가져오는 메소드
 *  데이터가 없거나 잘못 되었다고 판단되면 삭제 후 nil반환
 *
 *  @param URL 서버의 데이터 URL 주소거나 로컬 데이터 URL 주소
 *
 *  @return A newly created NSData instance
 */
- (NSData *)dataForURL:(NSURL *)URL;
- (NSData *)dataForURLString:(NSString *)URLString;

/**
 *  Cache되어 있는 Data를 지우는 메소드
 *
 *  @param URL 서버의 데이터 URL 주소거나 로컬 데이터 URL 주소
 *
 *  @return 메소드 실행 결과가 boolean형태로 반환된다.
 */
- (BOOL)removeDataForURL:(NSURL *)URL;
- (BOOL)removeDataForURLString:(NSString *)URLString;

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
- (BOOL)saveData:(NSData *)data withURL:(NSURL *)URL;
- (BOOL)saveData:(NSData *)data withURLString:(NSString *)URLString;

/**
 *  파일 경로를 가져오는 메소드
 *
 *  @param URL 파일 경로의 Path
 *
 *  @return URL형태와 String형태의 최종 경로
 */
- (NSURL *)getDestinationURLPathWithURL:(NSURL *)URL;
- (NSString *)getDestinationStringWithURL:(NSURL *)URL;

/**
 *  Cache용량이 일정 수준을 넘는지 체크 후 지우는 메소드
 *
 *  @param limit 데이터 삭제 기준 용량
 */
- (void)cleanStorageForLimit:(long long int)limit;

@end
