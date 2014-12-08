//
//  NSArray+BCAdditions.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BCAdditions)

- (NSArray *)bc_map:(id (^)(id object))block;

@end
