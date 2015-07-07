//
//  UIViewController+AppController.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppController.h"
@interface UIViewController(AppController)
@property (nonatomic, weak) id<AppController> appController;
@end
