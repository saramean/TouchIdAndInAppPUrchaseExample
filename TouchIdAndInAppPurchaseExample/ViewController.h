//
//  ViewController.h
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 10. 31..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mainPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordCreationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (assign, nonatomic) BOOL passwordSet;
@property (strong, nonatomic) IBOutlet UIView *passwordCreationView;
@property (strong, nonatomic) IBOutlet UIView *passwordConfirmView;
@property (strong, nonatomic) KeychainWrapper *keychainWrapperForPassword;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;

- (IBAction)loginWithTouchIDTouched:(id)sender;
- (IBAction)loginBtnTouched:(id)sender;
- (IBAction)passwordCreationConfirmBtnTouched:(id)sender;
- (IBAction)passwordConfirmConfirmBtnTouched:(id)sender;
- (IBAction)passwordConfirmBackBtnTouched:(id)sender;
- (IBAction)resetPasswordTouched:(id)sender;

@end

