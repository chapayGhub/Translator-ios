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
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;
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
        
        self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickArrow:)];
        [self.recognizer setNumberOfTouchesRequired:1];
        [self.recognizer setDelegate:self];
        self.rightView.gestureRecognizers = [NSArray arrayWithObjects:self.recognizer, nil];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.showsSelectionIndicator = YES;
        
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleBordered target:self
                                                                       action:@selector(pickerDoneClicked:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexSpace,doneButton, nil]];
        
        self.inputAccessoryView = keyboardDoneButtonView;
        
        self.inputView = self.pickerView;
        self.delegate = self;
    }
    return self;
}

-(void) clickArrow:(id)sender{
    [self becomeFirstResponder];
}

-(void) pickerDoneClicked:(id)sender{
    [self resignFirstResponder];
}

-(void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.pickerView.tag = tag;
}

-(void)setPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate {
    [self.pickerView setDelegate:pickerDelegate];
}

-(void)setPickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource {
    [self.pickerView setDataSource:pickerDataSource];
}

-(void) reloadAllComponents{
    [self.pickerView reloadAllComponents];
}

@end
