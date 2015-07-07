//
//  AppController.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import "AppController.h"

@interface AppController()
@property (nonatomic,strong) TranslatorMainTableViewController *translatorMainViewController;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation AppController

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

-(TranslatorMainTableViewController *) constructMainViewController{
    TranslatorMainTableViewController* vc = [[TranslatorMainTableViewController alloc]initWithAppController:self];
    return vc;
}
@end
