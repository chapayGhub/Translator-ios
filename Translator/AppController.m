//
//  AppController.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import "AppController.h"
#import "AppPref.h"

@interface AppController()
@property (nonatomic,strong) TranslatorMainTableViewController *translatorMainViewController;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation AppController
static NSString* translationUrl= @"https://glosbe.com/gapi/translate?from=%@&dest=%@&format=json&phrase=%@&page=%d&pageSize=%d";
-(void) onLaunch{
    [self setup];
    [self launchTranslatorMainScreen];
    [self.window makeKeyAndVisible];
}

-(void) setup {
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
}

-(void) launchTranslatorMainScreen{
    self.translatorMainViewController = [self constructMainViewController];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:self.translatorMainViewController];
    self.window.rootViewController = navController;
}


#pragma mark api calls; can be delegated to a restmanager class
-(void) getLanguageData:(void (^)(NSArray *, NSError *)) handler{
    NSArray *languagesData = [AppPref getLanguages];
    NSMutableArray *languages = [[NSMutableArray alloc] initWithCapacity:[languagesData count]];
    for(NSDictionary *dict in languagesData){
        Language *language = [[Language alloc]init];
        language.languageName = NSLocalizedString([dict valueForKey:@"language_key"],nil);
        language.languageCode = [dict valueForKey:@"language_iso"];
        [languages addObject:language];
    }
    handler(languages,nil);
}

-(void) getTranslationResult:(NSString*)phrase from:(Language*)fromLanguage to:(Language*)toLanguage page:(int)page pageSize:(int)pageSize completion:(void(^)(TranslationResultList *, NSError *))handler{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:translationUrl, fromLanguage.languageCode,toLanguage.languageCode,phrase,page,pageSize]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:&error];
        TranslationResultList *resultList = [[TranslationResultList alloc]init];
        [resultList translateResults:jsonDic error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler!=nil)
                handler(resultList,error);
        });
    });

}

#pragma mark nibs construction; can be delegated to a factory class
-(TranslatorMainTableViewController *) constructMainViewController{
    TranslatorMainTableViewController* vc = [[TranslatorMainTableViewController alloc]initWithAppController:self];
    return vc;
}
@end
