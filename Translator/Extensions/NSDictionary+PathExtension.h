//
//  NSDictionary+PathExtension.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(PathExtension)

/**
 * Simplify dictionary traversing. Returns object, of nsdictionary type, specified by path, similar to xpath in a way.
 *
 * Example:
 * @code
 *   NSDictionary *json = ... a JSON-generated dictionary
 *   NSObject *value = [dict objectForPath: @"branch.leaf"];
 * @endcode
 * Returned value will be set to value of key leaf
 */
- (NSObject *) objectForPath: (NSString *) path;

@end
