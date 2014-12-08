//
//  BCImageCollectionViewCell.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "BCImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BCImageCollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BCImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setImageResult:(BCImageResult *)imageResult {
    if (_imageResult == imageResult) {
        return;
    }

    _imageResult = imageResult;

    NSURL *resultUrl = [NSURL URLWithString:imageResult.thumbnailImageUrl];
    __weak BCImageCollectionViewCell *weakSelf = self;
    [self.imageView sd_setImageWithURL:resultUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (resultUrl == imageURL) {
            weakSelf.imageView.image = image;
        }
    }];
}

@end
