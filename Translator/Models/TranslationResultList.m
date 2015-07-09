//
//  TranslationResultList.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/8/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import "TranslationResultList.h"
#import "NSDictionary+PathExtension.h"

@implementation TranslationResultList
-(void) translateResults:(NSDictionary*)dict error:(NSError**)error{
    self.results = [self extractResults:dict];
}

-(NSArray*) extractResults:(NSDictionary*)dict{
    NSArray * tuc = (NSArray*)[dict objectForPath:@"tuc"];
    NSMutableArray* resultsArray = [[NSMutableArray alloc] init];
    for(NSDictionary *object in tuc){
        TranslationResult * result = [self translateResult:object];
        if(result!=nil){
            [resultsArray addObject:result];
        } else {
            NSLog(@"failed to translate venue with data: %@", object);
        }
    }
    return resultsArray;
}

-(TranslationResult *) translateResult:(NSDictionary*)rawObject{
    TranslationResult *result = [[TranslationResult alloc] init];
    result.translatedPhrase = (NSString*)[rawObject objectForPath:@"phrase.text"];
    result.translatedLanguage = (NSString*)[rawObject objectForPath:@"phrase.language"];
    NSArray* meanings = (NSArray*)[rawObject objectForPath:@"meanings"];
    if([meanings count]>0){
        NSString * firstMeaning = (NSString*)[[meanings objectAtIndex:0] objectForKey:@"text"];
        result.meaning = firstMeaning;
    }
    return result;
}
@end
