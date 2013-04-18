//
//  Constants.h
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#ifndef CKReader_Constants_h
#define CKReader_Constants_h

// 界面尺寸
#define CKINTERFACESIZE ([[UIScreen mainScreen] applicationFrame].size)
#define CKINTERFACEWIDTH (CKINTERFACESIZE.width)
#define CKINTERFACEHEIGHT (CKINTERFACESIZE.height - 44.0 - 50.0)
#define CKINTERFACEISRETINA ([[UIScreen mainScreen] scale] > 1.0)

// 书朋网api地址
extern NSString *kShupengAPIServerURLString;

// 图片CDN服务器地址
extern NSString *kShupengImageServerURLString;

// 图片CDN服务器地址中的尺寸路径
// 32x46
extern NSString *kShupengImageSizeSmall;
// 56x80
extern NSString *kShupengImageSizeMedium;
// 74x105
extern NSString *kShupengImageSizeLarge;
// 100x142
extern NSString *kShupengImageSizeExtraLarge;

// "User-Agent"
extern NSString *kCKReaderUserAgentKey;

// app key
extern NSString *kCKReaderAppKey;

#endif
