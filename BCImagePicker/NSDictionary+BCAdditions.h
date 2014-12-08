//
//  NSDictionary+BCAdditions.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BCAdditions)

// Returns a dictionary or nil.  This is used mainly to filter out unwanted
// [NSNull null] values returned from the API
- (NSDictionary *)bc_dictionaryForKey:(id)key;

@end
