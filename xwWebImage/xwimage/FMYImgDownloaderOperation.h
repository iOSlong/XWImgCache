//
//  FMYImgDownloaderOperation.h
//  xwWebImage
//
//  Created by xuewu.long on 16/10/29.
//  Copyright © 2016年 fmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMYImgDownloader.h"


@interface FMYImgDownloaderOperation : NSOperation<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic, readonly) NSURLRequest *request;

@property (strong, nonatomic, readonly) NSURLSessionTask *dataTask;

@property (assign, nonatomic, readonly) FMYImgDownloaderOptions options;

@property (nonatomic, strong) NSURLCredential *credential;

@property (strong, nonatomic) NSURLResponse *response;

@property (assign, nonatomic) NSInteger expectedSize;

@property (assign, nonatomic) BOOL shouldDecompressImages;




- (id)initWithRequest:(NSURLRequest *)request
            inSession:(NSURLSession *)session
              options:(FMYImgDownloaderOptions)options
             progress:(FMYImgDownloaderProgressBlock)progressBlock
            completed:(FMYImgDownloaderCompletedBlock)completedBlock
            cancelled:(FMYImgNoParamsBlock)cancelBlock;













@end
