//
//  PickerTextField.m
//  Translator
//
//  Created by Kevin Mun Kuang Tzer on 7/7/15.
//  Source code adapted from RogChap http://rogchap.com/2013/08/13/simple-ios-dropdown-control-using-uitextfield/
//

#import "PickerTextField.h"
#import "DropDownArrowView.h"

@interface PickerTextField()
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation PickerTextField

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.layer.borderColor = [[UIColor colorWithRed: 0.827 green: 0.827 blue: 0.827 alpha: 1] CGColor];;
        self.layer.borderWidth= 1.0f;
        
        self.rightView = [DropDownArrowView default];
        self.rightViewMode = UITextFieldViewModeAlways;
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        self.pickerView.showsSelectionIndicator = YES;
        self.inputView = self.pickerView;
    }
    return self;
}

-(void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.pickerView.tag = tag;
}

-(void)setPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate {
    self.pickerView.delegate = pickerDelegate;
}

-(void)setPickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource {
    self.pickerView.dataSource = pickerDataSource;
}

@end
