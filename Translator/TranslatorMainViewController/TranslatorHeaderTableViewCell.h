//
//  TranslatorHeaderTableViewCell.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Copyright (c) 2015 Kevin Mun Kuang Tzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerTextField.h"

@interface TranslatorHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet PickerTextField *fromPicker;
@property (weak, nonatomic) IBOutlet PickerTextField *toPicker;
@property (weak, nonatomic) IBOutlet UIButton *inverseButton;

@end
