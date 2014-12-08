//
//  BCSearchHistoryManager.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "BCSearchHistoryManager.h"

static NSString * const kUserDefaultsKey = @"BCSearchHistoryMangerSearchHistory";

@interface BCSearchHistoryManager()
@property (nonatomic, strong) NSMutableArray *queries;
@end

@implementation BCSearchHistoryManager

+ (BCSearchHistoryManager *)sharedManager {
    static dispatch_once_t once;
    static BCSearchHistoryManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[BCSearchHistoryManager alloc] init];
    });

    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *storedQueries = [[NSUserDefaults standardUserDefaults] arrayForKey:kUserDefaultsKey];
        _queries = storedQueries ? [storedQueries mutableCopy] : [NSMutableArray array];
    }
    return self;
}

- (NSArray *)searches {
    return [self.queries copy];
}

- (void)addSearch:(NSString *)query {
    [self.queries addObject:query];
    [self save];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:self.queries forKey:kUserDefaultsKey];
}

@end
