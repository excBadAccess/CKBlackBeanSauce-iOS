//
//  BookAlbum.h
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookAlbum : NSObject

// 图书专辑编号
@property (nonatomic, retain) NSString *bookAlbumID;

// 图书专辑名称
@property (nonatomic, retain) NSString *bookAlbumName;

// 图书专辑简介
@property (nonatomic, retain) NSString *bookAlbumDescription;

// 图书专辑图书数目
@property (nonatomic, assign) NSInteger bookAlbumBookCount;

// 图书专辑缩略图地址
@property (nonatomic, retain) NSString *bookAlbumThumbnailURLString;

// 图书专辑缩略图
@property (nonatomic, retain) UIImage *bookAlbumThumbnail;

// 图书专辑标题图地址
@property (nonatomic, retain) NSString *bookAlbumBannerURLString;

// 图书专辑标题图
@property (nonatomic, retain) UIImage *bookAlbumBanner;

@end
