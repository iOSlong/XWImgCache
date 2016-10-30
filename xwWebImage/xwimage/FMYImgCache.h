//
//  FMYImgCache.h
//  xwWebImage
//
//  Created by xuewu.long on 16/10/30.
//  Copyright © 2016年 fmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDImageCache.h>

@interface FMYImgCache : NSObject
/**
 * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
 * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
 */
@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 *  disable iCloud backup [defaults to YES]
 */
@property (assign, nonatomic) BOOL shouldDisableiCloud;

/**
 * The maximum length of time to keep an image in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;


+ (FMYImgCache *)shareImgCache;

- (id)initWithNamespace:(NSString *)ns;

- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory;

-(NSString *)makeDiskCachePath:(NSString*)fullNamespace;

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(SDWebImageQueryCompletedBlock)doneBlock;



- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;


- (NSString *)defaultCachePathForKey:(NSString *)key;

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion;

- (void)clearDisk;

- (void)cleanDiskWithCompletionBlock:(SDWebImageNoParamsBlock)completionBlock;




@end
