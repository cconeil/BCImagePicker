//
//  BCImageManager.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "BCImageManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSArray+BCAdditions.h"
#import "BCImageResult.h"

NSString * const BCImageManagerFinishedLoadingNotification = @"BCImageManagerFinishedLoadingNotification";

static NSString * const kBaseUrl = @"https://ajax.googleapis.com/ajax/services/search/images";
static NSString * const kVersionNumberKey = @"v";
static NSString * const kVersionNumber = @"1.0";

static NSString * const kResultSizeKey = @"rsz";
static NSString * const kResultSize = @"8";

static NSString * const kQueryKey = @"q";

@interface BCImageManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, copy, readwrite) NSString *query;
@property (nonatomic, assign, readwrite) enum BCImageManagerState state;

@end

@implementation BCImageManager

+ (BCImageManager *)sharedManager {
    static dispatch_once_t once;
    static BCImageManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[BCImageManager alloc] init];
    });

    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        _results = @[];
    }
    return self;
}

- (void)loadImagesWithQuery:(NSString *)query completion:(void (^)(NSArray *, NSError *))completion {
    self.query = query;

    NSDictionary *parameters = @{ kVersionNumberKey : @"1.0", kResultSizeKey : kResultSize, kQueryKey : query };
    [self.sessionManager GET:kBaseUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *results = responseObject[@"responseData"][@"results"];
        NSArray *imageUrlResults = [results bc_map:^id(id object) {
            return [[BCImageResult alloc] initWithDictionary:object];
        }];

        self.results = [self.results arrayByAddingObjectsFromArray:imageUrlResults];
        
        if (completion) {
            completion(imageUrlResults, nil);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:BCImageManagerFinishedLoadingNotification object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:BCImageManagerFinishedLoadingNotification object:nil];
    }];
}

- (void)loadNextImages:(void (^)(NSArray *, NSError *))completion {

}

@end
