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
#import "NSDictionary+BCAdditions.h"

static NSString * const kBaseUrl = @"https://ajax.googleapis.com/ajax/services/search/images";
static NSString * const kVersionNumberKey = @"v";
static NSString * const kVersionNumber = @"1.0";

static NSString * const kResultSizeKey = @"rsz";
const NSInteger BCImageManagerNumberOfImagesPerPage = 8;

static NSString * const kQueryKey = @"q";
static NSString * const kStartKey = @"start";

@interface BCImageManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;

@property (nonatomic, strong, readwrite) NSArray *results;
@property (nonatomic, copy, readwrite) NSString *query;
@property (nonatomic, assign, readwrite) enum BCImageManagerState state;
@property (nonatomic, assign, readwrite) NSInteger pageNumber;

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
    self.state = BCImageManagerStateLoading;
    self.query = query;
    self.pageNumber = 0;

    NSDictionary *parameters = @{ kVersionNumberKey : @"1.0", kResultSizeKey : [NSString stringWithFormat:@"%ld", BCImageManagerNumberOfImagesPerPage], kQueryKey : query };

    self.currentTask = [self.sessionManager GET:kBaseUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *results = responseObject[@"responseData"][@"results"];
        NSArray *imageUrlResults = [results bc_map:^id(id object) {
            return [[BCImageResult alloc] initWithDictionary:object];
        }];

        self.results = imageUrlResults;
        self.state = BCImageManagerStateLoaded;
        
        if (completion) {
            completion(imageUrlResults, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.state = BCImageManagerStateLoaded;
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)loadNextImages:(void (^)(NSArray *, NSError *))completion {
    NSAssert(self.state != BCImageManagerStateLoading, @"You can't load the next page while one is already loading");
    NSAssert(self.state != BCImageManagerStateReachedEnd, @"You've already reached the end of this search");

    self.state = BCImageManagerStateLoading;
    self.pageNumber += 1;

    NSDictionary *parameters = @{ kVersionNumberKey : @"1.0", kResultSizeKey : [NSString stringWithFormat:@"%ld", BCImageManagerNumberOfImagesPerPage], kQueryKey : self.query , kStartKey : [NSString stringWithFormat:@"%ld", BCImageManagerNumberOfImagesPerPage * self.pageNumber] };
    self.currentTask = [self.sessionManager GET:kBaseUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        // Make sure we can still get results
        NSDictionary *responseData = [responseObject bc_dictionaryForKey:@"responseData"];
        if (!responseData) {
            self.state = BCImageManagerStateReachedEnd;

            if (completion) {
                completion(@[], nil);
            }
        } else {
            NSArray *results = responseData[@"results"];
            NSArray *imageUrlResults = [results bc_map:^id(id object) {
                return [[BCImageResult alloc] initWithDictionary:object];
            }];

            self.results = [self.results arrayByAddingObjectsFromArray:imageUrlResults];
            self.state = BCImageManagerStateLoaded;

            if (completion) {
                completion(imageUrlResults, nil);
            }
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.state = BCImageManagerStateLoaded;
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)clear {
    [self.currentTask cancel];
    self.results = @[];
    self.state = BCImageManagerStateEmpty;
    self.pageNumber = 0;
    self.query = @"";
}

@end
