//
//  FMYImgDownloader.m
//  xwWebImage
//
//  Created by xuewu.long on 16/10/29.
//  Copyright © 2016年 fmy. All rights reserved.
//

#import "FMYImgDownloader.h"
#import "FMYImgDownloaderOperation.h"
#import <SDWebImage/NSData+ImageContentType.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/SDWebImageCompat.h>
#import "FMYImgCache.h"


static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface FMYImgDownloader () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (strong, nonatomic) NSOperationQueue *downloadQueue;
// The session in which data tasks will run
@property (strong, nonatomic) NSURLSession *session;
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t barrierQueue;
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;
@property (strong, nonatomic) NSMutableArray <NSMutableData *>      *arrayImgData;
@property (strong, nonatomic) NSMutableArray <NSURLSessionTask *>   *arraySessionTask;


@property (copy, nonatomic) FMYImgDownloaderProgressBlock     progressBlock;
@property (copy, nonatomic) FMYImgDownloaderCompletedBlock    completedBlock;
@property (copy, nonatomic) FMYImgNoParamsBlock               cancelBlock;

@end

@implementation FMYImgDownloader
{
    BOOL responseFromCached;
    
}
+ (FMYImgDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _downloadQueue.name = @"com.fmylove.FMYImgDownloader";
        _URLCallbacks = [NSMutableDictionary new];
        _barrierQueue = dispatch_queue_create("com.fmylove.FMYImgDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
        
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = _downloadTimeout;
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                     delegate:self
                                                delegateQueue:nil];
        _arrayImgData       = [NSMutableArray array];
        _arraySessionTask   = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [self.downloadQueue cancelAllOperations];
    SDDispatchQueueRelease(_barrierQueue);
}


- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
}



- (id)downloadImageWithURL:(NSURL *)url
                   options:(FMYImgDownloaderOptions)options
                  progress:(FMYImgDownloaderProgressBlock)progressBlock
                 completed:(FMYImgDownloaderCompletedBlock)completedBlock;
{
    
    
    _completedBlock = [completedBlock copy];
    _progressBlock  = [progressBlock copy];
    
    __block FMYImgDownloaderOperation *operation;
    __weak __typeof(self)weakSelf = self;
    

    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, nil, NO);
        }
        return operation;
    }
    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }
        // Handle single download of simultaneous download request for the same URL
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
        if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;
    });

    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(options & FMYImgDownloaderUseNSURLCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:self.downloadTimeout];
    request.HTTPShouldHandleCookies = (options & FMYImgDownloaderHandleCookies);
    request.HTTPShouldUsePipelining = YES;

    operation = [[FMYImgDownloaderOperation alloc] initWithRequest:request inSession:self.session options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return ;
        __block NSArray *callbacksForURL;
        dispatch_sync(strongSelf.barrierQueue, ^{
            callbacksForURL = [strongSelf.URLCallbacks[url] copy];
        });
        for (NSDictionary *callbacks in callbacksForURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                FMYImgDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                if (callback) callback(receivedSize, expectedSize);
            });
        }
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return ;
        __block NSArray *callbacksForURL;
        dispatch_barrier_sync(strongSelf.barrierQueue, ^{
            callbacksForURL = [strongSelf.URLCallbacks[url] copy];
            if (finished) {
                [strongSelf.URLCallbacks removeObjectForKey:url];
            }
        });
        for (NSDictionary *callbacks in callbacksForURL) {
            FMYImgDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
            if (callback) callback(image, data, error, finished);
        }
    } cancelled:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return ;
        dispatch_barrier_async(strongSelf.barrierQueue, ^{
            [strongSelf.URLCallbacks removeObjectForKey:url];
        });
    }];
    
    
    if (options & FMYImgDownloaderHighPriority) {
        operation.queuePriority = NSOperationQueuePriorityHigh;
    } else if (options & FMYImgDownloaderLowPriority) {
        operation.queuePriority = NSOperationQueuePriorityLow;
    }
    
    [weakSelf.downloadQueue addOperation:operation];
    
    return operation;
}

#pragma mark Helper methods

- (FMYImgDownloaderOperation *)operationWithTask:(NSURLSessionTask *)task {
    FMYImgDownloaderOperation *returnOperation = nil;
    for (FMYImgDownloaderOperation *operation in self.downloadQueue.operations) {
        if (operation.dataTask.taskIdentifier == task.taskIdentifier) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    FMYImgDownloaderOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    FMYImgDownloaderOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    FMYImgDownloaderOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    FMYImgDownloaderOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    FMYImgDownloaderOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}





@end

