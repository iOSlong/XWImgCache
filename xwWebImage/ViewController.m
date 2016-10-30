//
//  ViewController.m
//  xwWebImage
//
//  Created by xuewu.long on 16/10/26.
//  Copyright © 2016年 xw. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>
#import "FMYImgDownloader.h"
#import "FMYImgManager.h"

@interface ViewController ()<SDWebImageOperation, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) UIImageView *sdImageView;
@property (nonatomic, strong) UIImageView *fmyImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSURL *url = [NSURL URLWithString:@"http://difang.kaiwind.com/tianjin/kpydsy/201404/04/W020140404408118575474.jpg"];
    self.sdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.sdImageView.backgroundColor = [UIColor yellowColor];
//    [self.sdImageView sd_setImageWithURL:url];
    [self.view addSubview:self.sdImageView];
    
    
    
    
    
    
//    [[FMYImgDownloader sharedDownloader] downloadImageWithURL:url options:FMYImgDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        
//    }];
    
    
    
    self.fmyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 250, 100, 100)];
    self.fmyImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.fmyImageView];

//    [[FMYImgDownloader sharedDownloader] downloadImageWithURL:url options:FMYImgDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"%ld",receivedSize);
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        NSLog(@"%@",data);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.fmyImageView.image = image;
//        });
//    }];
    
    
    [[FMYImgManager sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"");
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.fmyImageView.image = image;
    }];
    
    

    
#if 0
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 15;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request];
    [sessionTask resume];

#endif
    
    
}


#pragma mark NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
 
    NSLog(@"");
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;
{
    NSLog(@"");
    // togo dataTaskWithRequest
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask;
{
    NSLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask;
{
    NSLog(@"");
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data;
{
    NSLog(@"");
}


#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    NSLog(@"");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;{
    NSLog(@"");

}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session NS_AVAILABLE_IOS(7_0);
{
    NSLog(@"");
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler;
{
    NSLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSLog(@"");
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
{
    NSLog(@"");
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"error = %@",error);
    // togo downloadTaskWithRequest

}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 获取下载文件缓存路径
    NSLog(@"%@",downloadTask.response.suggestedFilename);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"%@",NSHomeDirectory());
    // togo downloadTaskWithRequest

}

#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"-->%02f",1.0 * totalBytesWritten / totalBytesExpectedToWrite);
    // togo downloadTaskWithRequest
}






@end
