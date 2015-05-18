//
//  Info ViewController.m
//  Trial
//
//  Created by Henry Kean on 5/18/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//

#import "InfoViewController.h"
#import "LoginController.h"
@interface InfoViewController ()

@property (atomic, readwrite) LoginController *loginWindow;

@property (atomic, readwrite) InfoViewController *infoWindow;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    



- (void)closeInfo {
    
//    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController * infoWindow = [storybord   instantiateViewControllerWithIdentifier:@"logInPage"] ;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.infoWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.infoWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
}

- (IBAction)closeClicked:(id)sender {
    [self closeInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
