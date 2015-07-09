//
//  TranslationResult.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/8/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslationResult : NSObject
@property (nonatomic,strong) NSString* translatedPhrase;
@property (nonatomic,strong) NSString* meaning;
@property (nonatomic,strong) NSString* translatedLanguage;
@end
