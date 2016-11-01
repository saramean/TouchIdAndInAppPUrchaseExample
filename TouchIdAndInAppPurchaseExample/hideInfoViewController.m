//
//  HideInfoViewController.m
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 11. 1..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import "HideInfoViewController.h"

@interface HideInfoViewController ()

@end

@implementation HideInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.navigationController.viewControllers);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticateUser) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) authenticateUser{
    LAContext *contextForAuth = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *reasonForTouchID = @"To see this page, please authenticate yourself";
    
    if([contextForAuth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
        [contextForAuth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonForTouchID reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                NSLog(@"success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else{
                NSLog(@"failed error is %@",error);
            }
        }];
    }
    else{
        [self.hideInfoPasswordField becomeFirstResponder];
    }
}


- (IBAction)hideInfoConfirmBtnTouched:(id)sender {
    if([self.hideInfoPasswordField.text isEqualToString:[self.keychainWrapperForPassword myObjectForKey:(__bridge id)kSecValueData]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect Password" message:@"Check your password again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

//delegate for limiting string number
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if((self.hideInfoPasswordField.text.length >= 4) && range.length == 0){
        return NO;
    }
    return YES;
}

@end
