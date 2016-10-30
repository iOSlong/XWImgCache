//
//  FMYImgManager.h
//  xwWebImage
//
//  Created by xuewu.long on 16/10/30.
//  Copyright © 2016年 fmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>
#import "FMYImgCache.h"


@class FMYImgManager;
@protocol FMYImgManagerDelegate <NSObject>
@optional
- (BOOL)imageManager:(FMYImgManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL;

- (UIImage *)imageManager:(FMYImgManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL;
@end


@interface FMYImgManager : NSObject
@property (weak, nonatomic) id <FMYImgManagerDelegate> delegate;

@property (strong, nonatomic, readonly) FMYImgCache *imgCache;
@property (strong, nonatomic, readonly) SDWebImageDownloader *imageDownloader;



+ (FMYImgManager *)sharedManager;

- (NSString *)cacheKeyForURL:(NSURL *)url;


- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;


@end
