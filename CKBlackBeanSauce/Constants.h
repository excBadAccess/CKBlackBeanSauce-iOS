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

// 豆瓣网api地址(v2)
extern NSString *kDoubanAPIv2URLString;

// 豆瓣网api地址(v1)
extern NSString *kDoubanAPIv1URLString;

// app key
extern NSString *kCKBlackBeanSauceAppKey;

#endif
