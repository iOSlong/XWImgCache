//
//  XWImgCache.h
//  xwWebImage
//
//  Created by xuewu.long on 16/10/26.
//  Copyright © 2016年 xw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 枚举缓存图片类型

 - XWImgCacheTypeNone:   图片不在本地做保存
 - XWImgCacheTypeDisk:   磁盘缓存
 - XWImgCacheTypeMemory: 记忆体缓存
 */
typedef NS_ENUM(NSUInteger, XWImgCacheType) {
    XWImgCacheTypeNone,
    XWImgCacheTypeDisk,
    XWImgCacheTypeMemory,
};


typedef void(^XWImgQueryCompleteBlock)(UIImage *image, XWImgCacheType cacheType);



/**
 maintains a memory cache and an optional disk cache。
 */
@interface XWImgCache : NSObject

#pragma mark - come from SDWebView pros
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
 * use memory cache [defaults to YES]
 */
@property (assign, nonatomic) BOOL shouldCacheImagesInMemory;

/**
 * The maximum "total cost" of the in-memory image cache. The cost function is the number of pixels held in memory.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 * The maximum number of objects the cache should hold.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCountLimit;

/**
 * The maximum length of time to keep an image in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;


/**
 Returns global shared cache instance

 @return XWImgCache global instance
 */
+ (XWImgCache *)shareImgCache;

/**
 * Init a new cache store with a specific namespace
 *
 * @param ns The namespace to use for this cache store
 */
- (id)initWithNamespace:(NSString *)ns;

/**
 * Init a new cache store with a specific namespace and directory
 *
 * @param ns        The namespace to use for this cache store
 * @param directory Directory to cache disk images in
 */
- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory;





@end
