//
//  FunctionChoiceViewController.m
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 11. 1..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import "FunctionChoiceViewController.h"

@interface FunctionChoiceViewController ()

@end

@implementation FunctionChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"authWebViewPresent"]){
//        WebViewController *webViewController = [segue destinationViewController];
//        webViewController.keychainWrapperForPassword = self.keychainWrapperForPassword;
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//    }
//}


- (IBAction)functionChoiceBackBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
