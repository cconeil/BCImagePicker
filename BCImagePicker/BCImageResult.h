//
//  BCImageResult.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BCImageResult : NSObject

@property (nonatomic, copy, readonly) NSString *thumbnailImageUrl;
@property (nonatomic, copy, readonly) NSString *imageUrl;

@property (nonatomic, readonly) CGFloat thumbnailHeight;
@property (nonatomic, readonly) CGFloat height;

@property (nonatomic, readonly) CGFloat thumbnailWidth;
@property (nonatomic, readonly) CGFloat width;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
