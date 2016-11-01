//
//  HideInfoViewController.h
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 11. 1..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainWrapper.h"
@import LocalAuthentication;

@interface HideInfoViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *hideInfoPasswordField;
@property (strong, nonatomic) KeychainWrapper *keychainWrapperForPassword;

- (IBAction)hideInfoConfirmBtnTouched:(id)sender;
@end
