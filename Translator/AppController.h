//
//  AppController.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslatorMainTableViewController.h"
#import "UIViewController+AppController.h"
#import "Language.h"
#import "TranslationResultList.h"
@protocol AppController <NSObject>
-(void) onLaunch;

/**
 * Get languages data; for now languages option is obtained form a plist, can be modified to get from server data
 *
 */
-(void) getLanguageData:(void (^)(NSArray *, NSError *)) handler;

/**
 * Retrieve translation results from glosbe api
 *
 */
-(void) getTranslationResult:(NSString*)phrase from:(Language*)fromLanguage to:(Language*)toLanguage page:(int)page pageSize:(int)pageSize completion:(void(^)(TranslationResultList *, NSError *))handler;


-(TranslatorMainTableViewController *) constructMainViewController;
@end

@interface AppController : NSObject<AppController>

@end
