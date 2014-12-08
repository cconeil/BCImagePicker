//
//  BCSearchHistoryManager.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCSearchHistoryManager : NSObject

+ (BCSearchHistoryManager *)sharedManager;

- (NSArray *)searches;
- (void)addSearch:(NSString *)query;

@end
