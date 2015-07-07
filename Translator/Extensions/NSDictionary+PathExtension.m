//
//  NSDictionary+PathExtension.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import "NSDictionary+PathExtension.h"

@implementation NSDictionary(PathExtension)

- (NSObject *) objectForPath: (NSString *) path; {
    NSAssert (path != nil, @"path is nil");
    NSArray *steps = [path componentsSeparatedByString: @"."];
    NSUInteger nsteps = [steps count];
    NSAssert (nsteps > 0, @"path is empty");
    NSObject *target = self;
    @try {
        for (NSString *step in steps) {
            if (target == nil || ![target isKindOfClass: [NSDictionary class]])
                break;
            target = [(NSDictionary *) target objectForKey: step];
        }
    }
    @catch (NSException * e) {
        target = nil;
    }
    return target;
}

@end