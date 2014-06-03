//
//  SLEViewController.m
//  Memoria
//
//  Created by Simon Tsai on 3/15/14.
//  Copyright (c) 2014 Blue Moon. All rights reserved.
//

#import "SLEWelcomeViewController.h"

#import "SLEStandardInputAccessoryViewToolbar.h"

typedef NS_ENUM(NSInteger, SLEWelcomeViewControllerTextFieldTag) {
    
    SLEWelcomeViewControllerTextFieldTagName = 0,
    SLEWelcomeViewControllerTextFieldTagPasscode
};

@interface SLEWelcomeViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sloganLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

/* Nil if there is no first responder.
 */
@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) SLEStandardInputAccessoryViewToolbar *passcodeInputAccessory;

@property (assign, nonatomic) BOOL didUserInputPasscode;

@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) NSInteger userPasscode;

@end

@implementation SLEWelcomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)]];
    
    [self prepareTextFieldTags];
}

#pragma mark
#pragma mark - Property Override

#pragma mark - Private - |passcodeInputAccessory|

- (SLEStandardInputAccessoryViewToolbar *)passcodeInputAccessory {
    
    if (_passcodeInputAccessory == nil) {
        
        __strong typeof(self) weakSelf = self;
        
        _passcodeInputAccessory = [SLEStandardInputAccessoryViewToolbar standardInputAccessoryViewToolbar];
        _passcodeInputAccessory.cancelTapped = ^{
            
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dismissKeyboard:nil];
        };
        _passcodeInputAccessory.doneTapped = ^{
            
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf dismissKeyboard:nil];
        };
    }
    
    return _passcodeInputAccessory;
}

#pragma mark
#pragma mark - Preparation

#pragma mark - Tags

- (void)prepareTextFieldTags {
    
    self.nameTextField.tag = SLEWelcomeViewControllerTextFieldTagName;
    self.passcodeTextField.tag = SLEWelcomeViewControllerTextFieldTagPasscode;
}

#pragma mark
#pragma mark - Private Methods

#pragma mark - Keyboard

- (UIView *)inputAccessoryViewForTextField:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case SLEWelcomeViewControllerTextFieldTagName:
            return nil;
        case SLEWelcomeViewControllerTextFieldTagPasscode:
            return self.passcodeInputAccessory;
    }
    
    return nil;
}

- (UIKeyboardType)keyboardTypeForTextField:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case SLEWelcomeViewControllerTextFieldTagName:
            return UIKeyboardTypeAlphabet;
        case SLEWelcomeViewControllerTextFieldTagPasscode:
            return UIKeyboardTypeNumberPad;
    }
    
    return UIKeyboardTypeDefault;
}

- (UIReturnKeyType)returnKeyTypeForTextField:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case SLEWelcomeViewControllerTextFieldTagName:
            return UIReturnKeyNext;
        case SLEWelcomeViewControllerTextFieldTagPasscode:
            return UIReturnKeyDone;
    }
    
    return UIReturnKeyDone;
}

- (void)dismissKeyboard:(UIGestureRecognizer *)gesureRecognizer {
    
    [self.view endEditing:YES];
    [self textFieldDidEndEditing:self.currentTextField];
    self.currentTextField = nil;
}



#pragma mark - User Defaults

- (void)saveUserInfo {
    
    // TODO: Properly determine if the user has a passcode.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userName forKey:NSUserDefaultsUserNameKey];
    [userDefaults setObject:[NSNumber numberWithInteger:self.userPasscode] forKey:NSUserDefaultsUserPasscodeKey];
    [userDefaults setObject:[NSNumber numberWithBool:self.didUserInputPasscode] forKey:NSUserDefaultsUserHasPasscodeKey];
    [userDefaults setObject:@YES forKey:NSUserDefaultsIsNotFirstTimeUserKey];
    [userDefaults synchronize];
}

#pragma mark - Text Fields

- (BOOL)willReplacementString:(NSString *)replacementString clearTextField:(UITextField *)textField {
    
    return [textField.text length] == 1 && [replacementString length] == 0;
}

#pragma mark
#pragma mark - DataSource/Delegate

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (textField.tag) {
            
        case SLEWelcomeViewControllerTextFieldTagName:
            /* If the length of the text in the name text field is 1 and the the length of the
             * replacement string is 0 (user pressed backspace), then the user has erased all of the
             * input in the name text field.
             */
            if ([self willReplacementString:string clearTextField:textField]) {
                
                self.nextButton.enabled = NO;
            } else {
                
                self.nextButton.enabled = YES;
            }
            
            break;
        case SLEWelcomeViewControllerTextFieldTagPasscode:
            
            break;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.nextButton.enabled = NO;
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.inputAccessoryView = [self inputAccessoryViewForTextField:textField];
    textField.keyboardType = [self keyboardTypeForTextField:textField];
    textField.returnKeyType = [self returnKeyTypeForTextField:textField];
    
    self.currentTextField = textField;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case SLEWelcomeViewControllerTextFieldTagName:
            [self.passcodeTextField becomeFirstResponder];
            break;
        case SLEWelcomeViewControllerTextFieldTagPasscode:
            break;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
            
        case SLEWelcomeViewControllerTextFieldTagName:
            self.userName = textField.text;
            break;
        case SLEWelcomeViewControllerTextFieldTagPasscode:
            // TODO: Add this functionality towards end.
            break;
    }
}

#pragma mark
#pragma mark - IBActions

#pragma mark - Next Button

- (IBAction)handleNextButtonTapped:(id)sender {
    
    [self dismissKeyboard:nil];
    [self saveUserInfo];
    
    if (self.nextButtonTappedBlock != nil) {
        
        self.nextButtonTappedBlock(self);
    }
}

@end
