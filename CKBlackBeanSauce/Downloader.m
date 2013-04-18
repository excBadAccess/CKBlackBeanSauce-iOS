//
//  Downloader.m
//  MovieDemo
//
//  Created by Tony Borner on 4/13/13.
//  Copyright (c) 2013 iBokanWisdom. All rights reserved.
//

#import "Downloader.h"

@interface Downloader ()

// 网络连接对象
@property (nonatomic, retain) NSURLConnection *connection;
// 请求对象
@property (nonatomic, retain) NSURLRequest *request;

@end

@implementation Downloader

@synthesize delegate = _delegate;
@synthesize responseData = _responseData;
@synthesize connection = _connection;
@synthesize request = _request;

// 便利构造器，使用此方法创建Downloader对象会立刻开始网络请求
+(id)downloaderWithRequest:(NSURLRequest *)request delegate:(id<DownloaderDelegate>)delegate
{
    Downloader *downloader = [[Downloader alloc] initWithRequest:request delegate:delegate];
    [downloader start];
    return [downloader autorelease];
}

// 便利初始化方法
-(id)initWithRequest:(NSURLRequest *)request delegate:(id<DownloaderDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.request = request;
        self.delegate = delegate;
        
        // 创建好网络连接对象
        if (self.request)
        {
            self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        }
    }
    return self;
}

-(void)start
{
    if (self.request)
    {
        // 输出请求数据
        NSString *requestString = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
        //NSLog(@"==========REQUEST==========");
        //NSLog(@"%@", requestString);
        [requestString release];

        // 开始异步网络请求
        [self.connection start];
    }
}

#pragma mark - NSURLConnectionDataDelegate protocol methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [NSMutableData data];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 输出响应数据
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"==========RESPONSE==========");
    NSLog(@"%@", responseString);
    [responseString release];
    
    // 通知代理对象请求已成功
    [self.delegate downloaderDidFinish:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection failed with error: %@", [error localizedDescription]);
    
    // 清除已接收的数据
    self.responseData = nil;
    
    // 通知代理对象请求已失败
    [self.delegate downloaderFailed:self];
}

@end
