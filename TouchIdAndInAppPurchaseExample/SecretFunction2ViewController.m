//
//  SecretFunction2ViewController.m
//  TouchIdAndInAppPurchaseExample
//
//  Created by Park on 2016. 11. 1..
//  Copyright © 2016년 Parkfantagram /inc. All rights reserved.
//

#import "SecretFunction2ViewController.h"

@interface SecretFunction2ViewController ()

@end

@implementation SecretFunction2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)secretFunction2ViewControllerBactBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
