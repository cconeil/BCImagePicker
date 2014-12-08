//
//  BCImageResult.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "BCImageResult.h"

static NSString * const kThumbnailUrlKey = @"tbUrl";
static NSString * const kImageUrlKey = @"url";

static NSString * const kThumbnailHeightKey = @"tbHeight";
static NSString * const kImageHeightKey = @"height";

static NSString * const kThumbnailWidthKey = @"tbWidth";
static NSString * const kImageWidthKey = @"width";


@implementation BCImageResult

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {

        _thumbnailImageUrl = [dictionary[kThumbnailUrlKey] copy];
        _imageUrl = [dictionary[kImageUrlKey] copy];

        _thumbnailHeight = [dictionary[kThumbnailHeightKey] doubleValue];
        _height = [dictionary[kImageHeightKey] doubleValue];

        _thumbnailWidth = [dictionary[kThumbnailWidthKey] doubleValue];
        _width = [dictionary[kImageWidthKey] doubleValue];
    }
    return self;
}

@end
