//
//  Constants.m
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#include <Foundation/Foundation.h>

// 书朋网api地址
NSString *kShupengAPIServerURLString = @"http://api.shupeng.com";

// 图片CDN服务器地址
NSString *kShupengImageServerURLString = @"http://a.cdn123.net/img";

// 图片CDN服务器地址中的尺寸路径
// 32x46
NSString *kShupengImageSizeSmall = @"/s/";
// 56x80
NSString *kShupengImageSizeMedium = @"/m/";
// 74x105
NSString *kShupengImageSizeLarge = @"/b/";
// 100x142
NSString *kShupengImageSizeExtraLarge = @"/l/";

// "User-Agent"
NSString *kCKReaderUserAgentKey = @"User-Agent";

// app key
NSString *kCKReaderAppKey = @"4152f24284385d823b6a5912314826bb";