//
//  TranslatorMainTableViewController.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AppController;
@interface TranslatorMainTableViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>
-(instancetype)initWithAppController:(id<AppController>)appController;
@end
