//
//  DownloaderDelegate.h
//  MovieDemo
//
//  Created by Tony Borner on 4/13/13.
//  Copyright (c) 2013 iBokanWisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Downloader;

@protocol DownloaderDelegate <NSObject>

// 传输成功完成
-(void)downloaderDidFinish:(Downloader *)downloader;
// 传输失败
-(void)downloaderFailed:(Downloader *)downloader;

@end
