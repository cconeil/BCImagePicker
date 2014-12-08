//
//  NSArray+BCAdditions.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "NSArray+BCAdditions.h"

@implementation NSArray (BCAdditions)

- (NSArray *)bc_map:(id (^)(id object))block {
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        id objPrime = block(obj);
        if (objPrime) {
            [result addObject:objPrime];
        }
    }

    return result;
}

@end
