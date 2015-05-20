//
//  LoginController.m
//  Trial
//
//  Created by Henry Kean on 5/8/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//


#import "LoginController.h"
#import <Spotify/Spotify.h>
#import "Config.h"
#import "InfoViewController.h"

@interface LoginController () <SPTAuthViewDelegate>

@property (atomic, readwrite) SPTAuthViewController *authViewController;
@property (atomic, readwrite) BOOL firstLoad;
@property (atomic, readwrite) InfoViewController *infoWindow;
@end

@implementation LoginController


- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdatedNotification:) name:@"sessionUpdated" object:nil];
    
    self.statusLabel.text = @"";
    self.firstLoad = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)sessionUpdatedNotification:(NSNotification *)notification {
    self.statusLabel.text = @"";
    if(self.navigationController.topViewController == self) {
        SPTAuth *auth = [SPTAuth defaultInstance];
        if (auth.session && [auth.session isValid]) {
            
            [self performSegueWithIdentifier:@"ShowInfo" sender:nil];
//            [self performSegueWithIdentifier:@"ShowPlayer" sender:nil];
        }
    }
}

//-(void)showPlayer {
-(void)showInfo {
    self.firstLoad = NO;
    self.statusLabel.text = @"Logged in.";
    [self performSegueWithIdentifier:@"ShowInfo" sender:nil];
//    [self performSegueWithIdentifier:@"ShowPlayer" sender:nil];
}

- (void)authenticationViewController:(SPTAuthViewController *)viewcontroller didFailToLogin:(NSError *)error {
    self.statusLabel.text = @"Login failed.";
    NSLog(@"*** Failed to log in: %@", error);
}

- (void)authenticationViewController:(SPTAuthViewController *)viewcontroller didLoginWithSession:(SPTSession *)session {
    self.statusLabel.text = @"";
//    [self showPlayer];
    [self showInfo];
}

- (void)authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController {
    self.statusLabel.text = @"Login cancelled.";
}

- (void)openLoginPage {
    self.statusLabel.text = @"Logging in...";
    
    self.authViewController = [SPTAuthViewController authenticationViewController];
    self.authViewController.delegate = self;
    self.authViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.authViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
    [self presentViewController:self.authViewController animated:NO completion:nil];
}


- (void)renewTokenAndShowInfo {
    self.statusLabel.text = @"Refreshing token...";
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        
        if (error) {
            self.statusLabel.text = @"Refreshing token failed.";
            NSLog(@"*** Error renewing session: %@", error);
            return;
        }
//        [self showPlayer];
        [self showInfo];
    }];
}

//- (void)viewWillAppear:(BOOL)animated {
//    SPTAuth *auth = [SPTAuth defaultInstance];
//    
//    // Check if we have a token at all
//    if (auth.session == nil) {
//        self.statusLabel.text = @"";
//        return;
//    }
//    
//    // Check if it's still valid
//    if ([auth.session isValid] && self.firstLoad) {
//        // It's still valid, show the player.
////        [self showPlayer];
//        [self showInfo];
//        return;
//    }
//    
//    // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
//    self.statusLabel.text = @"Token expired.";
//    if (auth.hasTokenRefreshService) {
//        [self renewTokenAndShowInfo];
//        return;
//    }
//    
//    // Else, just show login dialog
//}

//- (void)openInfo {
//    
//    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController * InfoViewController = [storybord   instantiateViewControllerWithIdentifier:@"infoPage"] ;
//    [self presentViewController:InfoViewController animated:YES completion:nil];
//    self.infoWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.infoWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    self.definesPresentationContext = YES;
//    
////    [self presentViewController:self.infoWindow animated:NO completion:nil];
//
//}

//- (IBAction)infoClicked:(id)sender {
//    [self openInfo];
//}



- (IBAction)loginClicked:(id)sender {
    [self openLoginPage];
}

//- (IBAction)clearCookiesClicked:(id)sender {
//    self.authViewController = [SPTAuthViewController authenticationViewController];
//    [self.authViewController clearCookies:nil];
//    self.statusLabel.text = @"Cookies cleared.";
//}




@end