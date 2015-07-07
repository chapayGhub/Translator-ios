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
@protocol AppController <NSObject>
-(void) onLaunch;

-(TranslatorMainTableViewController *) constructMainViewController;
@end

@interface AppController : NSObject<AppController>

@end
