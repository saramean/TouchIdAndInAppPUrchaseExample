//
//  ViewController.m
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 10. 31..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //set frame of subviews
    [self.passwordCreationView setFrame:self.view.frame];
    [self.passwordConfirmView setFrame:self.view.frame];
    //set textfield delegate
    self.mainPasswordTextField.delegate = self;
    self.passwordCreationTextField.delegate = self;
    self.passwordConfirmTextField.delegate = self;
    //initialize keychain
    self.keychainWrapperForPassword = [[KeychainWrapper alloc] init];
    //check existing password
    self.passwordSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"passwordSet"];
    self.resetPasswordBtn.enabled = self.passwordSet;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate for limiting string number
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if((self.mainPasswordTextField.text.length >= 4) && self.mainPasswordTextField.isFirstResponder && range.length == 0){
        return NO;
    }
    else if ((self.passwordCreationTextField.text.length >= 4) && self.passwordCreationTextField.isFirstResponder && range.length == 0){
        return NO;
    }
    else if ((self.passwordConfirmTextField.text.length >= 4) && self.passwordConfirmTextField.isFirstResponder && range.length == 0){
        return NO;
    }
    return YES;
}


//if password is not set, show password creation view
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == self.mainPasswordTextField){
        if(!self.passwordSet){
            textField.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view addSubview:self.passwordCreationView];
                [self.passwordCreationTextField becomeFirstResponder];
            });
        }
        else{
            textField.inputView = nil;
        }
    }
    else{
        textField.inputView = nil;
    }
}

//Login with Touch ID
- (IBAction)loginWithTouchIDTouched:(id)sender {
    LAContext *contextForAuth = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *reasonForTouchID = @"Test application to practice Touch ID example";
    
    if([contextForAuth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
        [contextForAuth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonForTouchID reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                NSLog(@"success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"authenticationSuccess" sender:self];
                });
            }
            else{
                NSLog(@"failed error is %@",error);
            }
        }];
    }
    else{
        NSLog(@"auth error %@", authError);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Touch ID is not Available" message:@"Check your Touch ID setting again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (IBAction)loginBtnTouched:(id)sender {
    NSLog(@"%@",[self.keychainWrapperForPassword myObjectForKey:(__bridge id)kSecValueData]);
    if([self.mainPasswordTextField.text isEqualToString:[self.keychainWrapperForPassword myObjectForKey:(__bridge id)kSecValueData]]){
        self.mainPasswordTextField.text = nil;
        [self performSegueWithIdentifier:@"authenticationSuccess" sender:self];
    }
    else{
        NSLog(@"fail to login");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect Password" message:@"Check your password again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)passwordCreationConfirmBtnTouched:(id)sender {
    if(self.passwordCreationTextField.text.length == 4){
        [self.keychainWrapperForPassword mySetObject:self.passwordCreationTextField.text forKey:(__bridge id)kSecValueData];
        [self.keychainWrapperForPassword writeToKeychain];
        [self.passwordCreationView addSubview:self.passwordConfirmView];
        [self.passwordConfirmTextField becomeFirstResponder];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Type 4-digit Number" message:@"Password should be a 4-digit number" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)passwordConfirmConfirmBtnTouched:(id)sender {
    NSString *password = [self.keychainWrapperForPassword myObjectForKey:(__bridge id)kSecValueData];
    if([password isEqualToString:self.passwordConfirmTextField.text]){
        self.passwordSet = YES;
        self.resetPasswordBtn.enabled = self.passwordSet;
        [[NSUserDefaults standardUserDefaults] setBool:self.passwordSet forKey:@"passwordSet"];
        [self.passwordConfirmView removeFromSuperview];
        [self.passwordCreationView removeFromSuperview];
        [self.passwordConfirmTextField resignFirstResponder];
    }
    else{
        NSLog(@"different");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password is different" message:@"Password you typed is different from the one you typed before" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)passwordConfirmBackBtnTouched:(id)sender {
    [self.passwordConfirmView removeFromSuperview];
    [self.passwordCreationTextField becomeFirstResponder];
}

- (IBAction)resetPasswordTouched:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passwordSet"];
    self.passwordSet = NO;
    self.resetPasswordBtn.enabled = self.passwordSet;
    [self.keychainWrapperForPassword resetKeychainItem];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *webViewController = [segue destinationViewController];
    webViewController.keychainWrapperForPassword = self.keychainWrapperForPassword;
}

@end
