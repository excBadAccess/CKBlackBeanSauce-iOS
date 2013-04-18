//
//  Downloader.h
//  MovieDemo
//
//  Created by Tony Borner on 4/13/13.
//  Copyright (c) 2013 iBokanWisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloaderDelegate.h"

@interface Downloader : NSObject<NSURLConnectionDataDelegate>

// 执行完成之后的回调代理
@property (nonatomic, assign) id<DownloaderDelegate> delegate;

// 接受返回数据用的NSMutableData对象
@property (nonatomic, retain) NSMutableData *responseData;

// 便利构造器，使用此方法创建Downloader对象会立刻开始网络请求
+(id)downloaderWithRequest:(NSURLRequest *)request delegate:(id<DownloaderDelegate>)delegate;

// 便利初始化方法
-(id)initWithRequest:(NSURLRequest *)request delegate:(id<DownloaderDelegate>)delegate;

// 开始发送网络请求
-(void)start;

@end
