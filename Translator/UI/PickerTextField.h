//
//  PickerTextField.h
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Source code adapted from RogChap http://rogchap.com/2013/08/13/simple-ios-dropdown-control-using-uitextfield/
//

#import <UIKit/UIKit.h>

@interface PickerTextField : UITextField<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic) id<UIPickerViewDelegate> pickerDelegate;
@property (nonatomic) id<UIPickerViewDataSource> pickerDataSource;
@property (nonatomic,assign) int selectedRow;
-(void) reloadAllComponents;
@end
