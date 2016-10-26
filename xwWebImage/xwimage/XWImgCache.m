//
//  XWImgCache.m
//  xwWebImage
//
//  Created by xuewu.long on 16/10/26.
//  Copyright © 2016年 xw. All rights reserved.
//

#import "XWImgCache.h"

@implementation XWImgCache

+ (XWImgCache *)shareImgCache {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns {
    NSString *path = [self makeDiskCachePath:ns];
    return [self initWithNamespace:ns diskCacheDirectory:path];
}

- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory {
    return nil;
}


#pragma mark - XWImgCace(Private)
// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

@end
