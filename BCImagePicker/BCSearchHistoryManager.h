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

// A list of all searches on the current device.  The searches are in chronological
// order, therefore older searches appear earlier in the array.  The most recent
// search is the last object in the returned array.
- (NSArray *)searches;

// Adds a search to the persitent store on the device
- (void)addSearch:(NSString *)query;

@end
