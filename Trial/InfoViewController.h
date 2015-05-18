//
//  Info ViewController.h
//  Trial
//
//  Created by Henry Kean on 5/18/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"
#import <Spotify/Spotify.h>
@interface InfoViewController : UIViewController<SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backToLogin;

@end
