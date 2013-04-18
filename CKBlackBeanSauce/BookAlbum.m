//
//  BookAlbum.m
//  CKReader
//
//  Created by Tony Borner on 4/17/13.
//  Copyright (c) 2013 CkStudio. All rights reserved.
//

#import "BookAlbum.h"

@implementation BookAlbum

-(void)dealloc
{
    [_bookAlbumID release];
    [_bookAlbumName release];
    [_bookAlbumDescription release];
    [_bookAlbumThumbnailURLString release];
    [_bookAlbumThumbnail release];
    [_bookAlbumBannerURLString release];
    [_bookAlbumBanner release];
    [super dealloc];
}
@end
