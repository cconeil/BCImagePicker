//
//  NSDictionary+BCAdditions.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "NSDictionary+BCAdditions.h"

@implementation NSDictionary (BCAdditions)

- (id)bc_objectOfClass:(Class)class forKey:(id)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:class]) {
        return obj;
    } else {
        return nil;
    }
}

- (NSDictionary *)bc_dictionaryForKey:(id)key {
    return [self bc_objectOfClass:[NSDictionary class] forKey:key];
}


@end
