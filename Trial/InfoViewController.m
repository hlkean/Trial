//
//  Info ViewController.m
//  Trial
//
//  Created by Henry Kean on 5/18/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//
#import "config.h"
#import "InfoViewController.h"
#import "LoginController.h"
#import <Spotify/SPTDiskCache.h>
@interface InfoViewController ()<SPTAudioStreamingDelegate>

@property (atomic, readwrite) LoginController *loginWindow;

@property (atomic, readwrite) InfoViewController *infoWindow;
@property (nonatomic, strong) SPTAudioStreamingController *player;

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

    
- (void)showPlayer {
    
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * ViewController = [storybord   instantiateViewControllerWithIdentifier:@"playerPage"] ;
    [self presentViewController:ViewController animated:YES completion:nil ];
        self.infoWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.infoWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.definesPresentationContext = YES;
    
    //    [self presentViewController:self.infoWindow animated:NO completion:nil];
    
}
    
- (IBAction)infoClicked:(id)sender {
    [self showPlayer];

}

//- (IBAction)logoutClicked:(id)sender {
//    SPTAuth *auth = [SPTAuth defaultInstance];
//    if (self.player) {
//        [self.player logout:^(NSError *error) {
//            auth.session = nil;
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}


//- (void)closePlayer {
//    
////    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////    UIViewController * infoWindow = [storybord   instantiateViewControllerWithIdentifier:@"logInPage"] ;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    self.infoWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.infoWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    self.definesPresentationContext = YES;
//}
//
//- (IBAction)closeClicked:(id)sender {
//    [self closePlayer];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
