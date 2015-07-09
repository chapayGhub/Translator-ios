//
//  TranslationResultList.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/8/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslationResult.h"
@interface TranslationResultList : NSObject
@property (nonatomic, strong) NSArray* results;

-(void) translateResults:(NSDictionary*)dict error:(NSError**)error;
@end
