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

extern NSString * const BCImageManagerFinishedLoadingNotification;

@interface BCImageManager : NSObject

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, assign, readonly) enum BCImageManagerState state;

+ (BCImageManager *)sharedManager;

- (void)loadImagesWithQuery:(NSString *)query completion:(void(^)(NSArray *results, NSError *error))completion;
- (void)loadNextImages:(void(^)(NSArray *results, NSError *error))completion;

@end
