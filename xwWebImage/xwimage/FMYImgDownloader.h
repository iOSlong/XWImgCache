//
//  FMYImgDownloader.h
//  xwWebImage
//
//  Created by xuewu.long on 16/10/29.
//  Copyright © 2016年 fmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FMYImgDownloaderOptions) {
    FMYImgDownloaderLowPriority                 = 1 << 0,

    FMYImgDownloaderProgressiveDownload         = 1 << 1,
    FMYImgDownloaderUseNSURLCache               = 1 << 2,

    FMYImgDownloaderIgnoreCachedResponse        = 1 << 3,
    FMYImgDownloaderContinueInBackground        = 1 << 4,

    FMYImgDownloaderHandleCookies               = 1 << 5,
    FMYImgDownloaderAllowInvalidSSLCertificates = 1 << 6,
    FMYImgDownloaderHighPriority                = 1 << 7 ,
};

typedef void(^FMYImgDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^FMYImgDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

typedef NSDictionary *(^FMYImgDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

typedef void(^FMYImgNoParamsBlock)();


@interface FMYImgDownloader : NSObject

@property (assign, nonatomic) NSTimeInterval downloadTimeout;
+ (FMYImgDownloader *)sharedDownloader;


- (id)downloadImageWithURL:(NSURL *)url
                   options:(FMYImgDownloaderOptions)options
                  progress:(FMYImgDownloaderProgressBlock)progressBlock
                 completed:(FMYImgDownloaderCompletedBlock)completedBlock;



- (void)setSuspended:(BOOL)suspended;


- (void)cancelAllDownloads;



@end
