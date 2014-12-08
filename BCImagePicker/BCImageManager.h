//
//  BCImageManager.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ENUM(NSInteger, BCImageManagerState) {
    BCImageManagerStateEmpty = 0,
    BCImageManagerStateLoading,
    BCImageManagerStateLoaded,
    BCImageManagerStateReachedEnd
};

extern const NSInteger BCImageManagerNumberOfImagesPerPage;

@interface BCImageManager : NSObject

@property (nonatomic, strong, readonly) NSArray *results;
@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, assign, readonly) enum BCImageManagerState state;
@property (nonatomic, assign, readonly) NSInteger pageNumber;

+ (BCImageManager *)sharedManager;

// Load the first page of images
- (void)loadImagesWithQuery:(NSString *)query completion:(void(^)(NSArray *results, NSError *error))completion;

// Load the next page of images
- (void)loadNextImages:(void(^)(NSArray *results, NSError *error))completion;

// Clears all of the state of the image manager and cancels any pending requests
- (void)clear;

@end
